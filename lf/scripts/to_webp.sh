#!/bin/sh

set -Cef

files="$1"
new_files=""
delete_all="false"

delete_file() {
	file="$1"

	[ "$delete_all" = "true" ] &&
		rm -rf "$file" &&
		return 0

	echo "\"${file}\" already exists, delete it?"
	response=$(gum choose "yes" "skip" "delete all" "exit")

	case "$response" in
		"yes") rm -rf "$file";;

		"skip") return 1;;

		"delete all")
			delete_all="true"
			rm -rf "$file"
			;;

		"exit") return 2;;
	esac

	return 0
}

append_to_new_files() {
	file1="$1"
	file2="$2"

	[ -z "$new_files" ] &&
		new_files=$(echo -e "${file1}\n${file2}") ||
		new_files=$(echo -e "${new_files}\n${file1}\n${file2}")
}

read_new_files() {
	for file in $files
	do
		new_file="${file%.*}.webp"

		[ -f "$file" ] || continue

		[ -f "$new_file" ] || {
			append_to_new_files "$file" "$new_file"
			continue
		}

		delete_file "$new_file"
		case $? in
			0) append_to_new_files "$file" "$new_file";;
			2) return 1;;
		esac
	done
}

confirm_conversion() {
	set -- $new_files

	while [ -n "$1" ]
	do
		file1="$1"
		file2="$2"
		shift 2

		echo "${file1} -> ${file2}"
	done

	gum confirm "convert these files?"
}

convert_new_files() {
	set -- $new_files

	while [ -n "$1" ]
	do
		file1="$1"
		file2="$2"
		shift 2

		cwebp -q 100 "$file" -o "${file%.*}.webp" &&
			rm "$file1"
	done
}

read_new_files && confirm_conversion && convert_new_files || :
