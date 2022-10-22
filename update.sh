#!/bin/sh

set -e

get_current_directory() {
	current_file="${PWD}/${0}"
	CWD="${current_file%/*}"
	echo "$CWD"
}

CWD="$(get_current_directory)"
PATH="${CWD}/scripts:${PATH}"
CONFIGS="nvim,zsh,keyboard_layout,lf"

get_filename() {
	echo "${1##*/}"
}

print_help() {
	glow "${CWD}/assets/helpmessage.md"
}

print_configs() {
	glow "${CWD}/assets/configs.md"
}

link_config() {
	from="$1"
	to="$2"

	[ -e "$from" ] || {
		echo "no config specified"
		return 1
	}

	[ -e "$to" ] && {
		echo "${to} already exists"
		return 1
	}

	ln -s "$from" "$to"
	echo " ${from} → ${to}"
}

make_backup() {
	target="$1"
	backupdir="${CWD}/.backup"

	[ -e "$target" ] || {
		echo " ${target} does not exist"
		return 0
	}

	[ -d "$backupdir" ] || mkdir "$backupdir"

	target_filename=$(get_filename "$1")
	backup_file="${backupdir}/${target_filename}" 
	[ -e "$backup_file" ] &&
		gum confirm "delete previous backup for ${target_filename}?" &&
		rm -r "$backup_file"

	mv "$target" "$backup_file"
	echo " moved \"${target}\" to \"${backup_file}\""
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

case "$CONFIGS" in
	*keyboard_layout*)
		[ -w "/usr/share/X11/xkb/symbols" ] || {
			echo " no permission to write to \"/usr/share/X11/xkb/symbols\""
			echo " please run as root to install \"keyboard_layout\""
			exit 1
		}
		;;
esac

for config in $CONFIGS
do
	case "$config" in
		nvim)
			from="${CWD}/nvim"
			to="${HOME}/.config/nvim"

			make_backup "$to" && link_config "$from" "$to"
			;;

		zsh)
			from="${CWD}/.zshrc"
			to="${HOME}/.zshrc"

			make_backup "$to" && link_config "$from" "$to"
			;;

		keyboard_layout)
			from="${CWD}/keyboard_layout"
			to="/usr/share/X11/xkb/symbols/faber"

			make_backup "$to" && link_config "$from" "$to"
			;;

		lf)
			from="${CWD}/lf"
			to="${HOME}/.config/lf"

			make_backup "$to" && link_config "$from" "$to"
			;;

		*)
			echo "unrecognized config: ${config}"
			;;
	esac
done
