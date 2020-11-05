#!/usr/bin/env bash

if [ "$#" -ne 4 ] || ! test -f "$1" || ! test -f "$2" || ! test -f "$3" || ! test -f "$4"; then
  echo "Usage: sh Pipeline.sh in_file1.lp in_file2.lp out_file1.lp out_file2.lp"
  exit 1
fi

# Clingo needs: in_file1.lp in_file2.lp as input files to evaluate result,
# and: out_file.lp as output file.
clingo "$1" "$2" -t $(eval "nproc") > "$3"

# Parser needs: out_file1.lp as input file to parse result,
# and: out_file2.lp as autput file.
python3 Parser.py "$3" "$4"