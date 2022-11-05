#!/bin/sh

set -Cef

IFS=$(printf '\n+')
IFS=${IFS%+}

files="$1"

is_same_directory() {
	first_directory=""

	for file in $1
	do
		directory=${file%/*}

		[ -z "$first_directory" ] &&
			first_directory="$directory"

		[ "$first_directory" != "$directory" ] &&
			return 1
	done

	echo "$first_directory"

	return 0
}

error() {
	gum format \
		--type "template" \
		"{{ Bold (Color \"1\" \"0\" \"$1\n\") }}"

	return 1
}

make_temp_file() {
	directory="$1"
	tempfile=$(mktemp)

	for file in $files
	do 
		echo "${file#${1}/}" >> "$tempfile"
	done

	$EDITOR "$tempfile"

	echo "$tempfile"
}

test_num_files() {
	num_files=$(lines.sh "$1")
	new_num_files=$(uniq "$2" | lines.sh)

	[ "$num_files" = "$new_num_files" ] ||
		error "mismatched number of files"
}

move_to_tempdir() {
	files="$1"
	tempfile="$2"
	directory="$2"

	tempdir=$(hash_file.sh "$1")
	tempdir="${directory}/${tempdir}"

	[ -e "${tempdir}" ] &&
		error "tempdir already exists"

	mkdir -p "${tempdir}"

	set -- $files

	while read -r to
	do
		from="$1"
		shift 1

		mv "$from" "${tempdir}/${to}"
	done < "$tempfile"
}

move_files_back() {
	files="$1"
	tempdir="$2"

	set -- $files

	ls -A "$tempdir" | while read -r from
	do
		to="$1"
		shift 1

		mv "${tempdir}/${from}" "${to}"
	done
}

delete_file() {
	[ "$2" = "true" ] &&
		rm -rf "$1" &&
		return 0

	echo "\"${1}\" already exists, delete it?"
	response=$(gum choose "yes" "delete all" "exit")
}

test_unique_names() {
	directory="$1"
	tempdir="$2"
	delete_all="false"

	for file in $(ls -A "$tempdir")
	do
		to="${directory}/${file}"

		[ -e "$to" ] && {
			set +e
			delete_file "$to" "$delete_all"
			response="$?"
			set -e

			case response in
				0) continue;;
				1) delete_all="true";;
				2) move_files_back && return 1;;
			esac
		}
	done
}

main() {
	directory="$1"
	tempfile=$(make_temp_file "$1")

	test_num_files "$files" "$tempfile"
	tempdir=$(move_to_tempdir "$files" "$tempfile" "$directory")
	test_unique_names "$directory" "$tempdir"

	tempdir=$(hash_file.sh "$1")
	tempdir="${1}/${tempdir}"

	[ -e "${tempdir}" ] &&
		error "tempdir already exists"

	mkdir -p "${tempdir}"

	set -- $files

	while read -r to
	do
		from="$1"
		shift 1

		mv "$from" "${tempdir}/${to}"
	done < "$tempfile"

	for file in $(ls -A "$tempdir")
	do
		from="${tempdir}/${file}"
		to="${1}/${file}"

		mv "$from" "$to"
	done

	rmdir "$tempdir"
	rm "$tempfile"
}

directory=$(is_same_directory "$files") &&
	main "$directory" ||
	error "this command only supports files in the same directory"

# files="$1"
# tempfile=$(mktemp)
# delete_all="false"
#
# remove_pwd() {
# 	for file in $files
# 	do
# 		case "$file" in
# 			$PWD*) continue;;
# 			*) echo "$files" && return 0;;
# 		esac
# 	done
#
# 	for file in $files
# 	do
# 		echo "${file##$PWD/}"
# 	done
#
# 	return 0
# }
#
# print_unequal_number_of_lines() {
# 	gum format \
# 		--type "template" \
# 		'{{ Bold (Color "1" "0" "unequal number of lines\n") }}'
# }
#
# check_num_files() {
# 	num_files1=$(echo "$files" | wc --lines)
# 	num_files2=$(wc --lines < "$tempfile")
#
# 	[ "$num_files1" != "$num_files2" ] &&
# 		print_unequal_number_of_lines &&
# 		return 1
#
# 	return 0
# }
#
# delete_file() {
# 	file="$1"
#
# 	[ "$delete_all" = "true" ] &&
# 		rm -rf "$file" &&
# 		return 0
#
# 	echo "\"${file}\" already exists, overwrite it?"
# 	response=$(gum choose "yes" "skip" "overwrite all" "exit")
#
# 	case "$response" in
# 		"yes")
# 			rm -rf "$file";;
#
# 		"skip") return 1;;
#
# 		"overwrite all")
# 			delete_all="true"
# 			rm -rf "$file"
# 			;;
#
# 		"exit") return 2;;
# 	esac
#
# 	return 0
# }
#
# rename_files() {
# 	output=""
#
# 	set -- $files
#
# 	while read -r to
# 	do
# 		from="$1"
# 		shift 1
#
# 		[ "$from" = "$to" ] &&
# 			continue
#
# 		[ -e "$to" ] || {
# 			mv "$from" "$to"
# 			continue
# 		}
#
# 		delete_file "$to"
# 		case $? in
# 			0) mv "$from" "$to";;
# 			2) return 1;;
# 		esac
# 	done < "$tempfile"
# }
#
# files=$(remove_pwd)
#
# echo "$files" >> "$tempfile"
# $EDITOR "$tempfile"
#
# check_num_files &&
# 	rename_files ||
# 	:
#
# rm "$tempfile"
