#!/bin/sh

set -Cef

file=$(readlink -f "$1")
mime_type=$(file --brief --mime-type --dereference "$file")

case "$mime_type" in
	image/* | \
	application/pdf)
		kitty +kitten icat \
			--silent \
			--stdin 'no' \
			--transfer-mode 'file' \
			--clear
	;;
esac
