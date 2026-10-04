"""DLEARN input cards -> Model.

Reads a file exactly the way the Fortran does (fixed columns, blank-line
terminated blocks), so an existing .DAT can be loaded, edited in Python or
YAML, and written back.
"""

from __future__ import annotations

from typing import Iterator, List, Optional, Tuple

from .cards import parse_ints, parse_reals
from .model import (
    Model, Control, TimeSequence, NodalHistory, GenEntry, GenPoint,
    BoundaryCondition, TrussMaterial, QuadMaterial, BrickMaterial,
    ElementEntry, SurfaceLoad, StressHistory, TrussGroup, QuadGroup, BrickGroup,
)


class DatError(ValueError):
    pass


class _Cards:
    def __init__(self, lines: List[str]):
        self.lines = [ln.rstrip("\r\n") for ln in lines]
        self.pos = 0

    def next(self) -> str:
        if self.pos >= len(self.lines):
            raise DatError(f"unexpected end of file after line {self.pos}")
        ln = self.lines[self.pos]
        self.pos += 1
        return ln

    def peek(self) -> Optional[str]:
        return self.lines[self.pos] if self.pos < len(self.lines) else None


def detect_layout(control_line: str) -> str:
    """'hermitian' if the 16th I5 field (NUMEG, cols 76-80) is non-zero, else 'zace'."""
    f = parse_ints(control_line, 16)
    return "hermitian" if f[15] != 0 else "zace"


def read_genfl(c: _Cards, nra: int) -> List[GenEntry]:
    block: List[GenEntry] = []
    while True:
        ln = c.next()
        n, numgp = parse_ints(ln, 2)
        if n == 0:
            return block
        e = GenEntry(node=n, numgp=numgp, values=parse_reals(ln, nra, 11))
        if numgp:
            for _ in range(numgp - 1):
                pl = c.next()
                m, mgen = parse_ints(pl, 2)
                # DLEARN ignores M unless MGEN = 1 and ignores the values when MGEN = 1
                if mgen:
                    e.points.append(GenPoint(m=m, mgen=1))
                else:
                    e.points.append(GenPoint(values=parse_reals(pl, nra, 11)))
            inc = parse_ints(c.next(), 6)
            pairs = [(inc[0], inc[1]), (inc[2], inc[3]), (inc[4], inc[5])]
            while len(pairs) > 1 and pairs[-1] == (0, 0):
                pairs.pop()
            e.ninc = pairs
        block.append(e)


def read_genel(c: _Cards, nen: int) -> List[ElementEntry]:
    block: List[ElementEntry] = []
    while True:
        ln = c.next()
        f = parse_ints(ln, 2 + nen + 1)
        if f[0] == 0:
            return block
        e = ElementEntry(n=f[0], mat=f[1], nodes=f[2:2 + nen])
        if f[2 + nen]:
            g = parse_ints(c.next(), 9)
            tri = [(g[0], g[1], g[2]), (g[3], g[4], g[5]), (g[6], g[7], g[8])]
            while len(tri) > 1 and tri[-1] == (0, 0, 0):
                tri.pop()
            e.generate = tri
        block.append(e)


def read_truss(c: _Cards, npar: List[int]) -> TrussGroup:
    (_, numel, numat, nen, nsout, istprt, lfbody, nint, imass, impexp) = npar[:10]
    g = TrussGroup(nen=nen, istprt=istprt, lfbody=lfbody, nint=nint, imass=imass,
                   impexp=impexp, numel=numel)
    for _ in range(numat):
        ln = c.next()
        (mid,) = parse_ints(ln, 1)
        e, rho, rdampm, rdampk, area = parse_reals(ln, 5, 11)
        g.materials.append(TrussMaterial(mid, e, rho, rdampm, rdampk, area))
    g.gravity = parse_reals(c.next(), 3, 1)
    g.elements = read_genel(c, nen)
    for _ in range(nsout):
        g.histories.append(StressHistory(*parse_ints(c.next(), 3)))
    return g


def read_quad(c: _Cards, npar: List[int]) -> QuadGroup:
    (_, numel, numat, nsurf, nsout, iopt, istprt, lfsurf, lfbody, nicode, ibbar, imass, impexp) = npar[:13]
    g = QuadGroup(iopt=iopt, istprt=istprt, lfsurf=lfsurf, lfbody=lfbody, nicode=nicode,
                  ibbar=ibbar, imass=imass, impexp=impexp, numel=numel)
    for _ in range(numat):
        ln = c.next()
        (mid,) = parse_ints(ln, 1)
        e, pois, rho, rdampm, rdampk, th = parse_reals(ln, 6, 11)
        g.materials.append(QuadMaterial(mid, e, pois, rho, rdampm, rdampk, th))
    g.gravity = parse_reals(c.next(), 2, 1)
    g.elements = read_genel(c, 4)
    for _ in range(nsurf):
        ln = c.next()
        el, side = parse_ints(ln, 2)
        g.surfaces.append(SurfaceLoad(el, side, parse_reals(ln, 4, 11)))
    for _ in range(nsout):
        g.histories.append(StressHistory(*parse_ints(c.next(), 3)))
    return g


def read_brick(c: _Cards, npar: List[int]) -> BrickGroup:
    (_, numel, numat, nsurf, nsout, iopt, istprt, lfsurf, lfbody, nicode, ibbar, imass, impexp) = npar[:13]
    g = BrickGroup(iopt=iopt, istprt=istprt, lfsurf=lfsurf, lfbody=lfbody, nicode=nicode,
                   ibbar=ibbar, imass=imass, impexp=impexp, numel=numel)
    for _ in range(numat):
        ln = c.next()
        (mid,) = parse_ints(ln, 1)
        e, pois, rho, rdampm, rdampk = parse_reals(ln, 5, 11)
        g.materials.append(BrickMaterial(mid, e, pois, rho, rdampm, rdampk))
    g.gravity = parse_reals(c.next(), 3, 1)
    g.elements = read_genel(c, 8)
    for _ in range(nsurf):
        ln = c.next()
        el, side = parse_ints(ln, 2)
        g.surfaces.append(SurfaceLoad(el, side, parse_reals(ln, 4, 11)))
    for _ in range(nsout):
        g.histories.append(StressHistory(*parse_ints(c.next(), 3)))
    return g


def from_lines(lines: List[str], layout: Optional[str] = None) -> Tuple[Model, str]:
    """Parse one problem.  Returns (model, layout_used)."""
    c = _Cards(lines)
    m = Model()
    (iecho,) = parse_ints(c.next(), 1)
    m.echo = bool(iecho)
    m.title = c.next()[:80].rstrip()
    if m.title[:4].lower() == "*end":
        raise DatError("file contains no problem (title card is *end)")
    ctl = c.next()
    if layout is None:
        layout = detect_layout(ctl)
    f = parse_ints(ctl, 16)
    if layout == "hermitian":
        (iexec, iacode, iordherm, ireadr, iwritr, iprtin, irank, numseq, ndout,
         nsd, numnp, ndof, nlvect, nltftn, nptslf, numeg) = f
    else:
        (iexec, iacode, ireadr, iwritr, iprtin, irank, numseq, ndout,
         nsd, numnp, ndof, nlvect, nltftn, nptslf, numeg) = f[:15]
        iordherm = 0
    m.control = Control(iexec, iacode, iordherm, ireadr, iwritr, iprtin, irank)
    m.nsd, m.ndof, m.numnp = nsd, ndof, numnp
    m.time_sequences = []
    for _ in range(numseq):
        ln = c.next()
        _, nstep, ndprt, nsprt, nhplt, niter = parse_ints(ln, 6)
        alpha, beta, gamma, dt = parse_reals(ln, 4, 31)
        m.time_sequences.append(TimeSequence(nstep, ndprt, nsprt, nhplt, niter, alpha, beta, gamma, dt))
    for _ in range(ndout):
        m.nodal_histories.append(NodalHistory(*parse_ints(c.next(), 3)))
    m.coordinates = read_genfl(c, nsd)
    while True:
        ln = c.next()
        f = parse_ints(ln, 3 + ndof)
        if f[0] == 0:
            break
        m.boundary_conditions.append(BoundaryCondition(node=f[0], codes=f[3:3 + ndof], last=f[1], inc=f[2]))
    for _ in range(nlvect):
        m.loads.append(read_genfl(c, ndof))
    for _ in range(nltftn):
        fn = []
        for _ in range(nptslf):
            t, v = parse_reals(c.next(), 2, 1)
            fn.append((t, v))
        m.time_functions.append(fn)
    if m.control.dynamic and ireadr == 0:
        m.initial_displacements = read_genfl(c, ndof)
        m.initial_velocities = read_genfl(c, ndof)
        m.initial_accelerations = read_genfl(c, ndof)
    for _ in range(numeg):
        npar = parse_ints(c.next(), 16)
        if npar[0] == 2:
            m.element_groups.append(read_truss(c, npar))
        elif npar[0] == 1:
            m.element_groups.append(read_quad(c, npar))
        elif npar[0] == 3:
            m.element_groups.append(read_brick(c, npar))
        else:
            raise DatError(f"unknown element type NTYPE={npar[0]} at line {c.pos}")
    return m, layout


def read_dat(path, layout: Optional[str] = None) -> Model:
    with open(path, "r", encoding="latin-1") as fh:
        lines = fh.readlines()
    m, _ = from_lines(lines, layout)
    return m


def read_dat_with_layout(path, layout: Optional[str] = None) -> Tuple[Model, str]:
    with open(path, "r", encoding="latin-1") as fh:
        return from_lines(fh.readlines(), layout)
