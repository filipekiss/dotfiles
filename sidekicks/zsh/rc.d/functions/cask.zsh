# Alias for `brew cask`
#
# No arguments will work as `brew cask list`. Otherwise will behave as `brew cask`

is_macos || return 0

(( $+commands[brew] )) || return 0

unalias cask 2> /dev/null

function cask() {
  if [[ $# -eq 0 ]]; then
    brew cask list
  else
    brew cask $@
  fi
}

# Autocomplete as if typing `brew cask`
compdef '_brew_cask' cask
