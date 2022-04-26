#!/bin/sh

set -C -f

file=$(readlink -f "$1")
width="$2"
height="$3"
panel_x="$4"
panel_y="$5"
mime_type=$(file --brief --mime-type --dereference "$1")

display_image() {
	target_file="${1:-${file}}"

	kitty +kitten icat \
		--silent \
		--stdin 'no' \
		--transfer-mode 'file' \
		--align 'center' \
		--place "${width}x${height}@${panel_x}x${panel_y}" \
		"$target_file"
}

case "$mime_type" in
	image/*)
		display_image "$file"
		;;

	text/* | */xml)
		bat \
			--tabs 2 \
			--terminal-width "$width" \
			-f "$file"
		;;

	video/*)
		thumbnail_folder="${XDG_CACHE_HOME:-$HOME/.cache}/lf/thumbnails"

		thumbnail_file=$(stat --printf '%i-%w-%n' "$file")
		thumbnail_file=$(basename "$thumbnail_file")
		thumbnail_file="${thumbnail_file%.*}"
		thumbnail_file="${thumbnail_folder}/${thumbnail_file}"

		mkdir --parents "$thumbnail_folder"

		[ ! -f "$cache_file" ] &&
			ffmpegthumbnailer \
				-i "$file" \
				-s 0 \
				-o "$thumbnail_file"
	
		display_image "$thumbnail_file"
		;;

	audio/* | application/octet-stream)
		mediainfo "$file"
		;;

	application/zip)
		unzip -Z1 "$file"
		;;

	application/x-rar)
		unrar lb "$file"
		;;
esac

exit 1
