#!/bin/sh

set -e

PATH="/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:$PWD/scripts"
configs='vimrc,zshrc,keyboard_layout,lf'

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
		esac

		shift 1
	done

	configs=$(echo "$configs" | split.sh ",")
}

parse_arguments "$@"
