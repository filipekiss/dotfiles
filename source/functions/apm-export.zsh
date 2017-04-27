# Export atom packages to $ATOM_PACKAGES_FILE or $1

[[ $+commands[apm] ]] || return 0

function apm-export() {
  local export_to_file
  [[ $1 ]] && export_to_file="$1"
  [[ -z $export_to_file ]] && export_to_file=$ATOM_PACKAGES_FILE
  apm ls --installed --bare >! $ATOM_PACKAGES_FILE
}
