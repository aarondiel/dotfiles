#!/bin/sh

difference() {
	echo "----vimrc----" && \
	diff --color=always -r "${1}/.config/nvim" "${2}/.config/nvim"
	echo "----zshrc----" && \
	diff --color=always "${1}/.zshrc" "${2}/.zshrc"
	echo "----Xresources----" && \
	diff --color=always "${1}/.Xresources" "${2}/.Xresources"
	echo "----kitty----" && \
	diff --color=always "${1}/.config/kitty" "${2}/.config/kitty"
	echo "----awesome----" && \
	diff --color=always -r "${1}/.config/awesome" "${2}/.config/awesome"
}

case $1 in
	diff)
		# display changes between local dotfiles and those from the repository
		difference "." "$HOME"
		# | less -r
		;;

	local)
		# update local dotfiles
		difference "$HOME" "."
		printf "do you want to update your local dotfiles [Y/n]? " 
		read -r response
		case "$response" in
			[yY][eE][sS]|[yY]|*)
				cp -T .config/nvim/* ~/.config/nvim/
				cp .zshrc ~/.zshrc
				cp .Xresources ~/.Xresources
				cp -T .config/kitty/* ~/.config/kitty/
				cp -T .config/awesome/* ~/.config/awesome/
				cp ./aaron /usr/share/X11/xkb/symbol/aaron
				;;
		esac
		;;

	repository)
		# update the dotfiles in the repository
		difference "." "$HOME"
		printf "do you want to update your local dotfiles [Y/n]? " 
		read -r response
		case "$response" in
			[yY][eE][sS]|[yY]|*)
				cp -T ~/.config/nvim .config/nvim
				cp ~/.zshrc .zshrc
				cp ~/.Xresources .Xresources
				cp -T ~/.config/kitty ./.config/kitty
				cp -T ~/.config/awesome ./.config/awesome
				cp /usr/share/X11/xkb/symbol/aaron ./aaron
				;;
		esac
		;;

	*)
		echo ----usage----
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
