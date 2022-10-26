set -Cef

files="$1"
num_files="$(echo "$files" | wc --lines)"

single_file() {
	file=$(readlink -f "$1")
	mime_type=$(file --brief --mime-type --dereference "$file")

	case "$mime_type" in
		text/* | inode/x-empty)
			$EDITOR "$file"
			;;

		image/*)
			feh "$file"
			;;
	esac
}

multiple_files() {
}

[ "$num_files" = "1" ] &&
	single_file ||
	multiple_files
