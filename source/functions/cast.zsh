# Alias for `brew install`
#
# No arguments will work as `brew ls`. Otherwise will behave as `brew install`

is_macos || return 0

[[ $+commands[brew] ]] || return 0

unalias cast 2> /dev/null

function cast() {
  if [[ $# -eq 0 ]]; then
    brew ls
  else
    brew install $@
  fi
}

# Autocomplete as if typing `brew cask`
compdef '_brew_install' cast
