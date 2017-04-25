# No arguments: `atom .`
# With arguments: acts like `atom`

unalias atom 2> /dev/null

if (( ! $+commands[atom] )); then
  return 0
fi

ATOM_BINARY=$commands[atom]

function atom {
  if [[ $# -eq 0 ]]; then
    $ATOM_BINARY .
  else
    $ATOM_BINARY "$@"
  fi
}
