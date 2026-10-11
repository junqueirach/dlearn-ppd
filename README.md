# dlearn-ppd — DLEARN and its pre-processor, 2001 → 2026

**DLEARN** is the linear static and dynamic finite-element program published with
T.J.R. Hughes' textbook *The Finite Element Method* (1987). **PPD** (*Pré-Processador
DLEARN*) is the program I wrote in 2001, as my civil-engineering graduation project at
UNESP Bauru, to generate DLEARN's punched-card-style input files from a question-and-answer
dialogue — so that researchers testing new time-integration algorithms inside DLEARN could
spend their time on the algorithm instead of on column counting.

This repository is the complete, working package, rebuilt for current machines:

| Directory | What it is | Status |
|---|---|---|
| [`dlearn/zace-1997/`](dlearn/zace-1997/) | DLEARN as distributed by ZACE Services (Lausanne) in 1997: Hughes' code plus the 8-node brick element, with the nine textbook examples | **builds with gfortran, all examples run** |
| [`dlearn/hermitian-2001/`](dlearn/hermitian-2001/) | DLEARN extended at UNESP Bauru (1997–2001) with Prof. Heitor M. Bottura's family of **Hermitian direct-integration algorithms** (orders 1–4) — the research the pre-processor was built for | **builds with gfortran, runs** |
| [`ppd/legacy-pascal/`](ppd/legacy-pascal/) | The original PPD, Turbo Pascal 7 (2001), untouched apart from UTF-8 conversion | historical; three bugs documented |
| [`ppd/python/`](ppd/python/) | **PPD 2.0** — Python library + CLI: build DLEARN inputs from YAML/JSON, read existing `.DAT` files back, validate, convert between the two control-card layouts, run DLEARN | tested, 26 tests, CI |
| [`docs/`](docs/) | The DLEARN input-format specification derived from the Fortran, provenance and licence notes, bibliography, the 2001 thesis (Portuguese PDF and English translation) | |
| [`examples/trelica/`](examples/trelica/) | The worked example of the thesis (6-node, 8-bar truss under a step load) as YAML, as both `.dat` layouts, with reference outputs | |

## Quick start

```sh
# 1. Build the Fortran (any gfortran ≥ 9; on Windows use MSYS2/MinGW or WSL)
(cd dlearn/zace-1997      && make && make check)   # original DLEARN, 10 examples
(cd dlearn/hermitian-2001 && make && make check)   # Hermitian build

# 2. Install the pre-processor
pip install -e ppd/python

# 3. Describe a structure in YAML, check it, build the card file, run it
ppd check examples/trelica/trelica.yaml
ppd build examples/trelica/trelica.yaml -o trelica.dat            # Hermitian layout
ppd build examples/trelica/trelica.yaml -o trelica.dat --layout zace   # original layout
ppd run   examples/trelica/trelica.yaml --dlearn dlearn/hermitian-2001/dlearn -o trelica.out

# 4. Or start from an existing DLEARN file
ppd dump dlearn/zace-1997/examples/TU1.DAT -o tu1.yaml       # .DAT -> YAML
ppd fmt  old.dat --to hermitian -o new.dat                   # re-column / change layout
```

A minimal model in YAML looks like this (full example: [`examples/trelica/trelica.yaml`](examples/trelica/trelica.yaml)):

```yaml
title: UM EXEMPLO DINAMICO DE TRELICA COM VARIOS NOS
analysis: hermitian          # dynamic | static | hermitian
hermitian_order: 2
nsd: 3
ndof: 3
time_sequences:
  - {nstep: 100, ndprt: 1, nsprt: 1, nhplt: 1, niter: 1, alpha: -0.1, beta: 0.3025, gamma: 0.6, dt: 0.023}
coordinates:
  - {node: 1, values: [0, 600, 0], generate: {numgp: 2, points: [[1600, 600, 0]], ninc: [[2, 1]]}}
boundary_conditions:
  - {node: 1, last: 6, inc: 1, codes: [0, 0, 1]}
loads:
  - - {node: 3, values: [0, -1000, 0]}
time_functions:
  - [[0.0, 1.0]]
element_groups:
  - type: truss
    materials: [{e: 210000, rho: 7.3e-6, area: 10}]
    elements:
      - {n: 1, mat: 1, nodes: [1, 2], generate: [[2, 1, 1]]}
```

## Why this exists

DLEARN reads an 80-column, fixed-field input inherited from punched cards (Hughes, ch. 11).
Preparing one by hand is slow and error-prone, and the error shows up only as a Fortran
crash several cards later. The 2001 PPD replaced that with a guided dialogue that
validated each value and placed it in the right column. The 2026 Python version keeps the
same idea with a modern shape:

* a **data model** that mirrors DLEARN's variables (`Model`, `TimeSequence`, `GenEntry`,
  `TrussGroup`, …), so the Fortran, the thesis annex and the code can be read side by side;
* a **writer** that is the only place where column numbers live;
* a **reader** that parses any existing DLEARN file the way the Fortran does, so the
  textbook examples become test cases and old files become editable
  (the "Modificar arquivo" function planned in 2001);
* a **validator** with every range check of the Pascal wizard plus cross-references
  (node/element/material/time-function references, Hermitian size limit, …)
  (the "Conferir arquivo" function planned in 2001);
* **round-trip tests** against the original examples and end-to-end runs through both
  Fortran builds.

## What was learned rebuilding it

Running the 2001 program's output against the Fortran instead of against the thesis
annex surfaced three bugs in the original PPD (and two errors in the annex):

1. The Hermitian order is read in columns **11–15** (`IORDHERM`, right after `IACODE`) and
   dispatches on **1–4**; the annex and the Pascal put it at 21–25 with range 2–8.
   A Hermitian file made with the 2001 PPD is therefore mis-read by DLEARN.
2. The **gravity-vector card is always read** by every element type; the Pascal omits it
   when `LFBODY = 0`, shifting every later card of the group.
3. The run terminator must be lower-case **`*end`**; the Pascal writes `*END`, which DLEARN
   does not recognise (it then stops on end-of-file after writing the results).

Details, with file and line references, in
[`docs/dlearn-input-format.md`](docs/dlearn-input-format.md). The legacy Pascal is kept
exactly as it was; the Python version implements the format as the Fortran reads it.

## Licence and provenance

* **My code** — the Pascal PPD (2001), the Python PPD (2026), the Makefiles, shims, docs and
  examples I wrote — is released under the [MIT License](LICENSE).
* **DLEARN** (`dlearn/zace-1997/src`, and the unmodified parts of `dlearn/hermitian-2001/src`)
  is © 1987 T.J.R. Hughes and is redistributed under the terms printed in its own header:
  free distribution, not to be sold for profit, ownership remains with the authors. The full
  notice is in [`dlearn/LICENSE-DLEARN.txt`](dlearn/LICENSE-DLEARN.txt). It is **not** MIT
  and not an OSI licence; please keep the notice with any copy.
* **The Hermitian extensions** (`HEITOR.FOR`, the `*NEW.FOR` files, and N.C.P. Ferro's 1999
  I/O change) are the research of Prof. Heitor Miranda Bottura (UNESP Bauru) and are
  included with his agreement, for public research use under the same terms as DLEARN —
  see [`dlearn/hermitian-2001/NOTICE.md`](dlearn/hermitian-2001/NOTICE.md).
* The 2001 thesis and the historical record are in [`docs/provenance.md`](docs/provenance.md);
  the literature in [`docs/bibliography.md`](docs/bibliography.md).

If you use this in research, please cite Hughes (1987) for DLEARN, Bottura & Laier (1999)
for the Hermitian algorithms, and this repository for the pre-processor
([`CITATION.cff`](CITATION.cff)).

The 2001 graduation thesis (in Portuguese) is also archived on Zenodo, with a DOI:
[10.5281/zenodo.23123767](https://doi.org/10.5281/zenodo.23123767).

## Repository layout

```
dlearn-ppd/
├── dlearn/
│   ├── LICENSE-DLEARN.txt          Hughes' distribution notice (verbatim)
│   ├── zace-1997/                  original DLEARN + brick element
│   │   ├── src/*.FOR               sources (UTF-8; GFCOMPAT.FOR added)
│   │   ├── examples/*.DAT          nine textbook inputs + TRELICA.DAT, reference/ outputs
│   │   ├── Makefile                make / make check
│   │   └── README.md
│   └── hermitian-2001/             DLEARN + Hermitian algorithms (UNESP)
│       ├── src/*.FOR               sources (two 1-line portability edits, marked)
│       ├── examples/trelica.dat
│       ├── Makefile, run.sh, NOTICE.md, README.md
├── ppd/
│   ├── legacy-pascal/              PPD.PAS, GERAL.PAS, PPD-ZACE.PAS (2001), README.md
│   └── python/                     PPD 2.0: package `ppd`, CLI `ppd`, tests/, README.md
├── docs/
│   ├── dlearn-input-format.md      the card format, from the Fortran
│   ├── provenance.md               history and rights
│   ├── bibliography.md
│   ├── porting-notes.md            what was changed to build in 2026
│   ├── thesis/                     the 2001 graduation thesis (PDF, Portuguese) + English translation
│   └── LEIAME-2001-original.txt    the readme from the 2001 CD
├── examples/trelica/               thesis example: YAML, both .dat layouts, reference outputs
├── .github/workflows/ci.yml        gfortran build + pytest on every push
├── CITATION.cff
└── LICENSE                         MIT (my code only)
```

---

### Resumo em português

Este repositório reúne o **DLEARN** (programa de elementos finitos de T.J.R. Hughes, 1987;
versão ZACE 1997 com elemento de bloco) e a versão estendida na UNESP Bauru com a
**família de algoritmos hermitianos** do Prof. Heitor Miranda Bottura (1997–2001), ambos
compilando com gfortran; o **PPD** original em Turbo Pascal 7 (meu trabalho de conclusão de
curso, 2001); e o **PPD 2.0** em Python, que gera, lê, valida e converte os arquivos de dados
do DLEARN a partir de YAML/JSON. A especificação do formato de entrada foi refeita a partir
dos `READ`/`FORMAT` do Fortran (`docs/dlearn-input-format.md`), o que revelou três erros no
PPD de 2001, documentados. Código meu sob licença MIT; DLEARN e extensões hermitianas sob
a nota de distribuição original de Hughes (livre, não comercial).

*Luiz Eduardo Lollato Junqueira — Regensdorf, 2026. Orientador em 2001: Prof. Dr. Heitor Miranda Bottura.*
