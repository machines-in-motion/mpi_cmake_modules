#!/bin/bash
if [ "$#" -lt 1 ]; then
  echo "Usage: ./check_format.sh <clang-format-executable>" >&2
  exit 0
fi

files=`find . -path ./cmake -prune -o -iregex '.*\.\(h\|c\|hh\|cc\|hpp\|cpp\|hxx\|cxx\)$' -print`
$1 -i $files

echo $format_out
if [ "$format" = "" ]; then
  echo "Code formatted."
  exit 0
else
  echo "Error while formatting: $format_out."
  exit 0
fi
