# Aliases
alias cp="${aliases[cp]:-cp} -ir"
alias ll="${aliases[ll]:-ll} -v"
alias ln="${aliases[ln]:-ln} -i"
alias ls="${aliases[ls]:-ls} -v"
alias la="${aliases[la]:-ls} -la"
alias mkdir="${aliases[mkdir]:-mkdir} -p"
alias mv="${aliases[mv]:-mv} -i"
alias ping="ping -c 4"
alias pubkey='cat $HOME/.ssh/id_rsa.pub'
alias rm="${aliases[rm]:-rm} -i"
alias rsync="rsync -rpltDv"
alias server="sudo python -m SimpleHTTPServer 80"
alias type="${saliases[type]:-type} -a"
alias gulp="nocorrect gulp"
alias weechat="weechat --dir=$HOME/.dotfiles/irc/.weechat"
alias work="mx stoodi"
alias dots="cd ${DOTFILES:-${HOME}/.dotfiles}"

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

## Use pygmentize to color cat output, if available
# if (( $+commands[pygmentize] )); then
#     unalias cat 2>/dev/null
#     alias cat='pygmentize -O console256 -g'
# fi

## Useful stuff
#alias ev="e ~/.vimrc"
#alias "?"="pwd"
#alias flushcache="dscacheutil -flushcache && sudo killall -HUP mDNSResponder"

#[[ $TMUX == *"tmux"* ]] && alias :sp='tmux split-window'
#[[ $TMUX == *"tmux"* ]] && alias :vs='tmux split-window -h'
#[[ $TMUX == *"tmux"* ]] && alias ssh="TERM=xterm-256color ssh"

## Add default arguments to a few command
(( $+commands[rg] )) && alias rg="${commands[rg]} --hidden"
