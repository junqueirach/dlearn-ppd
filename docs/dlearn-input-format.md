# DLEARN input file format

Reference for the fixed-column input file read by DLEARN, as implemented in the
Fortran sources in this repository. It was derived directly from the `READ`/`FORMAT`
statements of the code (file and line references are to `dlearn/hermitian-2001/src`;
the ZACE 1997 sources are identical except where noted) and cross-checked against the
variable list in Annex 1 of the 2001 thesis (Portuguese). Where the thesis annex and
the Fortran disagree, **the Fortran wins** and the difference is flagged.

The authoritative description of the format and of every variable is Chapter 11 of
T.J.R. Hughes, *The Finite Element Method* (Prentice-Hall 1987 / Dover 2000).

## Conventions

* Every line ("card") is 80 columns. Columns are 1-based.
* `I5` = integer right-justified in a 5-column field; `F10.0` = real in a 10-column field
  (any form accepted by Fortran F editing: `600.`, `0.0230`, `7.3E-06`, `-1000`).
  A blank field reads as 0.
* `16I5` means up to 16 consecutive integer fields, columns 1–5, 6–10, …, 76–80.
* Lists terminated by "a blank line" are read until a line whose first field is 0.
* Free-format is **not** accepted; values must be in their columns.

## 0. Echo flag

| Cols | Var | Format | Meaning |
|---|---|---|---|
| 1–5 | IECHO | I5 | 0 = no echo of the input file in the output, 1 = echo |

(`DL1NEW.FOR` `echo`, format `16I5`.) After this line the rest of the file is read
by the main loop below; the loop repeats until a title card reading `*end` is found,
so **several problems can be stacked in one file**.

## 1. Title

| Cols | Var | Format |
|---|---|---|
| 1–80 | TITLE | 20A4 |

Lower-case `*end` in columns 1–4 terminates the run (`EL2NEW.FOR`, `data ciao/'*end'/`).
Upper-case `*END` is **not** recognised: the program then tries to read another problem and
stops with an end-of-file error after the results have already been written.

## 2. Execution control

Format `16I5` (`EL2NEW.FOR` line 164). **The two builds differ in this card.**

Hermitian 2001 build:

| Cols | Var | Meaning |
|---|---|---|
| 1–5 | IEXEC | 0 data check only, 1 execute |
| 6–10 | IACODE | 0 dynamic (Hilber-Hughes-Taylor α-method), 1 static, 2 **Hermitian algorithm** |
| 11–15 | IORDHERM | order of the Hermitian algorithm, **1–4** (used only when IACODE = 2) |
| 16–20 | IREADR | 1 = read initial conditions from restart file |
| 21–25 | IWRITR | 1 = write restart file at the end |
| 26–30 | IPRTIN | 0 = print nodal and element input data, 1 = do not |
| 31–35 | IRANK | rank check: 0 none, 1 print number of zero/negative pivots, 2 print all pivots |
| 36–40 | NUMSEQ | number of time sequences (static: 1) |
| 41–45 | NDOUT | number of nodal time histories |
| 46–50 | NSD | number of space dimensions (2 or 3) |
| 51–55 | NUMNP | number of nodal points |
| 56–60 | NDOF | degrees of freedom per node |
| 61–65 | NLVECT | number of load vectors |
| 66–70 | NLTFTN | number of load-time functions |
| 71–75 | NPTSLF | number of points defining each load-time function |
| 76–80 | NUMEG | number of element groups |

ZACE 1997 build (original Hughes layout): same, **without IORDHERM** — IREADR is in
columns 11–15 and every later field shifts one position left (NUMEG in 71–75).

> **Discrepancy with the 2001 thesis / legacy PPD.** The thesis annex places IHERM
> in columns 21–25 (after IWRITR) with range 2–8, and the Pascal PPD writes it there.
> The Fortran reads IORDHERM in columns 11–15, and `HEITOR.FOR` dispatches on
> `go to (1000,2000,3000,4000) iordherm`, i.e. orders 1 to 4 (0 falls through to order 1).
> A file produced by the legacy PPD for a Hermitian run is therefore mis-read
> (IWRITR gets the Hermitian order, IORDHERM gets 0). Use the layout above.

Limits of the Hermitian build: `common /system/` holds dense `riglob(100,100)` and
`xmasglob(100,100)` and work matrices `200×200`, so **NEQ ≤ 100** equations.

## 3. Time sequences — NUMSEQ lines (always read, also for static runs)

Format `6I5,4F10.0` (`DL2NEW.FOR` `tseq`, line 1331).

| Cols | Var | Meaning |
|---|---|---|
| 1–5 | N | sequence number |
| 6–10 | NSTEP(N) | number of time steps |
| 11–15 | NDPRT(N) | kinematic print increment (0 = never) |
| 16–20 | NSPRT(N) | stress/strain print increment |
| 21–25 | NHPLT(N) | time-history plot increment |
| 26–30 | NITER(N) | corrector iterations per step |
| 31–40 | ALPHA(N) | HHT α (−1/3 ≤ α ≤ 0; 0 = Newmark) |
| 41–50 | BETA(N) | Newmark β |
| 51–60 | GAMMA(N) | Newmark γ |
| 61–70 | DT(N) | time step |

For a static analysis use one sequence with NSTEP = 1 and α = 0, β = 1, γ = 0, DT = 1
(see `TU1.DAT`). In the Hermitian driver (`driver2`, `DL1NEW.FOR`) α, β, γ are ignored;
DT and NSTEP are used.

## 4. Nodal time histories — NDOUT lines

Format `3I5` (`EL2NEW.FOR` `dhist`).

| Cols | Var | Meaning |
|---|---|---|
| 1–5 | NODE | node number |
| 6–10 | IDOF | degree of freedom |
| 11–15 | IDVA | 1 displacement, 2 velocity, 3 acceleration |

## 5. Nodal coordinates — "GENFL" block, terminated by a blank line

Generic block used for coordinates, loads and initial conditions
(`DL1NEW.FOR` `genfl`, lines 1578–1594). Each entry:

**5.1** — format `2I5,6F10.0`

| Cols | Var | Meaning |
|---|---|---|
| 1–5 | N | node number (0 terminates the block) |
| 6–10 | NUMGP | 0 no generation; 2 linear, 3 quadratic, 4 bilinear, 8 bi-quadratic (NSD=2) / tri-linear (NSD=3), 20 tri-quadratic |
| 11–20, 21–30, … | X(1..NRA, N) | values (NRA = NSD for coordinates, NDOF for loads / initial conditions) |

**5.2** — only if NUMGP ≠ 0: NUMGP − 1 further lines, format `2I5,6F10.0`

| Cols | Var | Meaning |
|---|---|---|
| 1–5 | M | node number (used when MGEN = 1) |
| 6–10 | MGEN | 0 = values of generation point J are on this line; 1 = take the values of node M already defined |
| 11–… | TEMP(1..NRA, J) | values |

**5.3** — only if NUMGP ≠ 0: one line, format `16I5`

| Cols | Var |
|---|---|
| 1–5, 6–10 | NINC(1), INC(1) — extra nodes and node-number increment in direction 1 |
| 11–15, 16–20 | NINC(2), INC(2) |
| 21–25, 26–30 | NINC(3), INC(3) |

A **blank line** closes the coordinate block.

## 6. Boundary condition codes — terminated by a blank line

Format `16I5` (`DL2NEW.FOR` `bc`, line 29).

| Cols | Var | Meaning |
|---|---|---|
| 1–5 | N | first node (0 terminates) |
| 6–10 | NE | last node of the generated sequence (blank if NG = 0) |
| 11–15 | NG | node-number increment (0 = no generation) |
| 16–20, 21–25, … | ID(1..NDOF, N) | 0 active dof, 1 prescribed displacement, 2 prescribed velocity, 3 prescribed acceleration |

Unlisted nodes are free. A **blank line** closes the block.

## 7. Prescribed forces / kinematic boundary values — NLVECT GENFL blocks

Only if NLVECT > 0. One GENFL block (sections 5.1–5.3 with NRA = NDOF, values = F(1..NDOF,N))
per load vector, **each closed by a blank line**. Values on dofs with ID ≠ 0 are prescribed
displacements/velocities/accelerations; on free dofs they are forces.

## 8. Load-time functions — NLTFTN × NPTSLF lines

Only if NLTFTN > 0. Format `2F10.0` (`DL2NEW.FOR` `ltimef`, line 303): for each function,
NPTSLF lines of

| Cols | Var |
|---|---|
| 1–10 | time |
| 11–20 | load factor |

Piecewise-linear interpolation between points. No terminator line.

> The thesis annex gives these columns as 1–5 and 6–10; the Fortran reads `2F10.0`.
> Values written in columns 1–5 still read correctly (they fall inside the first F10
> field), but column 6–10 writes would not — the legacy PPD writes the second value at
> column 11, which is correct.

## 9. Initial conditions — 3 GENFL blocks (dynamic only)

Only if IACODE ≠ 1 **and** IREADR = 0: three GENFL blocks (NRA = NDOF) for initial
displacements, velocities and accelerations, **each closed by a blank line** — so a problem
with no initial conditions needs **three blank lines** here.

## 10. Element groups — NUMEG groups

Each group starts with a control card, format `16I5` (`DL1NEW.FOR` `elcard`, line 1258);
NPAR(1) = NTYPE selects the element: 1 quad, 2 truss, 3 brick (ZACE 1997 only).

### 10.1 Four-node quadrilateral (NTYPE = 1) — `QD1.FOR`

| Cols | Var | Meaning |
|---|---|---|
| 1–5 | NTYPE | 1 |
| 6–10 | NUMEL | number of elements |
| 11–15 | NUMAT | number of material sets |
| 16–20 | NSURF | number of surface-force cards |
| 21–25 | NSOUT | number of stress/strain time histories |
| 26–30 | IOPT | 0 plane stress, 1 plane strain, 2 axisymmetric (no torsion) |
| 31–35 | ISTPRT | 0 print stresses, 1 do not |
| 36–40 | LFSURF | load-time function for surface forces |
| 41–45 | LFBODY | load-time function for body forces |
| 46–50 | NICODE | 0 2×2 Gauss (required for static), 1 one-point |
| 51–55 | IBBAR | 0 standard B, 1 B-bar (mean dilatation) |
| 56–60 | IMASS | 0 consistent, 1 lumped, 2 no mass |
| 61–65 | IMPEXP | 0 implicit, 1 explicit |

Then, in this order:

1. **Materials** — NUMAT lines, format `I5,5X,7F10.0` (`DL2NEW.FOR` `prop2d`, line 825):
   M (1–5), E (11–20), POIS (21–30), RHO (31–40), RDAMPM (41–50), RDAMPK (51–60), TH (61–70; 0 → 1).
2. **Gravity vector** — one line, format `8F10.0`: GRAV(1) (1–10), GRAV(2) (11–20).
   **Always read**, even when LFBODY = 0.
3. **Elements** — GENEL block, terminated by a blank line (`DL1NEW.FOR` `genel`, line 1445):
   * `16I5`: N (1–5), M material (6–10), IEN(1..4,N) (11–30), NG (31–35)
   * if NG ≠ 0, one line `16I5`: NEL(1), INCEL(1), INC(1), NEL(2), INCEL(2), INC(2), NEL(3), INCEL(3), INC(3)
     (extra elements, element-number increment, node-number increment per direction)
   * blank line closes the block
4. **Surface forces** — NSURF lines, format `2I5,4F10.0` (`QD3.FOR` `qdcrsf`):
   IELNO (1–5), ISIDE 1–4 (6–10), PRESS(1) (11–20), PRESS(2) (21–30), SHEAR(1) (31–40), SHEAR(2) (41–50).
5. **Stress/strain histories** — NSOUT lines, format `3I5` (`EL2NEW.FOR` `shist`):
   element, integration point (1–4, or 1 if NICODE = 1), component 1–16
   (1 s11, 2 s22, 3 s12, 4 s33, 5 ps1, 6 ps2, 7 tau, 8 sang, 9 e11, 10 e22, 11 g12, 12 e33, 13 pe1, 14 pe2, 15 gam, 16 eang).

### 10.2 Two/three-node truss (NTYPE = 2) — `TR0.FOR`

| Cols | Var | Meaning |
|---|---|---|
| 1–5 | NTYPE | 2 |
| 6–10 | NUMEL | number of elements |
| 11–15 | NUMAT | number of material sets |
| 16–20 | NEN | nodes per element, 2 or 3 |
| 21–25 | NSOUT | number of stress/strain time histories |
| 26–30 | ISTPRT | 0 print stresses, 1 do not |
| 31–35 | LFBODY | load-time function for body forces |
| 36–40 | NINT | Gauss points, 1–3 |
| 41–45 | IMASS | 0 consistent, 1 lumped, 2 none |
| 46–50 | IMPEXP | 0 implicit, 1 explicit |

Then:

1. **Materials** — NUMAT lines, `I5,5X,7F10.0` (`TR1.FOR` `truspr`):
   M (1–5), E (11–20), RHO (21–30), RDAMPM (31–40), RDAMPK (41–50), AREA (51–60).
2. **Gravity vector** — one line, `8F10.0`: GRAV(1), GRAV(2), GRAV(3) (1–30). **Always read.**
3. **Elements** — GENEL block as in 10.1 with NEN node columns:
   N (1–5), M (6–10), IEN(1..NEN) (11–20 or 11–25), NG (next field); optional generation line; blank line.
4. **Stress/strain histories** — NSOUT lines, `3I5`: element, integration point, component
   (1 axial stress, 2 axial force, 3 axial strain).

### 10.3 Eight-node brick (NTYPE = 3) — `BR1.FOR`, ZACE 1997 build only

Control card as 10.1 (same NPAR positions; IOPT unused). Then materials
`I5,5X,7F10.0`: M, E, POIS, RHO, RDAMPM, RDAMPK; gravity `8F10.0` (three components);
GENEL block with 8 node columns (11–50) and NG in 51–55; surface forces `2I5,4F10.0`:
IELNO, ISIDE (1–6), PRESS(1..4); histories `3I5` with components 1–24
(1–3 s11 s22 s33, 4–6 s12 s23 s31, 7–9 principal stresses, 13–15 e11 e22 e33, 16–18 g12 g23 g31, 19–21 principal strains).

## 11. Terminator

A title card containing `*end` (lower case, columns 1–4) ends the run.

## Worked example

`examples/trelica/trelica-hermitian.dat` is the six-node, eight-bar truss of Chapter 4 of
the thesis, written for the Hermitian build (order 2); `trelica-zace.dat` is the same model
for the original build (HHT α = −0.1). Both are produced by the Python PPD from
`trelica.yaml`, and both run under `make check`.

## Known errors in the 2001 thesis annex / legacy PPD

Found while building this repository by running the files against the Fortran:

1. IHERM column (21–25 vs actual 11–15) and range (2–8 vs actual 1–4) — see section 2.
2. The gravity-vector card is always read; the legacy PPD omits it when LFBODY = 0, which
   shifts every following card of that group.
3. The terminator must be lower-case `*end`; the legacy PPD writes `*END`.
4. Load-time function columns (annex: 1–5 / 6–10; actual: F10 fields at 1–10 / 11–20).
5. The legacy PPD writes only the first 70 lines of its buffer, so a model needing more
   than 70 cards is silently truncated.
