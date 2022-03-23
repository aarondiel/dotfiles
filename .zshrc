autoload -Uz compinit vcs_info
zmodload zsh/complist

pwd_contains_comp_file() {
	[ -n "$(ls -1 | grep -P '^_.+')" ] &&
		return 0

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
	print -Pn '\e]2;%c\a'
}

preexec() {
	print -Pn '\e]2;$1\a'
}

chpwd || compinit

zstyle ':completion:*' menu select
zstyle ':vcs_info:*' enable git svn
zstyle ':vcs_info:git:*' formats ' %F{#989719}%f %F{#689d69}%b%f'

setopt prompt_subst

source "${HOME}/.config/lf/icons.sh"

export PROMPT='%B「%U%F{1}%n%f%u@%U%F{6}%m%f%u%  %c${vcs_info_msg_0_}」%b'
export EDITOR='nvim'
export VISUAL='nvim'
export KEYTIMEOUT=1
export PATH="$PATH:$HOME/.local/bin:$HOME/Documents/scripts"

alias vim='nvim'
alias ls='exa'
alias grep='grep -P --color=auto'
alias mkdir='mkdir -p'
alias vim='nvim'
alias cp='cp -r'
alias less='less -r'
alias ranger='TERM=kitty ranger'
alias icat='kitty +kitten icat'
alias du='du -sch'

bindkey -v
bindkey '^[[Z' reverse-menu-complete
bindkey '\t' menu-complete

# autosuggestions (requires zsh-autosuggestions)
[ -e /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ] &&
	source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
# syntax highlighting (requires zsh-syntax-highlighting)
[ -e /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] &&
	source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
