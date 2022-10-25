#!/bin/sh

set -Cf

file=$(readlink -f "$1")
width="$2"
height="$3"
panel_x="$4"
panel_y="$5"
mime_type=$(file --brief --mime-type --dereference "$1")

case "$mime_type" in
	text/* | inode/x-empty)
		bat \
			--tabs 2 \
			--wrap "never" \
			--terminal-width "$width" \
			-f "$file"
		;;

	image/*)
		kitty +kitten icat \
			--scale-up \
			--silent \
			--stdin 'no' \
			--transfer-mode 'file' \
			--align 'center' \
			--place "${width}x${height}@${panel_x}x${panel_y}" \
			"$file"
		;;

	*)
		echo "$mime_type"
		;;
esac
