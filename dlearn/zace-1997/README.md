# DLEARN — ZACE 1997 distribution

Hughes' DLEARN as updated on 10 June 1997 and distributed on the Internet by ZACE Services
Ltd (Lausanne): the original two-dimensional quadrilateral (`QD*.FOR`) and truss (`TR*.FOR`)
elements plus the **eight-node brick** added by ZACE (`BR1.FOR`, `BR2.FOR`, `EL2.FOR`).
Original readme: [`README-ZACE-1997.txt`](README-ZACE-1997.txt). Licence:
[`../LICENSE-DLEARN.txt`](../LICENSE-DLEARN.txt).

## Build

```sh
make            # -> ./dlearn   (gfortran, flags: -std=legacy -ffixed-form -fno-automatic)
make check      # runs the ten inputs in examples/ and reports ok/FAIL
```

Tested with gfortran 13 on Linux and in GitHub Actions. On Windows, install gfortran
through MSYS2 (`pacman -S mingw-w64-ucrt-x86_64-gcc-fortran make`) or use WSL.

## Run

The program reads `input.dat` and writes `output.dat` in the current directory
(the classic `RUN.BAT` does the copying; on Unix):

```sh
cp examples/TU1.DAT input.dat && ./dlearn && mv output.dat tu1.out
```

or let the pre-processor do it: `ppd run model.yaml --layout zace --dlearn ./dlearn`.

## Examples (`examples/`)

| File | Problem | Source |
|---|---|---|
| `TU1.DAT` | truss tower, static vertical and lateral loads | Hughes §11 |
| `TU2.DAT` | plane-strain cantilever, static, consistent nodal forces | Hughes |
| `TU3.DAT` | cantilever beam, dynamic | Hughes |
| `TU4.DAT` | implicit–explicit dynamic rod | Hughes |
| `TU5.DAT` | 4-node quad | Hughes |
| `TU6.DAT` | 4-node quad, rank check | Hughes |
| `TH1.DAT` | 8-node brick patch test | ZACE |
| `TH2.DAT` | brick cantilever beam | ZACE |
| `WE1.DAT` | brick element problem | ZACE |
| `TRELICA.DAT` | 6-node truss under step load (thesis example, HHT α = −0.1) | this repo |

`examples/reference/` holds the outputs produced by this build (timing lines vary).

## What differs from the 1997 files

Only what was needed to build with a current compiler; see
[`../../docs/porting-notes.md`](../../docs/porting-notes.md):

* sources converted from CP850/CRLF to UTF-8/LF and the DOS end-of-file byte removed;
* `GFCOMPAT.FOR` added — `GETTIM` (Microsoft Fortran PowerStation extension used by `TIMING`)
  on top of `DATE_AND_TIME`;
* `EL1.FOR` (element library without brick) and `LANSO.FOR` (unused Lanczos eigensolver that
  needs the VMS `RAN` intrinsic) are kept but not linked — see the Makefile.

No computational line was changed.

## Input format

[`../../docs/dlearn-input-format.md`](../../docs/dlearn-input-format.md). This build uses the
**`zace` control-card layout** (15 fields, no `IORDHERM`).
