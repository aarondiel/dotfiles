#!/bin/sh

set -e

files="$1"

file_list=$(mktemp "/tmp/lf-bulk-rename-files.XXXXXXXXXX")
file_names=$(mktemp "/tmp/lf-bulk-rename-file-names.XXXXXXXXXX")
file_names_before=$(mktemp "/tmp/lf-bulk-rename-file-names-before.XXXXXXXXXX")
changes=$(mktemp "/tmp/lf-bulk-rename-changes.XXXXXXXXXX")

remove_tmp_files() {
	rm "$file_list"
	rm "$file_names"
	rm "$file_names_before"
	rm "$changes"
}

[ -z "$EDITOR" ] && {
	printf "no \$EDITOR defined."
	remove_tmp_files
	exit 1
}

echo "$files" | while read -r file
do
	[ -e "$file" ] || {
		printf "file %s does not exist\n" "$file"
		remove_tmp_files
		exit 1
	}

	echo "$file" >> "$file_list"
	basename "$file" >> "$file_names"
done


cat "$file_names" > "$file_names_before"
$EDITOR "$file_names"
file_names_difference=$(diff -q "$file_names_before" "$file_names" || :)

[ -z "$file_names_difference" ] && {
	printf "no renaming detected, exiting..."
	remove_tmp_files
	exit 0
}

num_file_names=$(wc -l < "$file_names")
num_files=$(wc -l < "$file_list")

[ "$num_files" -ne "$num_file_names" ] && {
	printf "number of renamed files does not match number of original files\n"
	remove_tmp_files
	exit 1
}

line_number=0
while [ "$line_number" -lt "$num_files" ]
do
	line_number=$((line_number + 1))

	original_file=$(sed "${line_number}q;d" "$file_list")
	original_file_directory=$(dirname "$original_file")

	new_file_name=$(sed "${line_number}q;d" "$file_names")
	new_file="${original_file_directory}/${new_file_name}"

	echo "mv \"${original_file}\" \"${new_file}\"" >> "$changes"
done

while read -r change
do
	sh -c "$change"
done < "$changes"

remove_tmp_files
exit 0
