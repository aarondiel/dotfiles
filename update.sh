#!/bin/sh

difference() {
	echo "----vimrc----" && \
	diff --color=always -r "${1}/.config/nvim" "${2}/.config/nvim"
	echo "----zshrc----" && \
	diff --color=always "${1}/.zshrc" "${2}/.zshrc"
	echo "----kitty----" && \
	diff --color=always "${1}/.config/kitty" "${2}/.config/kitty"
	echo "----awesome----" && \
	diff --color=always "${1}/.config/awesome" "${2}/.config/awesome"
}

case $1 in
	diff)
		# display changes between local dotfiles and those from the repository
		echo "$(difference "." "$HOME")"
		# | less -r
		break;;

	local)
		# update local dotfiles
		echo "$(difference "$HOME" ".")"
		read -rp "do you want to update your local dotfiles [Y/n]? " response
		case "$response" in
			[yY][eE][sS]|[yY]|*)
				cp -rf .config/nvim/* ~/.config/nvim/
				cp .zshrc ~/.zshrc
				cp -rf .config/kitty/* ~/.config/kitty/
				cp -rf .config/awesome/* ~/.config/awesome/
				break;;
		esac
		break;;

	repository)
		# update the dotfiles in the repository
		echo "$(difference "." "$HOME")"
		read -rp "do you want to update your local dotfiles [Y/n]? " response
		case "$response" in
			[yY][eE][sS]|[yY]|*)
				cp -rf ~/.config/nvim/* .config/nvim/
				cp ~/.zshrc .zshrc
				cp -rf ~/.config/kitty/* ./.config/kitty/
				cp -rf ~/.config/awesome/* ./.config/awesome/
				break;;
		esac
		break;;

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
		break;;
esac
