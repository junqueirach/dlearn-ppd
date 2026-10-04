"""Model -> DLEARN input cards."""

from __future__ import annotations

from typing import List

from .cards import ints, reals, fmt_int, fmt_real, blank
from .model import (
    Model, GenEntry, ElementEntry, TrussGroup, QuadGroup, BrickGroup,
    LAYOUTS, group_numel,
)

TERMINATOR = "*end"


def control_card(m: Model, layout: str) -> str:
    c = m.control
    tail = (c.ireadr, c.iwritr, c.iprtin, c.irank, m.numseq, m.ndout, m.nsd,
            m.node_count(), m.ndof, m.nlvect, m.nltftn, m.nptslf, m.numeg)
    if layout == "hermitian":
        return ints(c.iexec, c.iacode, c.iordherm, *tail)
    return ints(c.iexec, c.iacode, *tail)


def genfl_lines(block: List[GenEntry]) -> List[str]:
    """GENFL block (coordinates / loads / initial conditions) incl. blank terminator."""
    out: List[str] = []
    for e in block:
        out.append(ints(e.node, e.numgp) + reals(*e.values))
        if e.numgp:
            for p in e.points:
                if p.mgen:
                    out.append(ints(p.m, 1))
                else:
                    out.append(ints(0, 0) + reals(*p.values))
            flat = [v for pair in e.ninc for v in pair]
            out.append(ints(*flat))
    out.append(blank())
    return out


def genel_lines(block: List[ElementEntry], nen: int) -> List[str]:
    out: List[str] = []
    for e in block:
        nodes = list(e.nodes) + [0] * (nen - len(e.nodes))
        out.append(ints(e.n, e.mat, *nodes[:nen], 1 if e.generate else 0))
        if e.generate:
            flat = [v for tri in e.generate for v in tri]
            out.append(ints(*flat))
    out.append(blank())
    return out


def truss_lines(g: TrussGroup) -> List[str]:
    out = [ints(2, group_numel(g), len(g.materials), g.nen, len(g.histories),
                g.istprt, g.lfbody, g.nint, g.imass, g.impexp)]
    for mt in g.materials:
        out.append(fmt_int(mt.id) + " " * 5 + reals(mt.e, mt.rho, mt.rdampm, mt.rdampk, mt.area))
    out.append(reals(*(list(g.gravity) + [0.0] * (3 - len(g.gravity)))[:3]))
    out += genel_lines(g.elements, g.nen)
    for h in g.histories:
        out.append(ints(h.element, h.intpt, h.component))
    return out


def quad_lines(g: QuadGroup) -> List[str]:
    out = [ints(1, group_numel(g), len(g.materials), len(g.surfaces), len(g.histories),
                g.iopt, g.istprt, g.lfsurf, g.lfbody, g.nicode, g.ibbar, g.imass, g.impexp)]
    for mt in g.materials:
        out.append(fmt_int(mt.id) + " " * 5 + reals(mt.e, mt.pois, mt.rho, mt.rdampm, mt.rdampk, mt.th))
    out.append(reals(*(list(g.gravity) + [0.0, 0.0])[:2]))
    out += genel_lines(g.elements, 4)
    for s in g.surfaces:
        out.append(ints(s.element, s.side) + reals(*(list(s.values) + [0.0] * 4)[:4]))
    for h in g.histories:
        out.append(ints(h.element, h.intpt, h.component))
    return out


def brick_lines(g: BrickGroup) -> List[str]:
    out = [ints(3, group_numel(g), len(g.materials), len(g.surfaces), len(g.histories),
                g.iopt, g.istprt, g.lfsurf, g.lfbody, g.nicode, g.ibbar, g.imass, g.impexp)]
    for mt in g.materials:
        out.append(fmt_int(mt.id) + " " * 5 + reals(mt.e, mt.pois, mt.rho, mt.rdampm, mt.rdampk))
    out.append(reals(*(list(g.gravity) + [0.0] * 3)[:3]))
    out += genel_lines(g.elements, 8)
    for s in g.surfaces:
        out.append(ints(s.element, s.side) + reals(*(list(s.values) + [0.0] * 4)[:4]))
    for h in g.histories:
        out.append(ints(h.element, h.intpt, h.component))
    return out


def to_lines(m: Model, layout: str = "hermitian", terminator: bool = True) -> List[str]:
    """Return the input file as a list of lines (no line terminators)."""
    if layout not in LAYOUTS:
        raise ValueError(f"layout must be one of {LAYOUTS}")
    L: List[str] = []
    L.append(ints(1 if m.echo else 0))
    L.append(m.title[:80])
    L.append(control_card(m, layout))
    for i, s in enumerate(m.time_sequences, 1):
        L.append(ints(i, s.nstep, s.ndprt, s.nsprt, s.nhplt, s.niter)
                 + reals(s.alpha, s.beta, s.gamma, s.dt))
    for h in m.nodal_histories:
        L.append(ints(h.node, h.dof, h.kind))
    L += genfl_lines(m.coordinates)
    for b in m.boundary_conditions:
        codes = list(b.codes) + [0] * (m.ndof - len(b.codes))
        L.append(ints(b.node, b.last if b.inc else 0, b.inc, *codes[:m.ndof]))
    L.append(blank())
    for block in m.loads:
        L += genfl_lines(block)
    nptslf = m.nptslf
    for f in m.time_functions:
        pts = list(f) + [f[-1]] * (nptslf - len(f)) if f else [(0.0, 0.0)] * nptslf
        for t, v in pts[:nptslf]:
            L.append(reals(t, v))
    if m.control.dynamic and m.control.ireadr == 0:
        L += genfl_lines(m.initial_displacements)
        L += genfl_lines(m.initial_velocities)
        L += genfl_lines(m.initial_accelerations)
    for g in m.element_groups:
        if isinstance(g, TrussGroup):
            L += truss_lines(g)
        elif isinstance(g, QuadGroup):
            L += quad_lines(g)
        elif isinstance(g, BrickGroup):
            L += brick_lines(g)
        else:
            raise TypeError(f"unknown element group {type(g).__name__}")
    if terminator:
        L.append(TERMINATOR)
    for ln in L:
        if len(ln) > 80:
            raise ValueError(f"card longer than 80 columns: {ln!r}")
    return L


def write_dat(m: Model, path, layout: str = "hermitian", newline: str = "\n") -> None:
    lines = to_lines(m, layout)
    with open(path, "w", encoding="ascii", newline="") as fh:
        fh.write(newline.join(lines) + newline)
