#!/usr/bin/env bash

if [ "$#" -ne 4 ] || ! test -f "$1" || ! test -f "$2" || ! test -f "$3" || ! test -f "$4"; then
  echo "Usage: sh pipeline.sh [In]Asp/arteries_classifier.lp [In]Asp/arteries_scandata.lp [Out]Asp/arteries_classified.lp [Out]Asp/arteries_parsed.lp"
  exit 1
fi

# Clingo needs: [In]Asp/arteries_classifier.lp and [In]Asp/arteries_scandata.lp
# as input files to evaluate result, and: [Out]Asp/arteries_classified.lp as output file.
clingo "$1" "$2" -t $(eval "nproc") > "$3"

# Parser needs: [In]Asp/arteries_classifier.lp and  [In]Asp/arteries_classified.lp
# as input file to parse result, and: [Out]Asp/arteries_parsed.lp as autput file.
python3 main.py "$1" "$3" "$4"
