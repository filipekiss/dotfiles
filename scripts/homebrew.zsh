# macOS-only stuff. Abort if not macOS.
(( ! $+functions[has_dotfiles_function] )) && [[ -e $HOME/.dotfiles/bin/dotfiles ]] && source $HOME/.dotfiles/bin/dotfiles "source"
(( ! $+functions[has_dotfiles_function] )) && echo "Something went wrong. Try again" && exit 1
is_macos || return 1

function validate_homebrew() {
  if (( ! $+commands[brew] )) && is_macos; then
    e_info "Installing Homebrew"
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    hash -r
  fi
}

function install_from_brewfile() {
  BREWFILE="${DOTFILES}/homebrew/Brewfile"
  e_info "Updating Homebrew"
  brew update
  e_info "Installing brewfile $BREWFILE"
  brew bundle --file=$BREWFILE
  e_info "Post-Install Clean-up"
  brew cleanup
  brew doctor
}

validate_homebrew
install_from_brewfile
