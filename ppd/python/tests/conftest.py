import os
from pathlib import Path
import pytest

ROOT = Path(__file__).resolve().parents[3]          # repository root
ZACE_EX = ROOT / "dlearn" / "zace-1997" / "examples"
HERM_EX = ROOT / "dlearn" / "hermitian-2001" / "examples"
TRELICA = ROOT / "examples" / "trelica"


@pytest.fixture
def root():
    return ROOT


def dlearn_exe(tree: str):
    """Path of a built dlearn executable, or None (tests that need it are skipped)."""
    p = ROOT / "dlearn" / tree / "dlearn"
    if p.exists() and os.access(p, os.X_OK):
        return p
    return None
