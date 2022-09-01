autoload -Uz compinit vcs_info

zmodload zsh/complist

zstyle ":completion:*" menu select
zstyle ":vcs_info:*" enable git
zstyle ":vcs_info:*" actionformats " %F{12}%f %F{2}%b%f | %F{3}%a%f"
zstyle ":vcs_info:*" formats " %F{12}%f %F{2}%b%f"

source "${HOME}/.config/lf/icons.sh"

pwd_contains_comp_file() {
	[ -n "$(ls -1 | grep -P "^_.+")" ] && return 0

	return 1
}

chpwd() {
	pwd_contains_comp_file &&
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
