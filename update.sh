#!/bin/sh

difference() {
    echo "----vimrc----" && \
    diff --color=always "${1}/.vimrc" "${2}/.vimrc"
    echo "----zshrc----" && \
    diff --color=always "${1}/.zshrc" "${2}/.zshrc"
}

case $1 in
    diff)
        # display changes between local dotfiles and those from the repository
        echo "$(difference "." "$HOME")"
        # | less -r
        break;;

    local)
        # update local dotfiles
        echo "$(difference "." "$HOME")"
        read -rp "do you want to update your local dotfiles [Y/n]? " response
        case "$response" in
            [yY][eE][sS]|[yY])
                cp .vimrc ~/.vimrc
                cp .zshrc ~/.zshrc
                break;;
            *)
                break;;
        esac
        break;;

    repository)
        # update the dotfiles in the repository
        echo "$(difference "$HOME" ".")"
        read -rp "do you want to update your local dotfiles [Y/n]? " response
        case "$response" in
            [yY][eE][sS]|[yY])
                cp ~/.vimrc .vimrc
                cp ~/.zshrc .zshrc
                break;;
            *)
                break;;
        esac
        break;;

    *)
        echo ----usage----
        echo diff:
        echo "  display changes between local dotfiles and those from the repository"
        echo
        echo local:
        echo "  update local dotfiles"
        echo
        echo repository:
        echo "  update the dotfiles inside the repository to the ones present on the local machine"
        break;;
esac
