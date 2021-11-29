autoload -Uz compinit vcs_info
zstyle ':completion:*' menu select
zstyle ':vcs_info:*' enable git svn
zstyle ':vcs_info:git:*' formats ' %F{#989719}%f %F{#689d69}%b%f'
zmodload zsh/complist
compinit

precmd() {
	vcs_info
	print -Pn '\e]2;%c\a'
}

preexec() {
	print -Pn '\e]2;$1\a'
}

setopt prompt_subst
PROMPT='%B「%U%F{1}%n%f%u@%U%F{6}%m%f%u%  %c${vcs_info_msg_0_}」%b'
EDITOR='nvim'

alias vim='nvim'
alias ls='ls --color=auto --group-directories-first'
alias grep='grep -P --color=auto'
alias mkdir='mkdir -p'
alias vim='nvim'
alias cp='cp -r'
alias less='less -r'
alias ranger='TERM=kitty ranger'
alias resolution='ffprobe -v warning -select_streams v:0 -show_entries format=filename:stream=width,height -of csv=s=x:p=0'

export PATH=$PATH:/home/aaron/.local/bin
export EDITOR=nvim

# autosuggestions (requires zsh-autosuggestions)
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
# syntax highlighting (requires zsh-syntax-highlighting)
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
