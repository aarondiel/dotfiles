#!/bin/sh

set -Cef

files="$1"
tempfile=$(mktemp)
delete_all="false"

remove_pwd() {
	for file in $files
	do
		case "$file" in
			$PWD*) continue;;
			*) echo "$files" && return 0;;
		esac
	done

	for file in $files
	do
		echo "${file##$PWD/}"
	done

	return 0
}

print_unequal_number_of_lines() {
	gum format \
		--type "template" \
		'{{ Bold (Color "1" "0" "unequal number of lines\n") }}'
}

check_num_files() {
	num_files1=$(echo "$files" | wc --lines)
	num_files2=$(wc --lines < "$tempfile")

	[ "$num_files1" != "$num_files2" ] &&
		print_unequal_number_of_lines &&
		return 1

	return 0
}

delete_file() {
	file="$1"

	[ "$delete_all" = "true" ] &&
		rm -rf "$file" &&
		return 0

	echo "\"${file}\" already exists, overwrite it?"
	response=$(gum choose "yes" "skip" "overwrite all" "exit")

	case "$response" in
		"yes")
			rm -rf "$file";;

		"skip") return 1;;

		"overwrite all")
			delete_all="true"
			rm -rf "$file"
			;;

		"exit") return 2;;
	esac

	return 0
}

rename_files() {
	output=""

	set -- $files

	while read -r to
	do
		from="$1"
		shift 1

		[ "$from" = "$to" ] &&
			continue

		[ -e "$to" ] || {
			mv "$from" "$to"
			continue
		}

		delete_file "$to"
		case $? in
			0) mv "$from" "$to";;
			2) return 1;;
		esac
	done < "$tempfile"
}

files=$(remove_pwd)

echo "$files" >> "$tempfile"
$EDITOR "$tempfile"

check_num_files &&
	rename_files ||
	:

rm "$tempfile"
