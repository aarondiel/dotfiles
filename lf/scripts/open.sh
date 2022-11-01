#!/bin/sh

set -Cef

files="$1"
num_files="$(echo "$files" | wc --lines)"

delete_file() {
	file="$1"

	gum confirm "\"$file\" already exists, delete it?" &&
		rm -rf "$file" ||
		return 1

	return 0
}

unzip_file() {
	file="$1"
	archive_dir="${file%\.zip}"

	[ -e "$archive_dir" ] &&
		delete_file "$archive_dir"

	mkdir "$archive_dir" &&
		unzip "$file" -d "$archive_dir"
}

get_mime_index() {
	mime_type="$1"

	case "$mime_type" in
		text/* | inode/x-empty) echo "text";;
		image/*) echo "image";;
		application/pdf) echo "pdf";;
		image/x-xcf) echo "gimp";;
		application/zip) echo "zip";;
	esac
}

single_file() {
	file=$(readlink -f "$files")
	mime_type=$(file --brief --mime-type "$file")

	case $(get_mime_index "$mime_type") in
		text) $EDITOR "$file";;
		image) setsid -f feh "$file" > /dev/null;;
		pdf) setsid -f evince "$file" > /dev/null;;
		gimp) setsid -f gimp "$file" > /dev/null;;
		zip) unzip_file "$file";;
	esac
}

multiple_files() {
	set -- $files

	first_mime_index=""
	dereferenced_files=""

	while [ -n "$1" ]
	do
		file=$(readlink -f "$1")
		mime_type=$(file --brief --mime-type --dereference "$file")
		mime_index=$(get_mime_index "$mime_type")
		shift 1

		[ -z "$first_mime_index" ] &&
			first_mime_index="$mime_index" &&
			continue

		[ "$mime_index" != "$first_mime_index" ] &&
			return 0

		[ -z "$dereferenced_files" ] &&
			dereferenced_files=$(echo -e "${file}\n") ||
			dereferenced_files=$(echo -e "${dereferenced_files}\n${file}\n")
	done

	case "$first_mime_index" in
		image) setsid -f feh "$dereferenced_files" > /dev/null;;
	esac
}

[ "$num_files" = "1" ] &&
	single_file ||
	multiple_files
