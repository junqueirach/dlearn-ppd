# Provenance and rights

What is in this repository, where each part came from, and under what terms it is here.
Researched and written in October 2026 while rebuilding the 2001 material; sources linked at
the end.

## 1. DLEARN (Hughes, 1986–1987)

* Written by **T.J.R. Hughes, R.M. Ferencz and A.M. Raefsky**, dated 15 May 1986 in the
  source header, and published as the companion program of Hughes' textbook
  *The Finite Element Method: Linear Static and Dynamic Finite Element Analysis*
  (Prentice-Hall, 1987; Dover reprint 2000, still in print). Chapter 11 of the book is the
  user manual; the source is listed in the book.
* Scope: linear static and transient analysis; implicit–explicit element partitions;
  Hilber-Hughes-Taylor α-method with predictor/multi-corrector iterations; Rayleigh damping;
  elements: 2/3-node truss (`TR*`), 4-node quadrilateral in plane stress, plane strain and
  axisymmetry with B-bar (`QD*`); nodal and element time histories with line-printer plots.
* **Terms**: the header of `DL.FOR` ("NOTICE TO USERS OF THIS PROGRAM PACKAGE") permits
  distribution provided the program is not sold for profit and no royalties or development
  charges are made for its use; ownership stays with the developers; no warranty;
  "Copyright: 1987 by T.J.R. Hughes, all rights reserved." Reproduced verbatim in
  [`../dlearn/LICENSE-DLEARN.txt`](../dlearn/LICENSE-DLEARN.txt). This is a free,
  non-commercial redistribution notice, not an OSI licence. The copies of DLEARN on GitHub
  that carry a GPL-3.0 file were not relicensed by the authors; this repository does not
  repeat that and keeps the original notice.

## 2. The ZACE 1997 distribution

* **ZACE Services Ltd**, Lausanne — Thomas Zimmermann's company (founded 1982, makers of
  ZSoil, with Hughes credited as a long-time collaborator) — distributed DLEARN on the
  Internet. The copy in `dlearn/zace-1997` is their update of **10 June 1997**, compiled with
  Microsoft Fortran PowerStation 4.0, which added the **8-node brick element**
  (`BR1.FOR`, `BR2.FOR`, `EL2.FOR`; marked `cZACE MODIF`) and shipped the Lanczos eigensolver
  `LANSO.FOR` (B. Nour-Omid, 1986). Its readme is in `dlearn/zace-1997/README-ZACE-1997.txt`.
* The same 1997 package is the ancestor of the DLEARN mirrors on GitHub
  (fit087/fem_hughes, 2010s, forked by xzhang66 and others) and of the copy listed among
  the open FEM codes of Tsinghua University's computational-dynamics laboratory; their
  `Readme.txt` carries the identical "Last program UPDATE : 10.06.97" line.
* How it reached Bauru: downloaded by Prof. Bottura's group in 1997–1999 for the research
  project below; the 2001 thesis CD contained it in the folder "Dlearn – ZACE".

## 3. The Hermitian build (UNESP Bauru, 1997–2001)

* **Prof. Dr. Heitor Miranda Bottura** (civil engineer, Bauru 1977; MSc 1991 and PhD 1997 at
  EESC-USP under **José Elias Laier**, the originator of Hermitian-finite-difference time
  integrators; professor at the Faculdade de Engenharia de Bauru, UNESP; retired) developed
  a family of Hermitian one-step direct-integration algorithms in his PhD
  (*Uma família de algoritmos hermitianos para a integração direta das equações de dinâmica
  das estruturas*, 1997) and implemented them inside DLEARN during the project
  *Utilização de uma nova família de algoritmos hermitianos para a análise dinâmica de
  estruturas com múltiplos graus de liberdade* (1997–2001, FAPESP record), reported in
  Bottura & Rigitano, Punta del Este 2000. The 1999 file-name change in `DL.FOR` is signed by
  **N.C.P. Ferro**; **A.C. Rigitano** co-authored the implementation papers.
* The line continued after 2001: physical damping (2002–04), the renamed **HdHr** group with
  Rigitano (DINCON 2007–2009; *Mathematical Problems in Engineering* 2009, open access) and
  a 2012 undergraduate performance study (J.C.R. Gonçalves).
* **Terms**: Prof. Bottura supervised the 2001 project and, consulted again in 2026, agreed
  to the public release of this material for research use under the same terms as DLEARN.
  The 2001 thesis itself states the intent ("software de código aberto, próprio para
  pesquisas"). See [`../dlearn/hermitian-2001/NOTICE.md`](../dlearn/hermitian-2001/NOTICE.md).

## 4. PPD (Junqueira, 2001)

* **Luiz Eduardo Lollato Junqueira**, graduation project in civil engineering, Faculdade de
  Engenharia de Bauru, UNESP, December 2001, supervisor H.M. Bottura:
  *Geração de arquivos de dados para software de análise estrutural*. The project is listed
  in Prof. Bottura's academic record. Deliverables on the thesis CD: `PPD.PAS`, `GERAL.PAS`,
  compiled `PPD.EXE` for each DLEARN build, Turbo Pascal 7.0, the thesis, the two DLEARN
  trees; a website (geocities.com/dlearnbr, long gone) distributed the same.
* Author's own work → **MIT License** in this repository (2001 code and 2026 rewrite alike).

## 5. What was done in 2026

* Sources converted from CP850/CRLF to UTF-8/LF; DOS end-of-file bytes removed; no
  computational line of DLEARN or of the Hermitian routines changed. The two one-line
  portability edits and the `GFCOMPAT.FOR` shim are listed in
  [`porting-notes.md`](porting-notes.md) and marked in the files.
* Both trees built with gfortran and verified against the shipped examples; the thesis truss
  example re-run on both.
* Input format re-derived from the Fortran (`dlearn-input-format.md`); discrepancies with
  the thesis annex and bugs in the 2001 PPD recorded.
* PPD rewritten in Python with tests; CI added.
* Not redistributed: `PPD.EXE`, `DLEARN.EXE`, `GERAL.TPU`, `GRAPH.TPU` (Borland), `.pif`,
  Microsoft project files (`TTNOVO.FMK/.WSP`), Turbo Pascal itself.

## Sources consulted (October 2026)

* `DL.FOR` header, both trees (authors, date, notice).
* ZACE readme (`README-ZACE-1997.txt`); ZSoil company history, zsoil.com/zsoil/history.
* GitHub mirrors: github.com/fit087/fem_hughes (and its `Readme.txt`), github.com/xzhang66/DLEARN;
  Tsinghua comdyn "open FEM" list, comdyn.hy.tsinghua.edu.cn.
* Dover catalogue entry for Hughes (2000), ISBN 978-0-486-41181-1.
* H.M. Bottura — FAPESP researcher record (bv.fapesp.br/en/pesquisador/91844) and
  Lattes-derived profile (escavador.com/sobre/1044498), listing the projects, papers and the
  2001 supervision.
* Bottura & Rigitano, *Math. Probl. Eng.* 2009, doi:10.1155/2009/368309 (Wiley / UNESP repository).
* J.E. Laier, "Hermitian one-step numerical integration algorithm for structural dynamic
  equations", *Advances in Engineering Software* 31 (2000) 203–206.
* The 2001 thesis (`thesis/`).
