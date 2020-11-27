#!/usr/bin/env bash

if [ "$#" -ne 4 ] || ! test -f "$1" || ! test -f "$2" || ! test -f "$3" || ! test -f "$4"; then
  echo "Usage: sh pipeline.sh in_arteries_classifier.lp in_arteries_scandata.lp out_arteries_classified.lp out_arteries_parsed.lp"
  exit 1
fi

# Clingo needs: in_file1.lp in_file2.lp as input files to evaluate result,
# and: out_file.lp as output file.
clingo "$1" "$2" -t $(eval "nproc") > "$3"

# Parser needs: out_file1.lp as input file to parse result,
# and: out_file2.lp as autput file.
python3 parser.py "$3" "$4"