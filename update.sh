#!/bin/sh

set -e

PATH="/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:$PWD/scripts"
CWD=$(dirname "$PWD/$0")
diff="diff --color=always --tabsize 2 --recursive --new-file"
configs='vimrc,zshrc,keyboard_layout,lf'
action=''

print_help() {
	print_colored.sh 'italic,bold,fg_cyan' '# usage'
	echo 'update.sh [local | repository | diff] [OPTIONS]'
	echo ''
	echo 'diff:'
	echo "  display changes between local dotfiles and those from the repository"
	echo ''
	echo 'local:'
	echo '  update local dotfiles'
	echo ''
	echo 'repository:'
	echo '  update the dotfiles inside the repository to the ones present on the local machine'
	echo ''

	print_colored.sh 'italic,bold,fg_cyan' '# arguments'
	echo '--only config_names'
	echo '  config_names is a comma-sperated string, listing the dotfiles that will be targeted'
	echo '  the default value for config_names is:'
	echo '  "vimrc,zshrc,keyboard_layout,awesome,lf"'
}

parse_arguments() {
	options="h,o:"
	longoptions="help,only:"

	arguments=$(getopt \
		-s 'sh' \
		--options "$options" \
		--longoptions "$longoptions" \
		-- \
		"$@"
	)

	# shellcheck disable=2086
	set -- $arguments

	while [ -n "$1" ]
	do
		case "$1" in
			-h | --help)
				print_help
				exit 0
				;;

			-o | --only)
				shift 1
				configs=$(echo "$1" | trim_quotes.sh)
				;;

			--)
				shift 1
				break
				;;
		esac

		shift 1
	done

	action=$(echo "$1" | trim_quotes.sh)
	configs=$(echo "$configs" | split.sh ",")

	[ -n "$action" ] || echo "no action specified" || exit 1
}

print_diff() {
	config="$1"
	order="$2"

	title=''
	file1=''
	file2=''

	case "$config" in
		vimrc)
			title='vimrc'
			file1="$HOME/.config/nvim"
			file2="$CWD/nvim"
			;;

		zshrc)
			title='zshrc'
			file1="$HOME/.zhsrc"
			file2="$CWD/.zshrc"
			;;

		keyboard_layout)
			title='keyboard layout'
			file1="/usr/share/X11/xkb/symbols/faber"
			file2="$CWD/keyboard_layout"
			;;

		awesome)
			title='awesome'
			file1="$HOME/.config/awesome"
			file2="$CWD/awesome"
			;;

		lf)
			title='lf'
			file1="$HOME/.config/lf"
			file2="$CWD/lf"
			;;
	esac

	delta=''

	case "$order" in
		local)
			delta=$($diff "$file1" "$file2" || :)
			;;

		repository)
			delta=$($diff "$file2" "$file1" || :)
	esac


	[ -z "$delta" ] ||
		print_colored.sh "bold,italic,fg_yellow" "# ${title}" &&
		echo "$delta"
}

parse_arguments "$@"

case "$action" in
	diff)
		for config in $configs
		do
			print_diff "$config" "local"
		done
		;;

	local)
		;;

	repository)
		;;

	*)
		echo "unkown action: ${action}"
		exit 1
		;;
esac
