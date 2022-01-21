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

update_zshrc() {
	case "$1" in
		local)
			difference=$(diff --color=always --tabsize=2 -trNd "$CWD/.zshrc" "$HOME/.zshrc")
			[ -z "$difference" ] && return 1

			print_headline 'zshrc'
			echo "$difference"
			is_true "$2" ||
				get_permission 'do you want to update your zshrc [Y/n]? ' ||
				return 1

			pacman_install 'zsh-autosuggestions'
			pacman_install 'zsh-syntax-highlighting'

			[ -e "$HOME/.zshrc" ] && mv "$HOME/.zshrc" "$CWD/.backup/.zshrc"
			cp "$CWD/.zshrc" "$HOME/.zshrc"
			;;

		repository)
			difference=$(diff --color=always --tabsize=2 -trNd "$HOME/.zshrc" "$CWD/.zshrc")
			[ -z "$difference" ] && return 1

			print_headline 'zshrc'
			echo "$difference"

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
			difference=$(diff --color=always --tabsize=2 -trNdr "$CWD/.zshrc" "$HOME/.zshrc")
			[ -z "$difference" ] && return 1

			print_headline 'vimrc'
			echo "$difference"

			is_true "$2" ||
				get_permission 'do you want to update your vimrc [Y/n]? ' ||
				return 1

			pacman_install 'unzip'
			pacman_install 'wget'
			pacman_install 'git'
			pacman_install 'python-pip'
			pacman_install 'npm'
			pacman_install 'xclip'

			[ -e "$HOME/.config/nvim" ] && mv "$HOME/.config/nvim" "$CWD/.backup/nvim"
			cp "$CWD/nvim" "$HOME/.config/nvim"
			;;

		repository)
			difference=$(diff --color=always --tabsize=2 -trNd "$HOME/.zshrc" "$CWD/.zshrc")
			[ -z "$difference" ] && return 1

			print_headline 'vimrc'
			echo "$difference"

			is_true "$2" ||
				get_permission 'do you want to update the vimrc inside the repository [Y/n]? ' ||
				return 1

			rm -r "$CWD/nvim"
			cp -r "$HOME/.config/nvim" "$CWD/nvim"
			;;
	esac
}

case $1 in
	diff)
		diff --color=always --tabsize=2 -trNd "$CWD/.zshrc" "$HOME/.zshrc"
		;;

	local)
		update_zshrc 'local'
		update_vimrc 'local'
		;;

	repository)
		update_zshrc 'repository'
		update_vimrc 'repository'
		;;

	*)
		print_headline 'usage'
		echo diff:
		echo "	display changes between local dotfiles and those from the repository"
		echo
		echo local:
		echo "	update local dotfiles"
		echo
		echo repository:
		echo "	update the dotfiles inside the repository to the ones present on the local machine"
		;;
esac
