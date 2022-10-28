set -Cef

files="$1"
num_files="$(echo "$files" | wc --lines)"

get_mime_index() {
	mime_type="$1"

	case "$mime_type" in
		text/* | inode/x-empty) echo "text";;
		image/*) echo "image";;
		application/pdf) echo "pdf";;
		image/x-xcf) echo "gimp";;
	esac
}

single_file() {
	file=$(readlink -f "$1")
	mime_type=$(file --brief --mime-type --dereference "$file")

	case $(get_mime_index "$mime_type") in
		text) $EDITOR "$file";;
		image) setsid -f feh "$file" > /dev/null;;
		pdf) setsid -f evince "$file" > /dev/null;;
		gimp) setsid -f gimp "$file" > /dev/null;;
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
