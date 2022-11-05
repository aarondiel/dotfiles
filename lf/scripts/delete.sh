#!/bin/sh

set -Cef

IFS=$(echo -e '\n+')
IFS=${IFS%?}

files="$1"

generate_prompt_text() {
	num_files="$(echo "$files" | wc --lines)"
	[ "$num_files" = "1" ] &&
		echo "do you want to delete this file?" ||
		echo "do you want to delete ${num_files} files?"
}

delete_files() {
	for file in $files
	do
		rm -rf "$file"
	done
}

prompt=$(generate_prompt_text)

gum confirm "$prompt" && delete_files
