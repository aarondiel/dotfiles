#!/bin/sh

set -Cef

file=$(readlink -f "$1")
width="$2"
height="$3"
panel_x="$4"
panel_y="$5"
mime_type=$(file --brief --mime-type --dereference "$file")

cache_file() {
	thumbnail_folder="/tmp/.cache/lf/thumbnails"
	mkdir --parents "$thumbnail_folder"

	thumbnail_file=$(stat --printf '%i-%w-%n' "$1")
	thumbnail_file=$(basename "$thumbnail_file")
	thumbnail_file="${thumbnail_file%.*}"
	thumbnail_file="${thumbnail_folder}/${thumbnail_file}"

	echo "$thumbnail_file"
}

text() {
	bat \
		--tabs 2 \
		--wrap 'never' \
		--terminal-width "$width" \
		-f "$1"
}

image() {
	kitty +kitten icat \
		--silent \
		--stdin 'no' \
		--transfer-mode 'file' \
		--align 'center' \
		--place "${width}x${height}@${panel_x}x${panel_y}" \
		"$1"

	exit 1
}

pdf() {
	cache_file=$(cache_file "$1")

	[ -f "${cache_file}.webp" ] || {
		pdftoppm -jpeg -f 1 -singlefile "$1" "$cache_file" &&
			cwebp -q 100 "${cache_file}.jpg" -o "${cache_file}.webp" &&
			rm "${cache_file}.jpg"
	}

	image "${cache_file}.webp"
}

case "$mime_type" in
	text/* | \
	application/json | \
	inode/x-empty) text "$file";;

	image/*) image "$file";;

	audio/* | \
	application/octet-stream) mediainfo "$file";;

	application/pdf) pdf "$file";;

	*) echo "$mime_type";;
esac
