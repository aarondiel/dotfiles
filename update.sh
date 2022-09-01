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

link_config() {
	from="$1"
	to="$2"

	[ -d "$from" ] || echo "no config dir specified" && return 1
	[ -e "$to" ] || echo "${to} already exists" && return 1

	ln -s "$from" "$to"
	echo " ${from} → ${to}"
}

make_backup() {
	target="$1"
	backupdir="${CWD}/.backup"

	[ -e "$target" ] || echo "$target does not exist" && return 1
	[ -d "$backupdir" ] || mkdir "$backupdir"

	mv "$target" "$backupdir"
	echo " moved \"${target}\" to \"${backupdir}/${target}\""
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
			from="${CWD}/nvim"
			to="${HOME}/.config/nvim"

			make_backup "$from" && link_nvim_config "$from" "$to"
			;;

		*)
			echo "unrecognized config: ${config}"
			;;
	esac
done
