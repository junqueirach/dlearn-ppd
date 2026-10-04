"""Model <-> plain dict / YAML / JSON.

The YAML schema is deliberately close to the data model.  Human-friendly
aliases are accepted on input: ``analysis: static|dynamic|hermitian`` for
``iacode``, ``kind: displacement|velocity|acceleration`` for nodal histories,
``type: truss|quad|brick`` for element groups, and ``generate:`` sub-maps for
GENFL / GENEL generation data.  See examples/trelica/trelica.yaml.
"""

from __future__ import annotations

import json
from dataclasses import asdict
from typing import Any, Dict, List

from .model import (
    Model, Control, TimeSequence, NodalHistory, GenEntry, GenPoint,
    BoundaryCondition, TrussMaterial, QuadMaterial, BrickMaterial,
    ElementEntry, SurfaceLoad, StressHistory, TrussGroup, QuadGroup, BrickGroup,
    ANALYSIS_CODES, HISTORY_KINDS,
)

_ANALYSIS_NAMES = {v: k for k, v in ANALYSIS_CODES.items()}
_KIND_NAMES = {v: k for k, v in HISTORY_KINDS.items()}


# ------------------------------------------------------------------ to dict

def _gen_entry_to_dict(e: GenEntry) -> Dict[str, Any]:
    d: Dict[str, Any] = {"node": e.node, "values": list(e.values)}
    if e.numgp:
        pts = []
        for p in e.points:
            pts.append({"node": p.m} if p.mgen else list(p.values))
        d["generate"] = {"numgp": e.numgp, "points": pts, "ninc": [list(x) for x in e.ninc]}
    return d


def _element_to_dict(e: ElementEntry) -> Dict[str, Any]:
    d: Dict[str, Any] = {"n": e.n, "mat": e.mat, "nodes": list(e.nodes)}
    if e.generate:
        d["generate"] = [list(t) for t in e.generate]
    return d


def _group_to_dict(g) -> Dict[str, Any]:
    d: Dict[str, Any] = {"type": g.kind}
    skip = {"ntype", "materials", "elements", "histories", "surfaces", "gravity", "numel", "nsout_"}
    for k, v in asdict(g).items():
        if k not in skip:
            d[k] = v
    if g.numel is not None:
        d["numel"] = g.numel
    d["materials"] = [asdict(mt) for mt in g.materials]
    d["gravity"] = list(g.gravity)
    d["elements"] = [_element_to_dict(e) for e in g.elements]
    if getattr(g, "surfaces", None):
        d["surfaces"] = [asdict(s) for s in g.surfaces]
    if g.histories:
        d["histories"] = [asdict(h) for h in g.histories]
    return d


def model_to_dict(m: Model) -> Dict[str, Any]:
    c = m.control
    d: Dict[str, Any] = {
        "title": m.title,
        "echo": m.echo,
        "analysis": _ANALYSIS_NAMES.get(c.iacode, c.iacode),
    }
    if c.iacode == 2:
        d["hermitian_order"] = c.iordherm
    d.update({
        "execute": bool(c.iexec),
        "read_restart": bool(c.ireadr),
        "write_restart": bool(c.iwritr),
        "print_input": c.iprtin == 0,
        "rank_check": c.irank,
        "nsd": m.nsd,
        "ndof": m.ndof,
    })
    if m.numnp is not None:
        d["numnp"] = m.numnp
    d["time_sequences"] = [asdict(s) for s in m.time_sequences]
    d["nodal_histories"] = [{"node": h.node, "dof": h.dof, "kind": _KIND_NAMES.get(h.kind, h.kind)}
                            for h in m.nodal_histories]
    d["coordinates"] = [_gen_entry_to_dict(e) for e in m.coordinates]
    bcs = []
    for b in m.boundary_conditions:
        bd: Dict[str, Any] = {"node": b.node, "codes": list(b.codes)}
        if b.inc:
            bd["last"] = b.last
            bd["inc"] = b.inc
        bcs.append(bd)
    d["boundary_conditions"] = bcs
    d["loads"] = [[_gen_entry_to_dict(e) for e in block] for block in m.loads]
    d["time_functions"] = [[list(p) for p in f] for f in m.time_functions]
    d["initial_conditions"] = {
        "displacements": [_gen_entry_to_dict(e) for e in m.initial_displacements],
        "velocities": [_gen_entry_to_dict(e) for e in m.initial_velocities],
        "accelerations": [_gen_entry_to_dict(e) for e in m.initial_accelerations],
    }
    d["element_groups"] = [_group_to_dict(g) for g in m.element_groups]
    return d


# ---------------------------------------------------------------- from dict

def _gen_entry(d: Dict[str, Any]) -> GenEntry:
    e = GenEntry(node=int(d["node"]), values=[float(v) for v in d.get("values", [])])
    g = d.get("generate")
    if g:
        e.numgp = int(g["numgp"])
        for p in g.get("points", []):
            if isinstance(p, dict):
                e.points.append(GenPoint(m=int(p["node"]), mgen=1))
            else:
                e.points.append(GenPoint(values=[float(v) for v in p]))
        e.ninc = [(int(a), int(b)) for a, b in g.get("ninc", [])]
    return e


def _element(d: Dict[str, Any]) -> ElementEntry:
    e = ElementEntry(n=int(d["n"]), mat=int(d.get("mat", 1)), nodes=[int(x) for x in d["nodes"]])
    for t in d.get("generate", []) or []:
        e.generate.append(tuple(int(x) for x in t))  # type: ignore[arg-type]
    return e


def _group(d: Dict[str, Any]):
    t = str(d.get("type", "truss")).lower()
    common = {k: d[k] for k in ("istprt", "lfbody", "imass", "impexp", "numel") if k in d}
    mats = [dict(mt, id=int(mt.get("id") or i)) for i, mt in enumerate(d.get("materials", []), 1)]
    if t == "truss":
        g = TrussGroup(nen=int(d.get("nen", 2)), nint=int(d.get("nint", 1)), **common)
        g.materials = [TrussMaterial(**mt) for mt in mats]
    elif t == "quad":
        extra = {k: d[k] for k in ("iopt", "lfsurf", "nicode", "ibbar") if k in d}
        g = QuadGroup(**common, **extra)
        g.materials = [QuadMaterial(**mt) for mt in mats]
    elif t == "brick":
        extra = {k: d[k] for k in ("iopt", "lfsurf", "nicode", "ibbar") if k in d}
        g = BrickGroup(**common, **extra)
        g.materials = [BrickMaterial(**mt) for mt in mats]
    else:
        raise ValueError(f"unknown element group type {t!r}")
    if "gravity" in d:
        g.gravity = [float(v) for v in d["gravity"]]
    g.elements = [_element(e) for e in d.get("elements", [])]
    if t != "truss":
        g.surfaces = [SurfaceLoad(int(s["element"]), int(s["side"]), [float(v) for v in s.get("values", [])])
                      for s in d.get("surfaces", [])]
    g.histories = [StressHistory(int(h["element"]), int(h.get("intpt", 1)), int(h["component"]))
                   for h in d.get("histories", [])]
    return g


def model_from_dict(d: Dict[str, Any]) -> Model:
    m = Model(title=str(d.get("title", "")), echo=bool(d.get("echo", True)))
    a = d.get("analysis", "dynamic")
    iacode = ANALYSIS_CODES[a.lower()] if isinstance(a, str) else int(a)
    m.control = Control(
        iexec=1 if d.get("execute", True) else 0,
        iacode=iacode,
        iordherm=int(d.get("hermitian_order", 0)),
        ireadr=1 if d.get("read_restart", False) else 0,
        iwritr=1 if d.get("write_restart", False) else 0,
        iprtin=0 if d.get("print_input", True) else 1,
        irank=int(d.get("rank_check", 0)),
    )
    m.nsd = int(d.get("nsd", 2))
    m.ndof = int(d.get("ndof", m.nsd))
    m.numnp = int(d["numnp"]) if d.get("numnp") is not None else None
    m.time_sequences = [TimeSequence(**s) for s in d.get("time_sequences", [{}])]
    hs = []
    for h in d.get("nodal_histories", []):
        k = h.get("kind", 1)
        hs.append(NodalHistory(int(h["node"]), int(h["dof"]),
                               HISTORY_KINDS[k.lower()] if isinstance(k, str) else int(k)))
    m.nodal_histories = hs
    m.coordinates = [_gen_entry(e) for e in d.get("coordinates", [])]
    m.boundary_conditions = [BoundaryCondition(int(b["node"]), [int(x) for x in b["codes"]],
                                               int(b.get("last", 0)), int(b.get("inc", 0)))
                             for b in d.get("boundary_conditions", [])]
    m.loads = [[_gen_entry(e) for e in block] for block in d.get("loads", [])]
    m.time_functions = [[(float(t), float(v)) for t, v in f] for f in d.get("time_functions", [])]
    ic = d.get("initial_conditions", {}) or {}
    m.initial_displacements = [_gen_entry(e) for e in ic.get("displacements", [])]
    m.initial_velocities = [_gen_entry(e) for e in ic.get("velocities", [])]
    m.initial_accelerations = [_gen_entry(e) for e in ic.get("accelerations", [])]
    m.element_groups = [_group(g) for g in d.get("element_groups", [])]
    return m


# ------------------------------------------------------------- file helpers

def _load_text(path) -> Dict[str, Any]:
    with open(path, "r", encoding="utf-8") as fh:
        text = fh.read()
    if str(path).lower().endswith(".json"):
        return json.loads(text)
    import yaml  # PyYAML
    return yaml.safe_load(text)


def load_yaml(path) -> Model:
    """Load a model from a .yaml/.yml or .json file."""
    return model_from_dict(_load_text(path))


def dump_yaml(m: Model, path=None) -> str:
    """Serialise a model to YAML (returned, and written to *path* if given)."""
    import yaml
    text = yaml.safe_dump(model_to_dict(m), sort_keys=False, allow_unicode=True, width=100)
    if path is not None:
        with open(path, "w", encoding="utf-8") as fh:
            fh.write(text)
    return text
