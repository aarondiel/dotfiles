#!/bin/sh

set -C -f

file="$1"
width="$2"
height="$3"
panel_x="$4"
panel_y="$5"
mime_type=$(file --brief --mime-type --dereference "$1")

case "$mime_type" in
	image/*)
		kitty +kitten icat \
			--silent \
			--stdin 'no' \
			--transfer-mode 'file' \
			--align 'center' \
			--place "${width}x${height}@${panel_x}x${panel_y}" \
			"$file"
		;;

	text/* | */xml)
		bat \
			--tabs 2 \
			--terminal-width "$width" \
			-f "$file"
		;;

	audio/* | application/octet-stream)
		mediainfo "$1"
		;;
esac

exit 1
