# DLEARN + Hermitian algorithms (Bottura / UNESP Bauru, 2001) - build with gfortran
#
#   make          build ./dlearn
#   make check    run examples/*.dat through the Hermitian integrator
#   make clean
#
# Sources excluded from the link (kept in src/ for completeness):
#   heitor2.for   earlier draft of HEITOR.FOR (not in the original TTNOVO.FMK project)
# GFCOMPAT.FOR is a 2026 addition providing GETTIM (MS PowerStation extension).
#
# This build reads the input and output file names from standard input
# (two lines), exactly like the 2001 executable:  ./dlearn < names.txt
# The helper script run.sh wraps that.

FC      ?= gfortran
FFLAGS  ?= -std=legacy -ffixed-form -fno-automatic -w -O2
SRC     := $(filter-out src/heitor2.for,$(wildcard src/*.FOR))
OBJ     := $(patsubst src/%.FOR,build/%.o,$(SRC))
EXAMPLES:= $(notdir $(basename $(wildcard examples/*.dat)))

all: dlearn

dlearn: $(OBJ)
	$(FC) $(FFLAGS) -o $@ $(OBJ)

build/%.o: src/%.FOR | build
	$(FC) $(FFLAGS) -c $< -o $@

build:
	mkdir -p build

check: dlearn
	@mkdir -p build/check
	@for e in $(EXAMPLES); do \
	  cp examples/$$e.dat build/check/$$e.dat; rm -f build/check/$$e.out; \
	  ( cd build/check && printf '%s.dat\n%s.out\n' $$e $$e | ../../dlearn > $$e.log 2>&1 ); rc=$$?; \
	  if [ $$rc -eq 0 ] && grep -q "hermitian algorithm error order" build/check/$$e.out && ! grep -qi "nan" build/check/$$e.out; then echo "ok   $$e"; else echo "FAIL $$e (rc=$$rc)"; fi; \
	done

clean:
	rm -rf build dlearn

.PHONY: all check clean
