# PPD — Pré-Processador DLEARN, Turbo Pascal 7 (2001)

The original pre-processor, exactly as submitted with the graduation thesis on
1 December 2001 (version 1.02), apart from conversion of the source text from code page
850 to UTF-8 for display on GitHub (`.gitattributes` converts it back to CP850 on checkout).

* `PPD.PAS` — the program (3 461 lines): main menu, `Cria` (create file) and the per-card
  procedures `Linha52`, `Linha72`, `Linha9`, `Linha101` (quad group), `Linha102` (truss
  group), `Linha10`; `Modifica` and `Confere` are stubs.
* `GERAL.PAS` — unit with the splash screen, help screen, message helpers and variable reset.
* `PPD-ZACE.PAS` — the "PPD – ZACE" variant shipped for the original DLEARN build. The
  only difference (`git diff --no-index PPD.PAS PPD-ZACE.PAS`, 13 hunks) is that menu option
  *(2) Algoritmo Hermitiano* is commented out and the control-card columns shift back by one
  field. `GERAL.PAS` is identical in both.

The program is a full-screen DOS dialogue (`Crt` unit, 80×25, box-drawing characters):
each screen asks the questions for one DLEARN card, shows the DLEARN variable name being
filled, validates ranges and interdependencies, lets the user confirm or re-enter, and
inserts the value at its column in an 80-character line buffer; the buffer is written at the
end. A session transcript is in chapter 4 of the thesis.

## Building

Turbo Pascal 7.0 (DOS): `tpc PPD.PAS` with `GERAL.PAS` in the same directory. The source
must be in **CP850** (`iconv -f UTF-8 -t CP850`) for the frame characters and accents to
render. Free Pascal (`fpc -Mtp PPD.PAS`) compiles it too in TP mode, but `Crt`'s text
colours and the `Graph` unit reference behave differently on modern terminals — expect a
working but less pretty dialogue. The compiled `PPD.EXE`, the `GERAL.TPU`/`GRAPH.TPU` units
and the `.pif` shortcut from the 2001 CD are not redistributed (`GRAPH.TPU` is Borland's).

## Known defects (found in 2026 by running its output against the Fortran)

1. **Hermitian order in the wrong column.** Written at columns 21–25 (after IWRITR), range
   2–8, following the thesis annex; DLEARN reads `IORDHERM` at columns 11–15 with range 1–4.
2. **Gravity card skipped when LFBODY = 0.** DLEARN always reads it (truss, quad and brick),
   so all later cards of the element group are shifted by one line.
3. **Terminator `*END`.** DLEARN recognises only lower-case `*end`.
4. Only `linha[1..70]` is written although the buffer holds 150 lines (`Cria`, label `Saida`);
   larger models are truncated silently.
5. `Modifica` (edit an existing file) and `Confere` (check a file) were planned (`modvar`,
   `confere` units) and never implemented.
6. Coordinates are written with `:3:3` formatting (three decimals), loads with the ad-hoc
   `Defzeros` width table; large or very small values can overflow their 10-column field.

All six are fixed in the Python version, which was written from the Fortran `READ`
statements rather than from the annex.
