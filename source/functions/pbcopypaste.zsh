is_ubuntu || return 0

[[ $+commands[xclip] ]] || return 0

alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'
