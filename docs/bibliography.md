# Bibliography

## DLEARN and the finite element method

* Hughes, T.J.R. *The Finite Element Method: Linear Static and Dynamic Finite Element Analysis*.
  Prentice-Hall, Englewood Cliffs, 1987. Dover reprint 2000, ISBN 978-0-486-41181-1.
  — Chapter 11 is the DLEARN user manual and source listing.
* Hilber, H.M.; Hughes, T.J.R.; Taylor, R.L. "Improved numerical dissipation for time integration
  algorithms in structural dynamics." *Earthquake Engineering & Structural Dynamics* 5 (1977) 283–292.
  — the α-method used by DLEARN's dynamic driver.
* Hughes, T.J.R.; Liu, W.K. "Implicit-explicit finite elements in transient analysis."
  *J. Applied Mechanics* 45 (1978) 371–378. — the implicit–explicit partition (IMPEXP).
* Nour-Omid, B. *LANSO: Lanczos algorithm with selective orthogonalization*, 1986
  (shipped as `LANSO.FOR` in the ZACE distribution).
* Zienkiewicz, O.C. *The Finite Element Method*, 3rd ed., McGraw-Hill, 1977.

## Hermitian direct-integration algorithms (Laier / Bottura line)

* Laier, J.E. "Hermitian one-step numerical integration algorithm for structural dynamic
  equations." *Advances in Engineering Software* 31:3 (2000) 203–206. doi:10.1016/S0965-9978(99)00040-X
* Laier, J.E. "Asymptotic annihilation Hermitian algorithm for integration in time." (Indexed in Semantic Scholar; venue and year not verified.)
* Bottura, H.M. *Uma família de algoritmos hermitianos para a integração direta das equações de
  dinâmica das estruturas*. Tese (Doutorado), EESC, Universidade de São Paulo, São Carlos, 1997.
  Orientador: J.E. Laier.
* Bottura, H.M.; Laier, J.E. "Uma família de algoritmos de integração direta das equações da
  dinâmica das estruturas com aniquilamento assintótico." *XXVIII Jornadas Sul-Americanas de
  Engenharia Estrutural*, São Carlos, 1997.
* Bottura, H.M.; Laier, J.E. "Uma família de algoritmos hermitianos para a integração direta das
  equações de dinâmica das estruturas." *Cadernos de Engenharia de Estruturas* (EESC-USP) 14 (1999) 1–27.
* Bottura, H.M.; Rigitano, A.C. "Implementação de um novo algoritmo de integração em um sistema
  computacional de análise dinâmica de estruturas via MEF." *XXIX Jornadas Sudamericanas de
  Ingeniería Estructural*, Punta del Este, 2000. — **the DLEARN implementation in this repository.**
* Rigitano, A.C.; Bottura, H.M.; Laier, J.E. "Gerações de matrizes de rigidez e vetores de ações
  nodais equivalentes com o emprego da formulação hermitiana livre." *TEMA — Tendências em
  Matemática Aplicada e Computacional* 2 (2001) 193–201.
* Bottura, H.M.; Rigitano, A.C. "Inclusão do amortecimento na análise espectral de um algoritmo de
  integração para análise estrutural." *3º Congresso Temático de Dinâmica e Controle da SBMAC*, Ilha Solteira, 2004.
* Bottura, H.M.; Rigitano, A.C. "Os métodos hermitianos HdHr para a integração da equação do
  movimento considerando o amortecimento." *DINCON 2007*, São José do Rio Preto.
* Bottura, H.M.; Rigitano, A.C. "Sobre o uso da família de algoritmos HdHr na integração da equação
  do movimento com termos não-lineares." *DINCON 2008*, Presidente Prudente.
* Bottura, H.M.; Rigitano, A.C. "About the use of the HdHr algorithm group in integrating the
  movement equation with nonlinear terms." *Mathematical Problems in Engineering* 2009, art. 368309.
  doi:10.1155/2009/368309 (open access).
* Bottura, H.M.; Rigitano, A.C.; Gonçalves, J.C.R. "Aplicação dos algoritmos HdHr a um problema com
  amortecimento unidirecional." *DINCON'09*, Bauru, 2009.
* Gonçalves, J.C.R. *Um teste de desempenho dos algoritmos de integração HdHr na solução da equação
  do movimento com termos não-lineares visando à aplicação em análise dinâmica de estruturas.*
  TCC / Iniciação Científica, UNESP Bauru, 2012.
* Research projects (coordinator H.M. Bottura): *Integração direta das equações de dinâmica das
  estruturas mediante operadores hermitianos* (1994–97); *Utilização de uma nova família de
  algoritmos hermitianos para a análise dinâmica de estruturas com múltiplos graus de liberdade*
  (1997–2001); *Inclusão do amortecimento físico em uma família de algoritmos hermitianos para
  análise dinâmica de estruturas* (2002–04); *Aplicação de um algoritmo hermitiano a problemas de
  análise dinâmica não linear de estruturas* (2005–07); *Análise do desempenho da família de
  algoritmos HdHr … em presença de não-linearidades* (2008–10).

## The pre-processor

* Junqueira, L.E.L. *Geração de arquivos de dados para software de análise estrutural.*
  Trabalho de graduação, Engenharia Civil, Faculdade de Engenharia de Bauru, UNESP, 2001.
  Orientador: H.M. Bottura. (`docs/thesis/`.)
* Anschau, K.R. *Uma análise comparativa de algoritmos de integração para aplicação em dinâmica das
  estruturas.* Iniciação Científica, UNESP Bauru, 1997. — earlier student work on the same DLEARN.

## Cited in the 2001 thesis (structural background)

Argyris (1954); Turner, Clough, Martin & Topp (1956); Zienkiewicz (1967); Vlassov (1962);
Warburton (1976); Savassi (1996); Barbosa (1978); Prudente (1983); Mori (1983); Becker (1989);
Rios (1991); Balcazar (1991); Matias Jr. (1997); Rinald (1993) and Wood (1987) on Turbo Pascal;
Franchin (1997), lecture notes. Full references on pp. 24–25 of the thesis.
