#!/usr/bin/env bash

if [ "$#" -ne 2 ] || ! test -f "$1" || ! test -f "$2"; then
  echo "Usage: Pipeline.sh input_file_1.lp input_file_2.lp"
  exit 1
fi

clingo "$1" "$2" -t 8 > "output.lp"

python3 Parser.py "output.lp"
