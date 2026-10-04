import copy
from conftest import TRELICA
from ppd import load_yaml, validate


def errors(m, layout="hermitian"):
    return [p.message for p in validate(m, layout) if p.level == "error"]


def test_reference_model_is_clean():
    m = load_yaml(TRELICA / "trelica.yaml")
    assert errors(m) == []


def test_hermitian_order_range():
    m = load_yaml(TRELICA / "trelica.yaml")
    m.control.iordherm = 5
    assert any("1-4" in e for e in errors(m))


def test_hermitian_needs_hermitian_layout():
    m = load_yaml(TRELICA / "trelica.yaml")
    assert any("layout" in e for e in errors(m, "zace"))


def test_node_references():
    m = load_yaml(TRELICA / "trelica.yaml")
    m.loads[0][0].node = 99
    assert any("node outside" in e for e in errors(m))


def test_poisson_half_rejected():
    from ppd import QuadGroup, QuadMaterial, ElementEntry
    m = load_yaml(TRELICA / "trelica.yaml")
    m.element_groups = [QuadGroup(materials=[QuadMaterial(1, 1.0, 0.5)],
                                  elements=[ElementEntry(1, 1, [1, 2, 5, 4])])]
    assert any("Poisson" in e for e in errors(m))


def test_lfbody_must_reference_existing_function():
    m = load_yaml(TRELICA / "trelica.yaml")
    m.element_groups[0].lfbody = 3
    assert any("lfbody" in e for e in errors(m))


def test_hermitian_size_limit():
    m = load_yaml(TRELICA / "trelica.yaml")
    m.numnp = 60   # 60*3 - 6 fixed = 174 > 100
    assert any("equations" in e for e in errors(m))
