#!/bin/sh

set -Cef

IFS=$(echo -e '\n+')
IFS=${IFS%?}

file=$(readlink -f "$1")
width="$2"
height="$3"
panel_x="$4"
panel_y="$5"
mime_type=$(file --brief --mime-type --dereference "$file")

cache_file() {
	thumbnail_folder="/tmp/.cache/lf/thumbnails"
	mkdir --parents "$thumbnail_folder"

	thumbnail_hash=$(hash_file.sh "$1")
	echo "${thumbnail_folder}/${thumbnail_hash}"
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

video() {
	cache_file=$(cache_file "$1")

	[ -f "${cache_file}.webp" ] ||
		ffmpegthumbnailer \
			-i "$1" \
			-s 0 \
			-o "${cache_file}.webp"

	image "${cache_file}.webp"
}

case "$mime_type" in
	text/* | \
	application/json | \
	inode/x-empty) text "$file";;

	image/*) image "$file";;

	audio/* | \
	application/octet-stream) mediainfo "$file";;
	application/java-archive) jar tf "$file";;

	application/pdf) pdf "$file";;
	application/zip) zipinfo -1 "$file";;

	video/*) video "$file";;

	*) echo "$mime_type";;
esac
