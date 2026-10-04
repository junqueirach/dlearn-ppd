# Porting notes — building the 1997 and 2001 Fortran with gfortran (2026)

Goal: compile both DLEARN trees unchanged, or as close to unchanged as a modern compiler
allows, and prove it by running the shipped examples. Everything below is visible in the
sources (marked `[dlearn-ppd 2026]`) or in the Makefiles.

## Common to both trees

| Change | Why |
|---|---|
| Text re-encoded CP850 → UTF-8, CRLF → LF, trailing `^Z` (0x1A) removed | GitHub display; gfortran chokes on the DOS end-of-file byte in `DL.FOR` ("Non-numeric character in statement label") |
| `GFCOMPAT.FOR` added: `subroutine gettim(ihr,imin,isec,ihund)` via `date_and_time` | `TIMING` in `DL2*.FOR` calls the Microsoft PowerStation intrinsic `GETTIM` |
| Flags `-std=legacy -ffixed-form -fno-automatic -w` | Fortran 77 with extensions (`$` edit descriptor, `!` comments, Hollerith-style `20a4` titles); `-fno-automatic` keeps the SAVE semantics the code relies on |

`SYSR.FOR` already provided `CLOSE`, `SECNDS`, `SYSCPU` (stubbed) and `CHRINT/INTCHR`; nothing
needed there. CPU-time columns in the output therefore read 0.0, as they did in 1997.

## ZACE 1997 tree

* `EL1.FOR` and `EL2.FOR` both define `ELMLIB`, `DLEARN`, `HPLOT`, `SHIST`, `DHIST`;
  `EL2.FOR` is the brick-enabled version named in ZACE's readme, so `EL1.FOR` is kept
  in `src/` but excluded from the link.
* `LANSO.FOR` (Lanczos eigensolver) is not called anywhere and uses the VMS `RAN(i,j)`
  intrinsic; kept, excluded from the link.
* No source line changed.

## Hermitian 2001 tree

* `TR1NEW.FOR`, FORMAT 1000: a trailing comma before the closing parenthesis
  (accepted by PowerStation, rejected by gfortran) removed — one character.
* `DL.FOR`: `character*12 filein,fileout` → `character*256` so that the interactive file
  names may be paths longer than DOS 8.3 names. Behaviour otherwise identical: the
  program still prompts for the two names on standard input.
* `heitor2.for` (an earlier draft of `HEITOR.FOR`, duplicate subroutine names, not in the
  original `TTNOVO.FMK` project) is kept, excluded from the link.
* The Microsoft Developer Studio project files `TTNOVO.FMK` / `TTNOVO.WSP` are not kept;
  their object list (BR1 BR2 DL DL0 DL1NEW DL2NEW EL2NEW HEITOR QD1NEW QD2 QD3NEW SYSR
  TR0NEW TR1NEW) is exactly what the Makefile links.

## Verification

* ZACE: ten inputs (`TU1–6`, `TH1–2`, `WE1`, `TRELICA`) run to completion, no NaN; outputs in
  `examples/reference/`.
* Hermitian: `examples/trelica.dat` runs 100 steps with order 2; `(iordherm) = 2` echoed.
* `ppd/python/tests/test_run_dlearn.py` repeats both runs from the YAML model.

## Not done (ideas)

* Replace the fixed `common a(50000)` / `(100,100)` arrays by allocatable storage — would lift
  the 100-equation limit of the Hermitian build; a real change, out of scope for an archival rebuild.
* `-fdefault-real-8`: the code uses `implicit double precision` explicitly where it matters; left alone.
* Windows binaries: not shipped; `make` under MSYS2 or WSL works.
