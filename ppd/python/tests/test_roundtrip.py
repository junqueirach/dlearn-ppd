"""Read every reference .DAT, write it back, read again: the models must be equal,
and the written file must contain the same numbers card by card."""
import pytest
from conftest import ZACE_EX, HERM_EX, TRELICA
from ppd import read_dat, to_lines, from_lines, validate
from ppd.reader import read_dat_with_layout
from ppd.cards import parse_ints

ZACE_FILES = sorted(ZACE_EX.glob("*.DAT"))
HERM_FILES = sorted(HERM_EX.glob("*.dat"))


@pytest.mark.parametrize("path", ZACE_FILES, ids=[p.name for p in ZACE_FILES])
def test_zace_examples_round_trip(path):
    m, layout = read_dat_with_layout(path)
    assert layout == "zace"
    lines = to_lines(m, layout)
    m2, _ = from_lines(lines, layout)
    assert m2 == m
    assert not [p for p in validate(m, layout) if p.level == "error"]


@pytest.mark.parametrize("path", HERM_FILES, ids=[p.name for p in HERM_FILES])
def test_hermitian_examples_round_trip(path):
    m, layout = read_dat_with_layout(path)
    assert layout == "hermitian"
    lines = to_lines(m, layout)
    m2, _ = from_lines(lines, layout)
    assert m2 == m
    assert not [p for p in validate(m, layout) if p.level == "error"]


def test_layout_detection_from_control_card():
    tu1 = (ZACE_EX / "TU1.DAT").read_text().splitlines()
    assert parse_ints(tu1[2], 16)[15] == 0
    m, layout = from_lines(tu1)
    assert layout == "zace" and m.numeg == 1 and m.node_count() == 18


def test_yaml_matches_reference_dat():
    from ppd import load_yaml
    m = load_yaml(TRELICA / "trelica.yaml")
    herm = (TRELICA / "trelica-hermitian.dat").read_text().splitlines()
    assert to_lines(m, "hermitian") == herm
    m.control.iacode = 0; m.control.iordherm = 0
    zace = (TRELICA / "trelica-zace.dat").read_text().splitlines()
    assert to_lines(m, "zace") == zace


def test_yaml_dump_load_round_trip(tmp_path):
    from ppd import dump_yaml, load_yaml
    m = read_dat(ZACE_EX / "TU1.DAT")
    dump_yaml(m, tmp_path / "tu1.yaml")
    m2 = load_yaml(tmp_path / "tu1.yaml")
    assert to_lines(m2, "zace") == to_lines(m, "zace")
