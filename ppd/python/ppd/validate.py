"""Consistency checks on a Model before it is written.

This is the "Conferir arquivo" (check file) function of the 2001 program,
which was planned but never implemented.  Every range check of the Pascal
wizard is here, plus cross-references the wizard could not make.
"""

from __future__ import annotations

from dataclasses import dataclass
from typing import List

from .model import (
    Model, TrussGroup, QuadGroup, BrickGroup, generated_nodes, generated_elements,
    group_numel,
)

HERMITIAN_MAX_NEQ = 100  # common /system/ riglob(100,100) in HEITOR.FOR


@dataclass
class Problem:
    level: str   # "error" | "warning"
    where: str
    message: str

    def __str__(self) -> str:
        return f"{self.level.upper():7s} {self.where}: {self.message}"


def validate(m: Model, layout: str = "hermitian") -> List[Problem]:
    P: List[Problem] = []
    err = lambda w, msg: P.append(Problem("error", w, msg))      # noqa: E731
    warn = lambda w, msg: P.append(Problem("warning", w, msg))   # noqa: E731
    c = m.control

    # -- control card ------------------------------------------------------
    if len(m.title) > 80:
        err("title", "longer than 80 characters (will be truncated)")
    if c.iexec not in (0, 1):
        err("control.iexec", "must be 0 or 1")
    if c.iacode not in (0, 1, 2):
        err("control.iacode", "must be 0 (dynamic), 1 (static) or 2 (Hermitian)")
    if c.iacode == 2:
        if layout != "hermitian":
            err("control.iacode", "Hermitian analysis needs layout='hermitian' (the ZACE build has no IORDHERM field)")
        if not 1 <= c.iordherm <= 4:
            err("control.iordherm", "Hermitian order must be 1-4 (HEITOR.FOR dispatches on 1..4)")
    elif c.iordherm:
        warn("control.iordherm", "ignored unless iacode = 2")
    for name, val, rng in (("ireadr", c.ireadr, (0, 1)), ("iwritr", c.iwritr, (0, 1)),
                           ("iprtin", c.iprtin, (0, 1)), ("irank", c.irank, (0, 1, 2))):
        if val not in rng:
            err(f"control.{name}", f"must be one of {rng}")
    if m.nsd not in (2, 3):
        err("nsd", "must be 2 or 3")
    if not 1 <= m.ndof <= 6:
        err("ndof", "must be between 1 and 6")
    numnp = m.node_count()
    if numnp <= 0:
        err("numnp", "no nodes")
    if m.numeg <= 0:
        err("element_groups", "at least one element group is required")

    # -- time sequences ----------------------------------------------------
    if m.numseq == 0:
        err("time_sequences", "at least one time sequence is required (static: nstep=1)")
    for i, s in enumerate(m.time_sequences, 1):
        w = f"time_sequences[{i}]"
        if s.nstep < 1:
            err(w, "nstep must be >= 1")
        if s.niter < 1:
            err(w, "niter must be >= 1")
        if min(s.ndprt, s.nsprt, s.nhplt) < 0:
            err(w, "print increments must be >= 0")
        if c.iacode == 0:
            if not -1 / 3 - 1e-9 <= s.alpha <= 0:
                warn(w, "HHT alpha outside [-1/3, 0]")
            if s.dt <= 0:
                warn(w, "dt = 0 in a dynamic sequence (legal for an initialisation step, see TU4.DAT)")
            if s.beta < 0 or s.gamma < 0:
                err(w, "beta and gamma must be >= 0")
        if c.iacode == 1 and (s.nstep != 1):
            warn(w, "static analysis normally uses nstep = 1")

    # -- nodes -------------------------------------------------------------
    nodes = generated_nodes(m.coordinates)
    dup = sorted({n for n in nodes if nodes.count(n) > 1})
    if dup:
        warn("coordinates", f"nodes defined more than once: {dup[:10]}")
    missing = sorted(set(range(1, numnp + 1)) - set(nodes))
    if missing:
        warn("coordinates", f"nodes without coordinates (DLEARN leaves them at 0): {missing[:10]}")
    for e in m.coordinates:
        w = f"coordinates[node {e.node}]"
        if not 1 <= e.node <= numnp:
            err(w, f"node number outside 1..{numnp}")
        if len(e.values) != m.nsd:
            err(w, f"expected {m.nsd} coordinates, got {len(e.values)}")
        _check_gen(e, w, err)

    # -- nodal histories ---------------------------------------------------
    for i, h in enumerate(m.nodal_histories, 1):
        w = f"nodal_histories[{i}]"
        if not 1 <= h.node <= numnp:
            err(w, f"node {h.node} outside 1..{numnp}")
        if not 1 <= h.dof <= m.ndof:
            err(w, f"dof {h.dof} outside 1..{m.ndof}")
        if h.kind not in (1, 2, 3):
            err(w, "kind must be 1 (disp), 2 (vel) or 3 (acc)")
    if m.ndout and c.iacode == 1:
        warn("nodal_histories", "ignored in a static analysis")

    # -- boundary conditions -----------------------------------------------
    for i, b in enumerate(m.boundary_conditions, 1):
        w = f"boundary_conditions[{i}]"
        if not 1 <= b.node <= numnp:
            err(w, f"node {b.node} outside 1..{numnp}")
        if b.inc and not b.node <= b.last <= numnp:
            err(w, f"last node {b.last} must be in {b.node}..{numnp}")
        if len(b.codes) != m.ndof:
            err(w, f"expected {m.ndof} codes, got {len(b.codes)}")
        if any(code not in (0, 1, 2, 3) for code in b.codes):
            err(w, "codes must be 0, 1, 2 or 3")

    # -- loads / time functions --------------------------------------------
    for j, block in enumerate(m.loads, 1):
        for e in block:
            w = f"loads[{j}][node {e.node}]"
            if not 1 <= e.node <= numnp:
                err(w, f"node outside 1..{numnp}")
            if len(e.values) != m.ndof:
                err(w, f"expected {m.ndof} values, got {len(e.values)}")
            _check_gen(e, w, err)
    nptslf = m.nptslf
    for j, f in enumerate(m.time_functions, 1):
        w = f"time_functions[{j}]"
        if len(f) != nptslf:
            err(w, f"all functions must have the same number of points ({nptslf})")
        times = [t for t, _ in f]
        if times != sorted(times):
            err(w, "times must be increasing")
    if m.nlvect and not m.nltftn:
        warn("time_functions", "loads are defined but no load-time function")
    if c.iacode == 1 and m.nltftn and nptslf != 1:
        warn("time_functions", "static analysis: one point (t=1, value=1) is the usual choice")

    # -- initial conditions ------------------------------------------------
    for name, block in (("initial_displacements", m.initial_displacements),
                        ("initial_velocities", m.initial_velocities),
                        ("initial_accelerations", m.initial_accelerations)):
        if block and c.iacode == 1:
            warn(name, "ignored in a static analysis")
        for e in block:
            w = f"{name}[node {e.node}]"
            if not 1 <= e.node <= numnp:
                err(w, f"node outside 1..{numnp}")
            if len(e.values) != m.ndof:
                err(w, f"expected {m.ndof} values, got {len(e.values)}")

    # -- element groups ----------------------------------------------------
    for k, g in enumerate(m.element_groups, 1):
        w = f"element_groups[{k}]"
        numel = group_numel(g)
        elems = generated_elements(g.elements)
        if g.numel is not None and max(elems, default=0) > g.numel:
            err(w, f"element numbers go up to {max(elems)} but numel = {g.numel}")
        if sorted(set(elems)) != list(range(1, numel + 1)):
            warn(w, f"elements are not numbered 1..{numel} without gaps")
        if not g.materials:
            err(w, "no material set")
        mids = [mt.id for mt in g.materials]
        if mids != list(range(1, len(mids) + 1)):
            err(w, "material sets must be numbered 1..NUMAT in order")
        for mt in g.materials:
            if mt.e <= 0:
                err(f"{w}.materials[{mt.id}]", "E must be > 0")
            if hasattr(mt, "pois") and not 0 <= mt.pois < 0.5:
                err(f"{w}.materials[{mt.id}]", "Poisson ratio must be in [0, 0.5) (0.5 divides by zero)")
            if c.iacode != 1 and mt.rho <= 0 and g.imass != 2:
                warn(f"{w}.materials[{mt.id}]", "zero density in a dynamic analysis")
        if g.lfbody > m.nltftn:
            err(w, f"lfbody = {g.lfbody} but only {m.nltftn} load-time functions")
        if isinstance(g, (QuadGroup, BrickGroup)) and g.lfsurf > m.nltftn:
            err(w, f"lfsurf = {g.lfsurf} but only {m.nltftn} load-time functions")
        if g.imass not in (0, 1, 2) or g.impexp not in (0, 1) or g.istprt not in (0, 1):
            err(w, "imass must be 0/1/2, impexp 0/1, istprt 0/1")
        if isinstance(g, TrussGroup):
            if g.nen not in (2, 3):
                err(w, "truss nen must be 2 or 3")
            if g.nint not in (1, 2, 3):
                err(w, "truss nint must be 1, 2 or 3")
            if m.nsd != 3:
                warn(w, "truss element expects nsd = 3 (3-D coordinates)")
            nen = g.nen
        else:
            if isinstance(g, BrickGroup) and layout == "hermitian":
                err(w, "brick element (NTYPE 3) exists only in the ZACE 1997 build")
            if g.nicode not in (0, 1) or g.ibbar not in (0, 1):
                err(w, "nicode and ibbar must be 0 or 1")
            if c.iacode == 1 and g.nicode == 1:
                warn(w, "one-point quadrature (nicode=1) is rank-deficient for a static analysis")
            if isinstance(g, QuadGroup) and g.iopt not in (0, 1, 2):
                err(w, "iopt must be 0, 1 or 2")
            if isinstance(g, QuadGroup) and m.nsd != 2:
                warn(w, "quad element expects nsd = 2")
            nen = g.nen
        for e in g.elements:
            we = f"{w}.elements[{e.n}]"
            if len(e.nodes) != nen:
                err(we, f"expected {nen} nodes, got {len(e.nodes)}")
            for nd in e.nodes:
                if not 1 <= nd <= numnp:
                    err(we, f"node {nd} outside 1..{numnp}")
            if not 1 <= e.mat <= len(g.materials):
                err(we, f"material {e.mat} outside 1..{len(g.materials)}")
        for h in g.histories:
            wh = f"{w}.histories[el {h.element}]"
            if not 1 <= h.element <= numel:
                err(wh, f"element outside 1..{numel}")
            ncomp = {"truss": 3, "quad": 16, "brick": 24}[g.kind]
            if not 1 <= h.component <= ncomp:
                err(wh, f"component outside 1..{ncomp}")
            if c.iacode == 1:
                warn(wh, "stress histories are ignored in a static analysis")
        for s in getattr(g, "surfaces", []):
            ws = f"{w}.surfaces[el {s.element}]"
            if not 1 <= s.element <= numel:
                err(ws, f"element outside 1..{numel}")
            nsides = 4 if g.kind == "quad" else 6
            if not 1 <= s.side <= nsides:
                err(ws, f"side outside 1..{nsides}")

    # -- Hermitian build size limit ---------------------------------------
    if c.iacode == 2:
        fixed = _count_fixed_dofs(m, numnp)
        neq = numnp * m.ndof - fixed
        if neq > HERMITIAN_MAX_NEQ:
            err("control.iacode", f"Hermitian build holds dense {HERMITIAN_MAX_NEQ}x{HERMITIAN_MAX_NEQ} "
                                  f"matrices; this model has about {neq} equations")
    return P


def _check_gen(e, w, err):
    if e.numgp not in (0, 2, 3, 4, 8, 20):
        err(w, "numgp must be 0, 2, 3, 4, 8 or 20")
    if e.numgp:
        if len(e.points) != e.numgp - 1:
            err(w, f"numgp = {e.numgp} needs {e.numgp - 1} generation points, got {len(e.points)}")
        if not e.ninc:
            err(w, "generation needs at least (ninc, inc) for direction 1")
        if len(e.ninc) > 3:
            err(w, "at most 3 generation directions")


def _count_fixed_dofs(m: Model, numnp: int) -> int:
    fixed = set()
    for b in m.boundary_conditions:
        nodes = range(b.node, b.last + 1, b.inc) if b.inc else [b.node]
        for nd in nodes:
            for i, code in enumerate(b.codes):
                if code:
                    fixed.add((nd, i))
    return len(fixed)
