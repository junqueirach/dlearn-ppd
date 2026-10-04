"""End-to-end: build the truss example and run it through the Fortran, if built.
Build the executables first:  (cd dlearn/zace-1997 && make)  (cd dlearn/hermitian-2001 && make)"""
import subprocess
import pytest
from conftest import TRELICA, dlearn_exe
from ppd import load_yaml, write_dat


@pytest.mark.skipif(dlearn_exe("hermitian-2001") is None, reason="hermitian dlearn not built")
def test_hermitian_run(tmp_path):
    exe = dlearn_exe("hermitian-2001")
    m = load_yaml(TRELICA / "trelica.yaml")
    inp, out = tmp_path / "t.dat", tmp_path / "t.out"
    write_dat(m, inp, "hermitian")
    r = subprocess.run([str(exe)], input=f"{inp}\n{out}\n", text=True, cwd=tmp_path, capture_output=True)
    assert r.returncode == 0, r.stdout + r.stderr
    text = out.read_text()
    assert "(iordherm) =     2" in text
    assert text.count("d i s p l a c e m e n t s") == 100


@pytest.mark.skipif(dlearn_exe("zace-1997") is None, reason="zace dlearn not built")
def test_zace_run(tmp_path):
    exe = dlearn_exe("zace-1997")
    m = load_yaml(TRELICA / "trelica.yaml")
    m.control.iacode = 0
    write_dat(m, tmp_path / "input.dat", "zace")
    r = subprocess.run([str(exe)], cwd=tmp_path, capture_output=True, text=True)
    assert r.returncode == 0, r.stdout + r.stderr
    assert (tmp_path / "output.dat").read_text().count("d i s p l a c e m e n t s") == 100
