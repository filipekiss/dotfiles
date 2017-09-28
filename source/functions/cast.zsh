# Alias for `brew install`
#
# No arguments will work as `brew ls`. Otherwise will behave as `brew install`

(( $+commands[brew] )) || return 0

unalias cast 2> /dev/null

function cast() {
  if [[ $# -eq 0 ]]; then
    brew ls
else
    HOMEBREW_INSTALL_BADGE="🔮" brew install $@
  fi
}

# Autocomplete as if typing `brew cask`. This only works on macos
is_macos && compdef '_brew_install' cast
