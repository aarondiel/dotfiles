#!/bin/sh

set -Cef

IFS=$(echo -e '\n+')
IFS=${IFS%?}

file="$1"

stats=$(stat --printf '%i-%w-%n' "$file")
hash=$(echo "$stats" | sha256sum | cut -d' ' -f1)
name=$(basename "$file")

echo "${hash} - ${name}"
