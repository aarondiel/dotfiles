PS1="%B「%U%F{#d70022}%n%f%u@%U%F{#00feff}%m%f%u%  %c」%b"

precmd() {
	print -Pn "\e]2;%c\a"
}

preexec() {
	print -Pn "\e]2;$1\a"
}

autoload -Uz compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit

alias ls='ls --color=auto --group-directories-first'
alias grep='grep -P --color=auto'
alias mkdir='mkdir -p'
alias vim='nvim'
alias cp='cp -r'

export PATH=$PATH:/home/aaron/.local/bin

# autosuggestions (requires zsh-autosuggestions)
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
# syntax highlighting (requires zsh-syntax-highlighting)
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
