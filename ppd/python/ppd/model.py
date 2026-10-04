"""Data model of a DLEARN problem.

Field names follow the DLEARN variable names (Hughes 1987, ch. 11) so that the
Fortran listing, the thesis annex and this code can be read side by side.
See docs/dlearn-input-format.md for the meaning and the card layout.
"""

from __future__ import annotations

from dataclasses import dataclass, field
from typing import List, Optional, Tuple, Union

#: Control-card layouts.  "hermitian" = 2001 UNESP build (IORDHERM in cols 11-15);
#: "zace" = original Hughes / ZACE 1997 build (no IORDHERM field).
LAYOUTS = ("hermitian", "zace")

ANALYSIS_CODES = {"dynamic": 0, "static": 1, "hermitian": 2}
HISTORY_KINDS = {"displacement": 1, "velocity": 2, "acceleration": 3}


@dataclass
class Control:
    """Execution control card (section 2 of the format spec)."""
    iexec: int = 1        # 0 data check, 1 execute
    iacode: int = 0       # 0 dynamic, 1 static, 2 Hermitian
    iordherm: int = 0     # Hermitian order 1-4 (hermitian layout only)
    ireadr: int = 0       # read restart file
    iwritr: int = 0       # write restart file
    iprtin: int = 0       # 0 print input data, 1 do not
    irank: int = 0        # rank check 0/1/2

    @property
    def dynamic(self) -> bool:
        return self.iacode != 1


@dataclass
class TimeSequence:
    nstep: int = 1
    ndprt: int = 1
    nsprt: int = 1
    nhplt: int = 0
    niter: int = 1
    alpha: float = 0.0
    beta: float = 0.25
    gamma: float = 0.5
    dt: float = 1.0


@dataclass
class NodalHistory:
    node: int
    dof: int
    kind: int = 1  # 1 displacement, 2 velocity, 3 acceleration


@dataclass
class GenPoint:
    """One generation point (card 5.2 / 7.2 / 9.2)."""
    values: List[float] = field(default_factory=list)
    m: int = 0      # node whose values are reused when mgen = 1
    mgen: int = 0


@dataclass
class GenEntry:
    """One entry of a GENFL block: a node with optional generation data."""
    node: int
    values: List[float] = field(default_factory=list)
    numgp: int = 0
    points: List[GenPoint] = field(default_factory=list)   # numgp - 1 points
    ninc: List[Tuple[int, int]] = field(default_factory=list)  # (ninc, inc) per direction, up to 3


@dataclass
class BoundaryCondition:
    node: int
    codes: List[int] = field(default_factory=list)  # one per dof: 0 free, 1 disp, 2 vel, 3 acc
    last: int = 0   # NE: last node of generated sequence
    inc: int = 0    # NG: node increment (0 = no generation)


@dataclass
class TrussMaterial:
    id: int
    e: float
    rho: float = 0.0
    rdampm: float = 0.0
    rdampk: float = 0.0
    area: float = 1.0


@dataclass
class QuadMaterial:
    id: int
    e: float
    pois: float
    rho: float = 0.0
    rdampm: float = 0.0
    rdampk: float = 0.0
    th: float = 1.0


@dataclass
class BrickMaterial:
    id: int
    e: float
    pois: float
    rho: float = 0.0
    rdampm: float = 0.0
    rdampk: float = 0.0


@dataclass
class ElementEntry:
    """One entry of a GENEL block."""
    n: int
    mat: int
    nodes: List[int] = field(default_factory=list)
    # generation: list of (nel, incel, inc) per direction (up to 3); empty = NG 0
    generate: List[Tuple[int, int, int]] = field(default_factory=list)


@dataclass
class SurfaceLoad:
    element: int
    side: int
    values: List[float] = field(default_factory=list)  # quad: p1 p2 s1 s2; brick: p1..p4


@dataclass
class StressHistory:
    element: int
    intpt: int
    component: int


@dataclass
class TrussGroup:
    ntype: int = 2
    nen: int = 2
    nsout_: int = 0          # derived from histories; kept for files that declare more
    istprt: int = 0
    lfbody: int = 0
    nint: int = 1
    imass: int = 1
    impexp: int = 0
    materials: List[TrussMaterial] = field(default_factory=list)
    gravity: List[float] = field(default_factory=lambda: [0.0, 0.0, 0.0])
    elements: List[ElementEntry] = field(default_factory=list)
    histories: List[StressHistory] = field(default_factory=list)
    numel: Optional[int] = None   # None -> computed from elements (incl. generation)

    kind = "truss"


@dataclass
class QuadGroup:
    ntype: int = 1
    iopt: int = 0
    istprt: int = 0
    lfsurf: int = 0
    lfbody: int = 0
    nicode: int = 0
    ibbar: int = 0
    imass: int = 1
    impexp: int = 0
    materials: List[QuadMaterial] = field(default_factory=list)
    gravity: List[float] = field(default_factory=lambda: [0.0, 0.0])
    elements: List[ElementEntry] = field(default_factory=list)
    surfaces: List[SurfaceLoad] = field(default_factory=list)
    histories: List[StressHistory] = field(default_factory=list)
    numel: Optional[int] = None

    kind = "quad"
    nen = 4


@dataclass
class BrickGroup:
    ntype: int = 3
    iopt: int = 0
    istprt: int = 0
    lfsurf: int = 0
    lfbody: int = 0
    nicode: int = 0
    ibbar: int = 0
    imass: int = 1
    impexp: int = 0
    materials: List[BrickMaterial] = field(default_factory=list)
    gravity: List[float] = field(default_factory=lambda: [0.0, 0.0, 0.0])
    elements: List[ElementEntry] = field(default_factory=list)
    surfaces: List[SurfaceLoad] = field(default_factory=list)
    histories: List[StressHistory] = field(default_factory=list)
    numel: Optional[int] = None

    kind = "brick"
    nen = 8


ElementGroup = Union[TrussGroup, QuadGroup, BrickGroup]


@dataclass
class Model:
    title: str = ""
    echo: bool = True
    control: Control = field(default_factory=Control)
    nsd: int = 2
    ndof: int = 2
    numnp: Optional[int] = None     # None -> computed from coordinates
    time_sequences: List[TimeSequence] = field(default_factory=lambda: [TimeSequence()])
    nodal_histories: List[NodalHistory] = field(default_factory=list)
    coordinates: List[GenEntry] = field(default_factory=list)
    boundary_conditions: List[BoundaryCondition] = field(default_factory=list)
    loads: List[List[GenEntry]] = field(default_factory=list)          # NLVECT blocks
    time_functions: List[List[Tuple[float, float]]] = field(default_factory=list)  # NLTFTN × NPTSLF
    initial_displacements: List[GenEntry] = field(default_factory=list)
    initial_velocities: List[GenEntry] = field(default_factory=list)
    initial_accelerations: List[GenEntry] = field(default_factory=list)
    element_groups: List[ElementGroup] = field(default_factory=list)

    # ---- derived counts -------------------------------------------------
    @property
    def numseq(self) -> int:
        return len(self.time_sequences)

    @property
    def ndout(self) -> int:
        return len(self.nodal_histories)

    @property
    def nlvect(self) -> int:
        return len(self.loads)

    @property
    def nltftn(self) -> int:
        return len(self.time_functions)

    @property
    def nptslf(self) -> int:
        return max((len(f) for f in self.time_functions), default=0)

    @property
    def numeg(self) -> int:
        return len(self.element_groups)

    def node_count(self) -> int:
        """NUMNP: explicit value, or the highest node number implied by the coordinate block."""
        if self.numnp is not None:
            return self.numnp
        return max((n for n in generated_nodes(self.coordinates)), default=0)


def generated_nodes(block: List[GenEntry]) -> List[int]:
    """Node numbers defined by a GENFL block, including those produced by generation.

    Mirrors DLEARN's GENFL1: for an entry with numgp != 0, nodes
    n + i*inc1 + j*inc2 + k*inc3 for i in 0..ninc1, j in 0..ninc2, k in 0..ninc3.
    """
    out: List[int] = []
    for e in block:
        if e.numgp == 0:
            out.append(e.node)
            continue
        dirs = list(e.ninc) + [(0, 0)] * (3 - len(e.ninc))
        (n1, i1), (n2, i2), (n3, i3) = dirs[:3]
        for k in range(n3 + 1):
            for j in range(n2 + 1):
                for i in range(n1 + 1):
                    out.append(e.node + i * i1 + j * i2 + k * i3)
    return out


def generated_elements(block: List[ElementEntry]) -> List[int]:
    """Element numbers defined by a GENEL block, including generation (GENEL1/GENELD).

    NEL(i) is the *total* number of elements in direction i (a value of 0 or 1
    means no generation in that direction); INCEL(i) is the element-number
    increment, with the defaults of GENELD when 0.
    """
    out: List[int] = []
    for e in block:
        if not e.generate:
            out.append(e.n)
            continue
        dirs = list(e.generate) + [(0, 0, 0)] * (3 - len(e.generate))
        nel = [d[0] or 1 for d in dirs[:3]]
        incel = [d[1] for d in dirs[:3]]
        if incel[0] == 0:
            incel[0] = 1
        if incel[1] == 0:
            incel[1] = nel[0]
        if incel[2] == 0:
            incel[2] = nel[0] * nel[1]
        for k in range(nel[2]):
            for j in range(nel[1]):
                for i in range(nel[0]):
                    out.append(e.n + i * incel[0] + j * incel[1] + k * incel[2])
    return out


def group_numel(g: ElementGroup) -> int:
    if g.numel is not None:
        return g.numel
    return max(generated_elements(g.elements), default=0)
