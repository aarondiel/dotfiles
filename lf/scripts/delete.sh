set -Cef

files="$1"

generate_prompt_text() {
	num_files="$(echo "$files" | wc --lines)"
	[ "$num_files" = "1" ] &&
		echo "do you want to delete this file?" >&1 ||
		echo "do you want to delete ${num_files} files?" >&1
}

prompt=$(generate_prompt_text)

gum confirm "$prompt" &&
	rm -rf $files
