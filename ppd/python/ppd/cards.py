"""Fixed-column field formatting and parsing (Fortran I5 / F10.0 editing)."""

from __future__ import annotations

from typing import List, Optional

I_WIDTH = 5
F_WIDTH = 10
LINE_WIDTH = 80


def fmt_int(v: Optional[int]) -> str:
    """Integer in an I5 field (blank when None)."""
    if v is None:
        return " " * I_WIDTH
    s = f"{int(v):{I_WIDTH}d}"
    if len(s) > I_WIDTH:
        raise ValueError(f"integer {v} does not fit in an I5 field")
    return s


def fmt_real(x: Optional[float]) -> str:
    """Real in an F10 field, choosing the most readable representation that
    (a) fits in 10 columns and (b) is read back by Fortran F10.0 editing with
    negligible loss.  0 is written as 0.0000."""
    if x is None:
        return " " * F_WIDTH
    x = float(x)
    if x == 0.0:
        return f"{0.0:{F_WIDTH}.4f}"
    best = None
    for spec in (".4f", ".3f", ".2f", ".1f", ".0f", ".6f", ".4E", ".3E", ".2E"):
        s = f"{x:{spec}}"
        if len(s) > F_WIDTH:
            continue
        err = abs(float(s) - x) / max(abs(x), 1e-300)
        if err <= 1e-6:
            return f"{s:>{F_WIDTH}}"
        if best is None or err < best[0]:
            best = (err, s)
    if best is None:
        raise ValueError(f"real {x} does not fit in an F10 field")
    return f"{best[1]:>{F_WIDTH}}"


def ints(*values: Optional[int]) -> str:
    return "".join(fmt_int(v) for v in values)


def reals(*values: Optional[float]) -> str:
    return "".join(fmt_real(v) for v in values)


def blank() -> str:
    return ""


# ---------------------------------------------------------------- parsing

def _field(line: str, start: int, width: int) -> str:
    """Columns start..start+width-1 (1-based), padded with blanks."""
    s = line[start - 1:start - 1 + width]
    return s + " " * (width - len(s))


def parse_ints(line: str, n: int, start: int = 1, width: int = I_WIDTH) -> List[int]:
    out = []
    for i in range(n):
        f = _field(line, start + i * width, width).strip()
        out.append(int(f) if f else 0)
    return out


def parse_reals(line: str, n: int, start: int, width: int = F_WIDTH) -> List[float]:
    out = []
    for i in range(n):
        f = _field(line, start + i * width, width).strip()
        if not f:
            out.append(0.0)
            continue
        # Fortran accepts "1.5D0", "+5", "7.3E-06", ".5"; embedded blanks are
        # ignored (BLANK='NULL' default), e.g. "    0 10.0" reads as 10.0
        f = f.replace(" ", "").replace("D", "E").replace("d", "e")
        out.append(float(f))
    return out
