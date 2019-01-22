# No arguments: `open .`
# With arguments: acts like `open`

unalias o 2> /dev/null

if (( $+commands[xdg-open] )); then
  #if it's linux, we use xdg-open instead of open
  alias open="xdg-open &> /dev/null"
fi

# Exit if no command/alias open is defined
(( $+commands[open] || $+aliases[open] )) || return 0

function o {
  if [[ $# -eq 0 ]]; then
    open .
  else
    open "$@"
  fi
}

# Complete o like open
compdef o=open
