########################################################################
# Expanding Aliases Functions
# http://www.math.cmu.edu/~gautam/sj/blog/20140625-zsh-expand-alias.html
########################################################################
typeset -a ealiases
ealiases=()

function ealias() {
  alias $1
  ealiases+=(${1%%\=*})
}

