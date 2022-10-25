files="$1"
num_files="$(echo "$files" | wc --lines)"

single_file() {
	mime_type=$(file --brief --mime-type --dereference "$files")

	case "$mime_type" in
		text/* | inode/x-empty)
			$EDITOR "$files"
			;;

		image/*)
			feh "$files"
			;;
	esac
}

multiple_files() {
}

[ "$num_files" = "1" ] &&
	single_file ||
	multiple_files
