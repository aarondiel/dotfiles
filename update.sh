#!/bin/sh

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
}

print_headline_and_difference() {
	difference=$(diff --color=always --tabsize=2 -trNd "$2" "$3")
	[ -z "$difference" ] && return 1

	print_headline "$1"
	echo "$difference"
}

get_permission() {
	printf "%s" "$1"

	read -r response
	case $response in
		[yY][eE][sS]|[yY]|*)
			return 0
			;;
	esac

	return 1
}

pacman_install() {
	[ -z "$PACKAGES_CASH" ] && PACKAGES_CASH=$(sudo pacman -Q)

	echo "$PACKAGES_CASH" | grep -q "$1" || sudo pacman -S "$1"
	return 0
}

is_true() {
	[ "$1" = 'false' ] && return 1
	[ -z "$1" ] && return 1

	[ "$1" = 'true' ] && return 0
	exit 1
}

update_awesome() {
	case "$1" in
		local)
			print_headline_and_difference 'awesomewm' "$CWD/awesome" "$HOME/.config/awesome" || return 1

			is_true "$2" ||
				get_permission 'do you want to update your awesomewm config [Y/n]? ' ||
				return 1

			pacman_install 'awesome'
			pacman_install 'rofi'
			pacman_install 'kitty'
			pacman_install 'light'

			[ -e "$HOME/.config/awesome" ] && mv "$HOME/.config/awesome" "$CWD/.backup/awesome"
			cp -r "$CWD/awesome" "$HOME/.config/awesome"
			;;
		repository)
			print_headline_and_difference 'awesomewm' "$HOME/.config/awesome" "$CWD/awesome"  || return 1

			is_true "$2" ||
				get_permission 'do you want to update the awesomewm config inside the repository [Y/n]? ' ||
				return 1

			rm -r "$CWD/awesome"
			cp -r "$HOME/.config/awesome" "$CWD/awesome"
			;;
	esac
}

update_keyboard_layout() {
	case "$1" in
		local)
			print_headline_and_difference 'keyboard layout' "$CWD/keyboard_layout" '/usr/share/X11/xkb/symbols/faber' || return 1

			is_true "$2" ||
				get_permission 'do you want to update your keyboard layout [Y/n]? ' ||
				return 1

			initial_install='false'

			[ -e '/usr/share/X11/xkb/symbols/faber' ] &&
				mv '/usr/share/X11/xkb/symbols/faber' "$CWD/.backup/keyboard_layout" ||
				initial_install='true'

			sudo cp "$CWD/keyboard_layout" "/usr/share/X11/xkb/symbols/faber"
			is_true "$initial_install" && localectl set-x11-keymap faber
			setxkbmap faber
			;;

		repository)
			print_headline_and_difference 'keyboard layout' '/usr/share/X11/xkb/symbols/faber' "$CWD/keyboard_layout" || return 1

			is_true "$2" ||
				get_permission 'do you want to update the keyboard layout inside the repository [Y/n]? ' ||
				return 1

			sudo rm "$CWD/keyboard_layout"
			sudo cp '/usr/share/X11/xkb/symbols/faber' "$CWD/keyboard_layout"
			;;
	esac
}

update_zshrc() {
	case "$1" in
		local)
			print_headline_and_difference 'zshrc' "$CWD/.zshrc" "$HOME/.zshrc" || return 1

			is_true "$2" ||
				get_permission 'do you want to update your zshrc [Y/n]? ' ||
				return 1

			pacman_install 'zsh'
			pacman_install 'zsh-autosuggestions'
			pacman_install 'zsh-syntax-highlighting'

			[ -e "$HOME/.zshrc" ] && mv "$HOME/.zshrc" "$CWD/.backup/.zshrc"
			cp "$CWD/.zshrc" "$HOME/.zshrc"
			;;

		repository)
			print_headline_and_difference 'zshrc' "$HOME/.zshrc" "$CWD/.zshrc" || return 1

			is_true "$2" ||
				get_permission 'do you want to update the zshrc inside the repository [Y/n]? ' ||
				return 1

			rm "$CWD/.zshrc"
			cp "$HOME/.zshrc" "$CWD/.zshrc"
			;;
	esac
}

update_vimrc() {
	case "$1" in
		local)
			print_headline_and_difference 'vimrc' "$CWD/nvim" "$HOME/.config/nvim" || return 1

			is_true "$2" ||
				get_permission 'do you want to update your vimrc [Y/n]? ' ||
				return 1

			pacman_install 'neovim'
			pacman_install 'unzip'
			pacman_install 'wget'
			pacman_install 'git'
			pacman_install 'python-pip'
			pacman_install 'npm'
			pacman_install 'xclip'

			[ -e "$HOME/.config/nvim" ] && mv "$HOME/.config/nvim" "$CWD/.backup/nvim"
			cp -r "$CWD/nvim" "$HOME/.config/nvim"
			;;

		repository)
			print_headline_and_difference 'vimrc' "$HOME/.config/nvim" "$CWD/nvim" || return 1

			is_true "$2" ||
				get_permission 'do you want to update the vimrc inside the repository [Y/n]? ' ||
				return 1

			rm -r "$CWD/nvim"
			cp -r "$HOME/.config/nvim" "$CWD/nvim"
			;;
	esac
}

case "$1" in
	diff)
			print_headline_and_difference 'vimrc' "$CWD/nvim" "$HOME/.config/nvim"
			print_headline_and_difference 'vimrc' "$CWD/.zshrc" "$HOME/.zshrc"
			print_headline_and_difference 'keyboard layout' "$CWD/keyboard_layout" '/usr/share/X11/xkb/symbols/faber'
			print_headline_and_difference 'awesomewm' "$CWD/awesome" "$HOME/.config/awesome"
		;;

	local)
		case "$2" in
			vimrc)
				update_vimrc 'local'
				;;

			zshrc)
				update_zshrc 'local'
				;;

			keyboard_layout)
				update_keyboard_layout 'local'
				;;
			
			awesome)
				update_awesome 'local'
				;;

			*)
				update_vimrc 'local'
				update_zshrc 'local'
				update_keyboard_layout 'local'
				update_awesome 'local'
				;;
		esac
		;;

	repository)
		case "$2" in
			vimrc)
				update_vimrc 'repository'
				;;

			zshrc)
				update_zshrc 'repository'
				;;

			keyboard_layout)
				update_keyboard_layout 'repository'
				;;

			awesome)
				update_awesome 'repository'
				;;

			*)
				update_vimrc 'repository'
				update_zshrc 'repository'
				update_keyboard_layout 'repository'
				update_awesome 'repository'
				;;
		esac
		;;

	*)
		print_headline 'usage'
		echo "diff:"
		echo "	display changes between local dotfiles and those from the repository"
		echo
		echo "local [vimrc|zshrc|keyboard_layout]:"
		echo "	update local dotfiles"
		echo
		echo "repository [vimrc|zshrc|keyboard_layout]:"
		echo "	update the dotfiles inside the repository to the ones present on the local machine"
		;;
esac
