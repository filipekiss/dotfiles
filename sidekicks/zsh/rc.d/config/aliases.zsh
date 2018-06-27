#########
# Aliases
#########
alias cp="${aliases[cp]:-cp} -ir"
alias ll="${aliases[ll]:-ll} -v"
alias ln="${aliases[ln]:-ln} -i"
alias ls="${aliases[ls]:-ls} -v"
alias la="${aliases[la]:-ls} -la"
alias mkdir="${aliases[mkdir]:-mkdir} -p"
alias mv="${aliases[mv]:-mv} -i"
alias ping="${aliases[ping]:-ping} -c 4"
alias pubkey='cat $HOME/.ssh/id_rsa.pub'
alias rm="${aliases[rm]:-rm} -i"
alias rsync="${aliases[rsync]:-rsync} -rpltDv"
alias type="${aliases[type]:-type} -a"
alias work="mx stoodi"
alias dots="cd ${DOTFILES:-${HOME}/.dotfiles}"
alias getPath='echo $PATH | tr -s ":" "\n"'

## File Download
if (( $+commands[aria2c] )); then
  alias get='aria2c --continue --remote-time --file-allocation=none'
elif (( $+commands[curl] )); then
  alias get='curl --continue-at - --location --progress-bar --remote-name --remote-time'
elif (( $+commands[wget] )); then
  alias get='wget --continue --progress=bar --timestamping'
fi

if (( $+commands[htop] )); then
  alias top=htop
fi

# Python Simple HTTP Server
if (( $+commands[python3] )); then
    alias server="sudo python3 -m http.server 80"
fi

## Resource Usage
alias df='df -kh'
alias du='du -kh'

##Global Aliases
alias -g C='| pbcopy'
alias -g G='|grep -i '
alias -g X='| xargs'

if (( $+commands[exa] )); then
  alias ll="exa --tree"
elif (( $+commands[tree] )); then
  alias ll="type tree >/dev/null && tree -da -L 1 || l -d .*/ */ "
else
  alias ll="echo 'You have to install exa or tree'"
fi

## Useful stuff
alias "?"="pwd"
alias flushcache="dscacheutil -flushcache && sudo killall -HUP mDNSResponder"

# SSH when in TMUX needs to explicitly pass $TERM
[[ $TERM == *"tmux"* ]] && alias ssh="TERM=xterm-256color ssh"
