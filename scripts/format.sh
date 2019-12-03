#!/bin/bash
if [ "$#" -lt 2 ]; then
  echo "Usage: ./check_format.sh <clang-format-executable> <config-string>" >&2
  exit 1
fi

files=`find . -path ./cmake -prune -o -iregex '.*\.\(h\|c\|hh\|cc\|hpp\|cpp\|hxx\|cxx\)$' -print`
$1 -style="$2" -i $files

exit $?
