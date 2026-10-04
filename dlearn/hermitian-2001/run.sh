#!/bin/sh
# run.sh INPUT.dat [OUTPUT.out]  -  run the Hermitian DLEARN on one input file
set -e
in="$1"; out="${2:-${1%.*}.out}"
[ -n "$in" ] || { echo "usage: $0 input.dat [output.out]"; exit 1; }
rm -f "$out"
printf '%s\n%s\n' "$in" "$out" | "$(dirname "$0")/dlearn"
echo "wrote $out"
