#!/bin/sh

set -e

get_current_directory() {
	current_file="${PWD}/${0}"
	CWD="${current_file%/*}"
	echo "$CWD"
}

CWD="$(get_current_directory)"
PATH="${PATH}:${CWD}/scripts"
CONFIGS="nvim"

print_help() {
	glow "${CWD}/assets/helpmessage.md"
}

print_configs() {
	glow "${CWD}/assets/configs.md"
}

link_nvim_config() {
	from="${CWD}/nvim"
	to="${HOME}/.config/nvim"

	[ -d "$from" ] || echo "no config dir specified" && return 1
	[ -n "$to" ] || echo "no target specified" && return 1
	[ -f "$to" ] || echo "${to} already exists" && return 1

	echo "$from -> $to"
}

parse_arguments() {
	options="h,o:"
	longoptions="help,configs,only:"

	arguments=$( \
		getopt \
		-s 'sh' \
		--options "$options" \
		--longoptions "$longoptions" \
		-- \
		"$@" \
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

			--configs)
				print_configs
				exit 0
				;;

			-o | --only)
				shift 1
				CONFIGS=$(trim_quotes.sh "$1")
				;;
		esac

		shift 1
	done

	CONFIGS=$(split.sh "$CONFIGS" ",")
}

parse_arguments "$@"

for config in $CONFIGS
do
	case "$config" in
		nvim)
			link_nvim_config
			;;

		*)
			echo "unrecognized config: ${config}"
			;;
	esac
done
