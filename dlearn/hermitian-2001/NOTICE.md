# Notice — DLEARN with Hermitian algorithms (UNESP Bauru, 1997–2001)

This tree is DLEARN (© 1987 T.J.R. Hughes, see [`../LICENSE-DLEARN.txt`](../LICENSE-DLEARN.txt))
modified at the Faculdade de Engenharia de Bauru, UNESP, to add a family of
**Hermitian direct-integration algorithms** for the equation of motion.

| Part | Author | Year |
|---|---|---|
| `HEITOR.FOR` — assembly of global K and M (`km`), Hermitian system assembly for orders 1–4 (`montherm`), matrix inversion (`inverm`), solver (`solsispla`), result re-mapping (`realoca`) | Prof. Dr. Heitor Miranda Bottura | 1997–2001 |
| `heitor2.for` — earlier draft of the above (not linked) | H.M. Bottura | 1997–2001 |
| `DL1NEW.FOR` (`driver2`), `DL2NEW.FOR`, `EL2NEW.FOR` (IORDHERM input), `QD1NEW.FOR`, `QD3NEW.FOR`, `TR0NEW.FOR`, `TR1NEW.FOR` — DLEARN routines modified to separate K and M and call the Hermitian driver | H.M. Bottura, with A.C. Rigitano | 1997–2001 |
| `DL.FOR` — interactive file names (`czferro modif 11/06/99`) | N.C.P. Ferro | 1999 |
| `GFCOMPAT.FOR`, Makefile, run.sh, the two marked one-line edits in `TR1NEW.FOR` and `DL.FOR` | L.E.L. Junqueira | 2026 |

The research is described in:

* H.M. Bottura, *Uma família de algoritmos hermitianos para a integração direta das equações
  de dinâmica das estruturas*, PhD thesis, EESC-USP, São Carlos, 1997 (advisor J.E. Laier).
* H.M. Bottura, J.E. Laier, "Uma família de algoritmos hermitianos para a integração direta
  das equações de dinâmica das estruturas", *Cadernos de Engenharia de Estruturas* 14 (1999) 1–27.
* H.M. Bottura, A.C. Rigitano, "Implementação de um novo algoritmo de integração em um sistema
  computacional de análise dinâmica de estruturas via MEF", *XXIX Jornadas Sudamericanas de
  Ingeniería Estructural*, Punta del Este, 2000 — the implementation in this tree.
* H.M. Bottura, A.C. Rigitano, "About the use of the HdHr algorithm group in integrating the
  movement equation with nonlinear terms", *Mathematical Problems in Engineering* 2009, 368309
  (open access) — the later development of the same family.

**Terms.** Prof. Bottura (now retired) supervised the 2001 pre-processor project this
repository grew from and agreed to its public release; the Hermitian extensions are made
available for research use under the same terms as DLEARN itself — free distribution and
modification, not to be sold, ownership with the authors, no warranty. Please cite the
papers above when you use them.

**Limits of this build.** The Hermitian driver keeps dense global matrices in
`common /system/` (`riglob(100,100)`, `xmasglob(100,100)`, 200×200 work arrays), so it is
limited to **100 equations**. It reads `IORDHERM` (order 1–4) from columns 11–15 of the control
card and ignores α, β, γ of the time-sequence card (`driver2` sets its own). Element type 3
(brick) is not present in this tree.
