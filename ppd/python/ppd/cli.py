"""Command-line interface.

    ppd build  model.yaml  -o model.dat  [--layout hermitian|zace] [--no-check]
    ppd check  model.yaml | model.dat    [--layout ...]
    ppd dump   model.dat   -o model.yaml [--layout ...]      (DAT -> YAML)
    ppd fmt    model.dat   -o model2.dat [--layout ...]      (re-write a DAT file)
    ppd run    model.yaml|model.dat --dlearn PATH [-o out.txt] [--layout ...]
"""

from __future__ import annotations

import argparse
import os
import subprocess
import sys
import tempfile
from pathlib import Path

from . import __version__
from .model import LAYOUTS
from .reader import read_dat_with_layout
from .validate import validate
from .writer import write_dat, to_lines
from .yamlio import load_yaml, dump_yaml


def _load(path: str, layout):
    p = str(path).lower()
    if p.endswith((".yaml", ".yml", ".json")):
        return load_yaml(path), (layout or "hermitian")
    m, used = read_dat_with_layout(path, layout)
    return m, used


def _report(problems, quiet=False) -> int:
    errors = [p for p in problems if p.level == "error"]
    if not quiet:
        for p in problems:
            print(p, file=sys.stderr)
        if not problems:
            print("ok: no problems found", file=sys.stderr)
    return 1 if errors else 0


def cmd_build(a) -> int:
    m, layout = _load(a.model, a.layout)
    if not a.no_check:
        rc = _report(validate(m, layout))
        if rc and not a.force:
            print("not written (use --force to write anyway)", file=sys.stderr)
            return rc
    out = a.output or str(Path(a.model).with_suffix(".dat"))
    write_dat(m, out, layout=layout, newline="\r\n" if a.crlf else "\n")
    print(f"wrote {out} ({layout} layout, {len(to_lines(m, layout))} cards)", file=sys.stderr)
    return 0


def cmd_check(a) -> int:
    m, layout = _load(a.model, a.layout)
    return _report(validate(m, layout))


def cmd_dump(a) -> int:
    m, layout = _load(a.model, a.layout)
    text = dump_yaml(m, a.output)
    if a.output:
        print(f"wrote {a.output} (read with {layout} layout)", file=sys.stderr)
    else:
        sys.stdout.write(text)
    return 0


def cmd_fmt(a) -> int:
    m, layout = _load(a.model, a.layout)
    out_layout = a.to or layout
    out = a.output or a.model
    write_dat(m, out, layout=out_layout)
    print(f"wrote {out} ({out_layout} layout)", file=sys.stderr)
    return 0


def cmd_run(a) -> int:
    """Build (if needed) and run a DLEARN executable on the model."""
    m, layout = _load(a.model, a.layout)
    rc = _report(validate(m, layout), quiet=False)
    if rc and not a.force:
        return rc
    exe = Path(a.dlearn).resolve()
    if not exe.exists():
        print(f"dlearn executable not found: {exe}", file=sys.stderr)
        return 2
    out = Path(a.output or Path(a.model).with_suffix(".out")).resolve()
    with tempfile.TemporaryDirectory() as td:
        inp = Path(td) / "input.dat"
        write_dat(m, inp, layout=layout)
        if layout == "hermitian":
            # the 2001 build asks for the two file names on standard input
            proc = subprocess.run([str(exe)], input=f"{inp}\n{out}\n", text=True,
                                  cwd=td, capture_output=True)
        else:
            proc = subprocess.run([str(exe)], cwd=td, text=True, capture_output=True)
            produced = Path(td) / "output.dat"
            if produced.exists():
                produced.replace(out)
        if proc.returncode != 0:
            sys.stderr.write(proc.stdout[-2000:] + proc.stderr[-2000:])
            print(f"dlearn exited with {proc.returncode}", file=sys.stderr)
            return proc.returncode
    print(f"wrote {out}", file=sys.stderr)
    return 0


def main(argv=None) -> int:
    ap = argparse.ArgumentParser(prog="ppd", description="Pre-Processor for DLEARN input files")
    ap.add_argument("--version", action="version", version=f"ppd {__version__}")
    sub = ap.add_subparsers(dest="cmd", required=True)

    def add_common(p):
        p.add_argument("model", help="model file: .yaml/.yml/.json, or a DLEARN .dat")
        p.add_argument("--layout", choices=LAYOUTS, default=None,
                       help="control-card layout (default: hermitian for YAML, auto-detected for .dat)")

    p = sub.add_parser("build", help="write a DLEARN input file"); add_common(p)
    p.add_argument("-o", "--output")
    p.add_argument("--no-check", action="store_true", help="skip validation")
    p.add_argument("--force", action="store_true", help="write even if validation reports errors")
    p.add_argument("--crlf", action="store_true", help="use Windows line endings")
    p.set_defaults(fn=cmd_build)

    p = sub.add_parser("check", help="validate a model"); add_common(p)
    p.set_defaults(fn=cmd_check)

    p = sub.add_parser("dump", help="convert a .dat (or YAML) to YAML"); add_common(p)
    p.add_argument("-o", "--output")
    p.set_defaults(fn=cmd_dump)

    p = sub.add_parser("fmt", help="re-write a .dat with canonical columns / another layout"); add_common(p)
    p.add_argument("-o", "--output")
    p.add_argument("--to", choices=LAYOUTS, help="output layout (default: same as input)")
    p.set_defaults(fn=cmd_fmt)

    p = sub.add_parser("run", help="build and run through a DLEARN executable"); add_common(p)
    p.add_argument("--dlearn", required=True, help="path to the dlearn executable")
    p.add_argument("-o", "--output")
    p.add_argument("--force", action="store_true")
    p.set_defaults(fn=cmd_run)

    a = ap.parse_args(argv)
    return a.fn(a)


if __name__ == "__main__":  # pragma: no cover
    sys.exit(main())
