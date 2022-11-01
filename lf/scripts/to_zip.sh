#!/bin/sh

set -Cef

IFS=$(echo -e '\n+')
IFS=${IFS%?}

files="$1"
num_files=$(echo "$files" | wc --lines)

delete_file() {
	file="$1"

	gum confirm "\"$file\" already exists, delete it?" &&
		rm -rf "$file" ||
		return 1

	return 0
}

get_archive_name() {
	zip_archive=$(gum input --placeholder="name of the zip archive (without .zip)")
	[ -e "${zip_archive}.zip" ] &&
		delete_file "$zip_archive"

	echo "$zip_archive"
}

zip_files() {
	zip_archive=$(get_archive_name)

	echo "$files" | zip "$zip_archive" -rj@ "$files"
	for file in $files
	do
		rm -rf "$file"
	done
}

zip_files
