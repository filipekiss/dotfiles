#useful ls alias that use tree if available
[[ $+commands[tree] ]] || return 0

unalias lf  2> /dev/null
unalias ll  2> /dev/null
unalias lf  2> /dev/null

#simple aliases
alias ll="tree -da -L 1"
alias la="tree --dirsfirst -FL 1"

# custom lf function to show files only
function lf {
  local command=""
  if [[ $# -eq 0 ]]; then
    tree --dirsfirst -FL 1 ./ | grep -v /$
  else
    tree --dirsfirst -FL 1 "$@" | grep -v /$
  fi
}
