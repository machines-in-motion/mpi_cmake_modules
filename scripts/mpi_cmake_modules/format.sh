#!/bin/bash
if [ "$#" -lt 2 ]; then
  echo "Usage: ./format.sh <clang-format-executable> <config-string>" >&2
  exit 1
fi

files=`find . -path ./cmake -prune -o -iregex '.*\.\(h\|c\|hh\|cc\|hpp\|cpp\|hxx\|cxx\)$' -print`
format_out=$($1 -style="$2" -i $files 2>&1)
clang_return_code=$?
echo ${format_out}

if [[ ${clang_return_code} -ne 0 ]]
then
    echo "Error while formatting."
    exit ${clang_return_code}
elif [ "${format_out}" = "" ]; then
    echo "Formatting succeeded."
    exit 0
else
    echo "Error while formatting."
    exit 1
fi
