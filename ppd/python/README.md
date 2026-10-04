# ppd — Pre-Processor for DLEARN (Python)

Build, read, validate and convert DLEARN fixed-column input files.

```sh
pip install -e .            # or: pip install -e ".[test]" && pytest
ppd --help
```

| Command | Does |
|---|---|
| `ppd build model.yaml -o model.dat [--layout hermitian\|zace]` | validate and write the card file |
| `ppd check model.yaml` / `ppd check model.dat` | report errors and warnings |
| `ppd dump model.dat -o model.yaml` | parse an existing DLEARN file into YAML |
| `ppd fmt old.dat --to hermitian -o new.dat` | re-write with canonical columns / other layout |
| `ppd run model.yaml --dlearn path/to/dlearn -o model.out` | build and run through a DLEARN executable |

Layouts: `hermitian` (UNESP 2001 build, `IORDHERM` in columns 11–15) and `zace`
(original Hughes / ZACE 1997, no `IORDHERM`). The layout of a `.dat` is auto-detected
from the control card; for YAML the default is `hermitian`.

## Library

```python
from ppd import load_yaml, read_dat, write_dat, to_lines, validate, dump_yaml
from ppd import Model, Control, TimeSequence, GenEntry, BoundaryCondition, TrussGroup, TrussMaterial, ElementEntry

m = read_dat("TU1.DAT")                 # any DLEARN file
for p in validate(m, "zace"): print(p)  # Problem(level, where, message)
m.time_sequences[0].nstep = 200
write_dat(m, "tu1b.dat", layout="zace")
print(dump_yaml(m))

m2 = Model(title="two bars", nsd=3, ndof=3, numnp=3,
           coordinates=[GenEntry(1, [0, 0, 0]), GenEntry(2, [1, 0, 0]), GenEntry(3, [2, 0, 0])],
           boundary_conditions=[BoundaryCondition(1, [1, 1, 1]), BoundaryCondition(1, [0, 0, 1], last=3, inc=1)],
           loads=[[GenEntry(3, [0, -1, 0])]], time_functions=[[(0, 1)]],
           element_groups=[TrussGroup(materials=[TrussMaterial(1, e=1e5, rho=1e-3, area=1)],
                                      elements=[ElementEntry(1, 1, [1, 2], generate=[(2, 1, 1)])])])
m2.control.iacode = 1                   # static
print("\n".join(to_lines(m2, "zace")))
```

Modules: `model` (dataclasses mirroring DLEARN's variables, generation helpers),
`cards` (I5/F10 formatting and parsing, Fortran blank-as-null semantics), `writer`,
`reader` (reads exactly like the Fortran: fixed columns, blank-line terminated blocks,
GENFL/GENEL generation cards), `validate`, `yamlio`, `cli`.

## YAML schema

See [`../../examples/trelica/trelica.yaml`](../../examples/trelica/trelica.yaml) and the
field names in `model.py`. Human aliases: `analysis: dynamic|static|hermitian`,
`kind: displacement|velocity|acceleration`, `type: truss|quad|brick`. `numnp` and each
group's `numel` may be omitted and are then derived from the generated nodes/elements.

## Tests

`pytest` — field formatting; round trip of all nine ZACE examples and the Hermitian example
(read → write → read gives an equal model; validation clean); YAML ↔ model; and, when the
executables in `../../dlearn/*/dlearn` exist, end-to-end runs through both Fortran builds.
