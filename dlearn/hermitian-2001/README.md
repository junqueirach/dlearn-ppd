# DLEARN — Hermitian algorithms build (UNESP Bauru, 2001)

DLEARN extended by Prof. Heitor Miranda Bottura with his **family of Hermitian
direct-integration algorithms** (orders 1–4) for the equation of motion
M ẍ + C ẋ + K x = P(t). This is the program the 2001 PPD was written for.
Authorship and terms: [`NOTICE.md`](NOTICE.md).

How it works (thesis §2.2 b): instead of the effective-mass Crout path of the original,
`km` recovers the global **K** and **M** from the skyline storage, `inverm` forms M⁻¹K, and
`montherm` assembles, for the chosen order, the one-step system

    [M]{x(i+1)} = −[N]{x(i)} + [Q]{p(i+1)} + [R]{p(i)}

solved by `solsispla` at every step; `realoca` maps displacements and velocities back to
DLEARN's arrays and recomputes consistent accelerations from equilibrium so that the
unchanged DLEARN output routines can be used.

## Build and run

```sh
make                       # -> ./dlearn
make check                 # runs examples/*.dat
./run.sh examples/trelica.dat trelica.out
```

The 2001 program asks for the **input and output file names on standard input** (two
lines); `run.sh` and `ppd run` supply them. The original DOS build limited names to 12
characters; this build accepts long paths (see porting notes).

## Input

Same format as DLEARN with one change on the control card: `IORDHERM`, the Hermitian order
(1–4), in **columns 11–15**, right after `IACODE`, which takes the value **2** for a Hermitian
run (0 and 1 still give the original dynamic and static analyses). Full format:
[`../../docs/dlearn-input-format.md`](../../docs/dlearn-input-format.md) (`hermitian` layout).

Limits: dense global matrices in `common /system/` → at most **100 equations**; element
types 1 (quad) and 2 (truss) only; α, β, γ of the time-sequence card are ignored in a
Hermitian run.

## Files

| File | Role |
|---|---|
| `DL.FOR` | main program; interactive file names (N.C.P. Ferro, 1999) |
| `DL0.FOR`, `DL1NEW.FOR`, `DL2NEW.FOR`, `EL2NEW.FOR` | DLEARN core, modified: separate K/M assembly, `driver2`, `IORDHERM` read |
| `HEITOR.FOR` | the Hermitian routines (`km`, `montherm`, `inverm`, `solsispla`, `realoca`) |
| `heitor2.for` | earlier draft of `HEITOR.FOR`; kept for the record, not compiled |
| `QD1NEW.FOR`, `QD2.FOR`, `QD3NEW.FOR` | quadrilateral element |
| `TR0NEW.FOR`, `TR1NEW.FOR` | truss element |
| `BR1.FOR`, `BR2.FOR` | brick element, as in the ZACE tree (see note) |
| `SYSR.FOR`, `GFCOMPAT.FOR` | system-dependent routines, gfortran shim |

Note on the brick: NTYPE 3 is dispatched and works for the original analyses
(IACODE 0/1), but `BR1.FOR` only declares the separate-stiffness pointer (`/qpoint/`)
without passing it to its assembly routines as `TR0NEW`/`QD1NEW` do, so the Hermitian
driver would see no brick stiffness. Treat bricks as **unsupported for IACODE = 2**.

## Changes made in 2026

Two one-line edits, both marked with a `[dlearn-ppd 2026]` comment at the spot:
a trailing comma removed from FORMAT 1000 in `TR1NEW.FOR` (rejected by gfortran) and
`character*12` → `character*256` for the file names in `DL.FOR`. Plus `GFCOMPAT.FOR`,
encoding/line-ending conversion, and the Makefile. See
[`../../docs/porting-notes.md`](../../docs/porting-notes.md).
