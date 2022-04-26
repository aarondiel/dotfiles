#!/bin/sh

set -e

[ -d '.backup' ] || mkdir '.backup'
CWD=$(dirname "$PWD/$0")
PACKAGES_CASH=''

print_headline() {
	columns=$(tput cols)
	text_length=${#1}
	spaces=$(((columns - text_length) / 2 - 1))

	i=0
	while [ $i -lt $spaces ]
	do
		printf '#'
		i=$((i+1))
	done

	printf " %s " "$1"

	i=0
	while [ $i -lt $spaces ]
	do
		printf '#'
		i=$((i+1))
	done

	printf '\n'
}

print_help() {
	print_headline 'usage'
	printf -- 'update.sh [local | repository | diff] [OPTIONS]\n'
	printf -- '\n'
	printf -- 'diff:\n'
	printf -- "	display changes between local dotfiles and those from the repository\n"
	printf -- '\n'
	printf -- 'local:\n'
	printf -- '	update local dotfiles\n'
	printf -- '\n'
	printf -- 'repository:\n'
	printf -- '	update the dotfiles inside the repository to the ones present on the local machine\n'
	printf -- '\n'

	print_headline 'arguments'
	printf -- '--only config_names\n'
	printf -- '	config_names is a comma-sperated string, listing the dotfiles that will be targeted\n'
	printf -- '	by default config_names contains all available options:\n'
	printf -- '	vimrc,zshrc,keyboard_layout,awesome,lf\n'
}

print_headline_and_difference() {
	[ -e "$2" ] || (printf "file does not exist: %s\n" "$2" && return 0)
	[ -e "$3" ] || (printf "file does not exist: %s\n" "$3" && return 0)

	difference=$(diff \
		--color=always \
		--expand-tabs \
		--tabsize=2 \
		--recursive \
		"$2" "$3" || :
	)

	[ -z "$difference" ] && return 0

	print_headline "$1"
	printf "%s\n" "$difference"
}

get_permission() {
	printf "%s" "$1"

	read -r response
	[ -z "$response" ] && return 0

	case "$response" in
		[yY][eE][sS]|[yY])
			return 0
			;;

		*)
			return 1
			;;
	esac
}

pacman_install() {
	pacman -T "$1" || sudo pacman -S "$1"
	return 0
}

is_true() {
	[ "$1" = 'false' ] && return 1
	[ -z "$1" ] && return 1

	[ "$1" = 'true' ] && return 0
	exit 1
}

create_backup() {
	origin_path="$1"
	destination_name=$(basename "${2:-${1}}")

	[ -e "$origin_path" ] || return 0
	[ -e "$CWD/.backup/$destination_name" ] && rm -r "$CWD/.backup/$destination_name"

	mv "$origin_path" "$CWD/.backup/$destination_name"
}

update_awesome() {
	case "$1" in
		local)
			print_headline_and_difference 'awesomewm' "$CWD/awesome" "$HOME/.config/awesome" || return 0

			is_true "$2" ||
				get_permission 'do you want to update your awesomewm config [Y/n]? ' ||
				return 0

			pacman_install 'awesome'
			pacman_install 'rofi'
			pacman_install 'kitty'
			pacman_install 'light'

			create_backup "$HOME/.config/awesome"
			cp -r "$CWD/awesome" "$HOME/.config/awesome"
			;;

		repository)
			print_headline_and_difference 'awesomewm' "$HOME/.config/awesome" "$CWD/awesome"  || return 0

			is_true "$2" ||
				get_permission 'do you want to update the awesomewm config inside the repository [Y/n]? ' ||
				return 0

			rm -r "$CWD/awesome"
			cp -r "$HOME/.config/awesome" "$CWD/awesome"
			;;
	esac
}

update_keyboard_layout() {
	case "$1" in
		local)
			print_headline_and_difference 'keyboard layout' "$CWD/keyboard_layout" '/usr/share/X11/xkb/symbols/faber' || return 0

			is_true "$2" ||
				get_permission 'do you want to update your keyboard layout [Y/n]? ' ||
				return 0

			initial_install='false'

			[ -f '/usr/share/X11/xkb/symbols/faber' ] || initial_install='true'
			sudo create_backup '/usr/share/X11/xkb/symbols/faber' 'keyboard_layout'

			sudo cp "$CWD/keyboard_layout" "/usr/share/X11/xkb/symbols/faber"
			is_true "$initial_install" && localectl set-x11-keymap faber
			setxkbmap faber
			;;

		repository)
			print_headline_and_difference 'keyboard layout' '/usr/share/X11/xkb/symbols/faber' "$CWD/keyboard_layout" || return 1

			is_true "$2" ||
				get_permission 'do you want to update the keyboard layout inside the repository [Y/n]? ' ||
				return 0

			sudo rm "$CWD/keyboard_layout"
			sudo cp '/usr/share/X11/xkb/symbols/faber' "$CWD/keyboard_layout"
			;;
	esac
}

update_zshrc() {
	case "$1" in
		local)
			print_headline_and_difference 'zshrc' "$CWD/.zshrc" "$HOME/.zshrc" || return 0

			is_true "$2" ||
				get_permission 'do you want to update your zshrc [Y/n]? ' ||
				return 0

			pacman_install 'zsh'
			pacman_install 'zsh-autosuggestions'
			pacman_install 'zsh-syntax-highlighting'

			create_backup "$HOME/.zshrc"
			cp "$CWD/.zshrc" "$HOME/.zshrc"
			;;

		repository)
			print_headline_and_difference 'zshrc' "$HOME/.zshrc" "$CWD/.zshrc" || return 0

			is_true "$2" ||
				get_permission 'do you want to update the zshrc inside the repository [Y/n]? ' ||
				return 0

			rm "$CWD/.zshrc"
			cp "$HOME/.zshrc" "$CWD/.zshrc"
			;;
	esac
}

update_vimrc() {
	case "$1" in
		local)
			print_headline_and_difference 'vimrc' "$CWD/nvim" "$HOME/.config/nvim" || return 0

			is_true "$2" ||
				get_permission 'do you want to update your vimrc [Y/n]? ' ||
				return 0

			pacman_install 'neovim'
			pacman_install 'unzip'
			pacman_install 'wget'
			pacman_install 'git'
			pacman_install 'python-pip'
			pacman_install 'npm'
			pacman_install 'xclip'

			create_backup "$HOME/.config/nvim"
			cp -r "$CWD/nvim" "$HOME/.config/nvim"
			;;

		repository)
			print_headline_and_difference 'vimrc' "$HOME/.config/nvim" "$CWD/nvim" || return 0

			is_true "$2" ||
				get_permission 'do you want to update the vimrc inside the repository [Y/n]? ' ||
				return 0

			rm -r "$CWD/nvim"
			cp -r "$HOME/.config/nvim" "$CWD/nvim"
			;;
	esac
}

update_lf() {
	case "$1" in
		local)
			print_headline_and_difference 'lf' "$CWD/lf" "$HOME/.config/lf" || return 0

			is_true "$2" ||
				get_permission 'do you want to update your lfrc [Y/n]? ' ||
				return 0

			pacman_install 'moreutils'
			pacman_install 'ffmpegthumbnailer'
			pacman_install 'kitty'

			create_backup "$HOME/.config/lf"
			cp -r "$CWD/lf" "$HOME/.config/lf"
			;;

		repository)
			print_headline_and_difference 'lf' "$HOME/.config/lf" "$CWD/lf" || return 0

			is_true "$2" ||
				get_permission 'do you want to update the lfrc inside the repository [Y/n]? ' ||
				return 0

			rm -r "$CWD/lf"
			cp -r "$HOME/.config/lf" "$CWD/lf"
			;;
	esac
}

arguments=$(getopt -s 'sh' --options 'h' --longoptions 'help,only:' -- "$@")
configs=$(split.sh 'vimrc,zshrc,keyboard_layout,awesome,lf' ',')
target=''

# shellcheck disable=2086
set -- $arguments

while [ -n "$1" ]
do
	case "$1" in
		--only)
			shift 1
			configs="$(trim_quotes.sh "$1" | split.sh ',')"
			;;

		-h|--help)
			print_help
			exit 0
			;;

		--)
			shift 1
			break
			;;

		*)
			printf 'unrecognized argument: %s\n' "$1"
			;;
	esac

	shift 1
done

case $(trim_quotes.sh "$1") in
	diff)
		print_headline_and_difference 'vimrc' "$CWD/nvim" "$HOME/.config/nvim"
		print_headline_and_difference 'zshrc' "$CWD/.zshrc" "$HOME/.zshrc"
		print_headline_and_difference 'keyboard layout' "$CWD/keyboard_layout" '/usr/share/X11/xkb/symbols/faber'
		print_headline_and_difference 'awesomewm' "$CWD/awesome" "$HOME/.config/awesome"
		print_headline_and_difference 'lf' "$CWD/lf" "$HOME/.config/lf"

		exit 0
		;;

	local|repository)
		target=$(trim_quotes.sh "$1")
		;;

	*)
		print_help

		exit 0
		;;
esac

for config in $configs
do
	case "$config" in
		vimrc)
			update_vimrc "$target"
			;;

		zshrc)
			update_zshrc "$target"
			;;

		keyboard_layout)
			update_keyboard_layout "$target"
			;;
		
		awesome)
			update_awesome "$target"
			;;
		
		lf)
			update_lf "$target"
			;;

		*)
			printf 'unrecogized config: %s\n' "$config"
			;;
	esac
done
