# Example: six-node truss under a step load (thesis, chapter 4)

Plane truss 1600 × 600 (two bays), E = 2.1·10⁵, ρ = 7.3·10⁻⁶, A = 10, load of 1000
applied suddenly at node 3 in −y and held; first-mode period ≈ 0.23. 100 steps of
Δt = 0.023.

```
 1 ───── 2 ───── 3   ← load at 3
 │ \     │ \     │
 4 ───── 5 ───── 6
```
Nodes 1 and 4 fixed; z locked everywhere (3-D truss element used as a plane truss).

| File | |
|---|---|
| `trelica.yaml` | the model |
| `trelica-hermitian.dat` | `ppd build trelica.yaml` — Hermitian build, order 2 |
| `trelica-zace.dat` | same model, `analysis: dynamic`, `--layout zace` — original build, HHT α = −0.1 |
| `reference/*.out` | outputs of both builds (node 3, dof 2 history at the end) |

Peak downward displacement of node 3 in the first cycle: −13.40 (Hermitian, order 2)
vs −12.75 (HHT α = −0.1, β = 0.3025, γ = 0.6) — a 5 % difference that reflects the
numerical damping of the α-method at Δt/T ≈ 0.1, which is exactly the kind of comparison
the Hermitian family was built to make. (The thesis reports a peak of −45 for the same
truss because its run also applied a gravity field of −10 000 through LFBODY = 1.)
