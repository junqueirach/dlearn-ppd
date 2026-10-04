"""ppd - Pre-Processor for DLEARN.

Build, read, validate and write DLEARN fixed-column input files from a plain
Python data model (or from YAML/JSON).  A 2026 rewrite of the 2001 Turbo Pascal
program of the same name (see ../legacy-pascal).

Typical use::

    from ppd import load_yaml, write_dat, validate
    model = load_yaml("trelica.yaml")
    problems = validate(model)
    write_dat(model, "trelica.dat", layout="hermitian")
"""

from .model import (  # noqa: F401
    Model, Control, TimeSequence, NodalHistory, GenEntry, GenPoint,
    BoundaryCondition, TrussMaterial, QuadMaterial, BrickMaterial,
    ElementEntry, SurfaceLoad, StressHistory, TrussGroup, QuadGroup, BrickGroup,
    LAYOUTS,
)
from .writer import write_dat, to_lines  # noqa: F401
from .reader import read_dat, from_lines  # noqa: F401
from .validate import validate, Problem  # noqa: F401
from .yamlio import load_yaml, dump_yaml, model_to_dict, model_from_dict  # noqa: F401

__version__ = "2.0.0"
