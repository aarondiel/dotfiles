#!/bin/sh

set -Cef

IFS=$(printf '\n+')
IFS=${IFS%+}

file=$(readlink -f "$1")
width="$2"
height="$3"
panel_x="$4"
panel_y="$5"
mime_type=$(file --brief --mime-type --dereference "$file")

cache_file() {
	thumbnail_folder="/tmp/.cache/lf/thumbnails"
	mkdir --parents "$thumbnail_folder"

	thumbnail_hash=$(~/.config/lf/scripts/hash_file.sh "$1")
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
		--transfer-mode 'memory' \
		--align 'center' \
		--place "${width}x${height}@${panel_x}x${panel_y}" \
		"$1" < /dev/null > /dev/tty

	exit 1
}

pdf() {
	cached_preview=$(cache_file "$1")

	[ -f "${cached_preview}.webp" ] || {
		pdftoppm -jpeg -f 1 -singlefile "$1" "$cached_preview" &&
			cwebp -q 100 "${cached_preview}.jpg" -o "${cached_preview}.webp" &&
			rm "${cached_preview}.jpg"
	}

	image "${cached_preview}.webp"
}

video() {
	cached_preview=$(cache_file "$1")

	[ -f "${cached_preview}.webp" ] ||
		ffmpegthumbnailer \
			-i "$1" \
			-s 0 \
			-o "${cached_preview}.webp"

	image "${cached_preview}.webp"
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
