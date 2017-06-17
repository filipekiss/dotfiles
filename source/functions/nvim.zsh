# No arguments: `nvim .`
# With arguments: acts like `nvim`

unalias nvim 2> /dev/null

if (( ! $+commands[nvim] )); then
  return 0
fi

NVIM_BINARY=$commands[nvim]

function nvim {
  if [[ $# -eq 0 ]]; then
      $NVIM_BINARY .
  else
      $NVIM_BINARY "$@"
  fi
}
