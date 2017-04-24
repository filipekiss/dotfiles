# No arguments: `atom .`
# With arguments: acts like `atom`

unalias atom 2> /dev/null

if (( ! $+commands[atom] )); then
  return 0
fi

function atom {
  if [[ $# -eq 0 ]]; then
    atom .
  else
    atom "$@"
  fi
}
