autoload -Uz compinit vcs_info

zmodload zsh/complist

zstyle ":completion:*" menu select
zstyle ":vcs_info:*" enable git
zstyle ":vcs_info:*" actionformats " %F{12}%f %F{2}%b%f | %F{3}%a%f"
zstyle ":vcs_info:*" formats " %F{12}%f %F{2}%b%f"

source "${HOME}/.config/lf/icons.sh"

contains_comp_file() {
	directory="$1"
	[ -d "$directory" ] || return 1

	underscore_files=$(ls -1 "$directory" | grep -P "^_.+$")
	[ -n "$underscore_files" ] || return 1

	for underscore_file in $underscore_files
	do
		underscore_file=$(readlink -f "$underscore_file")

		[ -f "$underscore_file" ] || continue

		contains_compdef=$(head -n 1 "$underscore_file" | grep -P "^#compdef.*$")
		[ -n "$contains_compdef" ] && return 0
	done

	return 1
}

chpwd() {
	contains_comp_file "$PWD" &&
		[ "${fpath[(Ie)$PWD]}" = "0" ] &&
		echo " PWD CONTAINS COMPLETION FILE -> adding to fpath..." ||
		return 1

	fpath=($fpath $PWD) &&
		compinit &&
		return 0 ||
		return 1
}

precmd() {
	vcs_info

	print -Pn "\e]2;%c\a"
}

preexec() {
	print -Pn "\e]2;$1\a"
}

chpwd || compinit

setopt prompt_subst

export PROMPT="%B「%U%F{1}%n%f%u@%U%F{6}%m%f%u %c\${vcs_info_msg_0_} 」%b"
export EDITOR="nvim"
export VISUAL="nvim"
export KEYTIMEOUT=1
export PATH="$PATH:$HOME/.local/bin:$HOME/Documents/scripts"

alias vim="nvim"
alias ssh="kitty +kitten ssh"
alias ls="exa"
alias grep="grep -P --color=auto"
alias mkdir="mkdir -p"
alias vim="nvim"
alias cp="cp -r"
alias less="less -r"
alias icat="kitty +kitten icat"
alias du="du -sch"
alias compress_folder="tar -czf"

bindkey -v
bindkey "^[[Z" reverse-menu-complete
bindkey "\t" menu-complete

autosuggestions="/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
[ -e "$autosuggestions" ] && source "$autosuggestions"

syntax_highlighting="/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
[ -e "$syntax_highlighting" ] && source "$syntax_highlighting"
