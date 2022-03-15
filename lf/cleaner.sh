#!/bin/sh

file="$1"
mime_type=$(file --brief --mime-type --dereference "$1")

case "$mime_type" in
	image/* | video/*)
		kitty +kitten icat \
			--silent \
			--stdin 'no' \
			--transfer-mode 'file' \
			--clear
		;;
esac
