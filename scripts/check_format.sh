#!/bin/bash
if [ "$#" -lt 2 ]; then
  echo "Usage: ./check_format.sh <clang-format-executable> <config-string>" >&2
  exit 1
fi

files=`find . -path ./cmake -prune -o -iregex '.*\.\(h\|c\|hh\|cc\|hpp\|cpp\|hxx\|cxx\)$' -print`
num_changes=`$1 -style="$2" -output-replacements-xml $files | grep -c "<replacement "`

if [ "$num_changes" = "0" ]; then
  echo "Every file seems to comply with our code convention."
  exit 0
else
  echo "Found" $num_changes "necessary changes."
  exit 0
fi
