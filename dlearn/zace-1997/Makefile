# DLEARN (Hughes / ZACE 1997 distribution) - build with gfortran
#
#   make          build ./dlearn
#   make check    run the nine textbook examples in examples/ and report
#   make clean
#
# Sources excluded from the link (kept in src/ for completeness):
#   EL1.FOR   original ELMLIB without the brick element (superseded by EL2.FOR)
#   LANSO.FOR Lanczos eigensolver (B. Nour-Omid, 1986) - not called by DLEARN,
#             uses the VMS RAN() intrinsic
# GFCOMPAT.FOR is a 2026 addition providing GETTIM (MS PowerStation extension).

FC      ?= gfortran
FFLAGS  ?= -std=legacy -ffixed-form -fno-automatic -w -O2
SRC     := $(filter-out src/EL1.FOR src/LANSO.FOR,$(wildcard src/*.FOR))
OBJ     := $(patsubst src/%.FOR,build/%.o,$(SRC))
EXAMPLES:= TRELICA TU1 TU2 TU3 TU4 TU5 TU6 TH1 TH2 WE1

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
	  cp examples/$$e.DAT build/check/input.dat; rm -f build/check/output.dat; \
	  ( cd build/check && ../../dlearn > $$e.log 2>&1 ); rc=$$?; \
	  mv build/check/output.dat build/check/$$e.out 2>/dev/null; \
	  if [ $$rc -eq 0 ] && ! grep -qi "nan" build/check/$$e.out; then echo "ok   $$e"; else echo "FAIL $$e (rc=$$rc)"; fi; \
	done

clean:
	rm -rf build dlearn

.PHONY: all check clean
