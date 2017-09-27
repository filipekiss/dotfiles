# Ubuntu-only stuff. Abort if not Ubuntu.
(( ! $+functions[has_dotfiles_function] )) && [[ -e $HOME/.dotfiles/bin/dotfiles ]] && source $HOME/.dotfiles/bin/dotfiles "source"
(( ! $+functions[has_dotfiles_function] )) && echo "Something went wrong. Try again" && exit 1
is_ubuntu || return 1

function validate_linuxbrew() {
  if (( ! $+commands[brew] )) && is_ubuntu; then
    sudo apt-get install build-essential curl file git python-setuptools ruby
    e_info "Installing Linuxbrew"
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install)"
    hash -r
  fi
}

function install_from_brewfile() {
  BREWFILE="${DOTFILES}/linuxbrew/Brewfile"
  e_info "Updating Linuxbrew"
  brew update
  e_info "Installing brewfile $BREWFILE"
  brew bundle --file=$BREWFILE
  e_info "Post-Install Clean-up"
  brew cleanup
  e_info "Maybe running \`brew doctor\` is a good idea" 
}

validate_linuxbrew
install_from_brewfile
