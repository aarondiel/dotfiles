PS1="%B「%U%F{#d70022}%n%f%u@%U%F{#00feff}%m%f%u%  %c」%b"

autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit

alias ls='ls --color=auto --group-directories-first'
alias grep='grep --color=auto'
alias mkdir='mkdir -p'
