# macOS-only stuff. Abort if not macOS.
(( ! $+functions[has_dotfiles_function] )) && [[ -e $HOME/.dotfiles/bin/dotfiles ]] && source $HOME/.dotfiles/bin/dotfiles "source"
(( ! $+functions[has_dotfiles_function] )) && echo "Something went wrong. Try again" && exit 1
is_macos || return 1

function install_atom_packages() {
  e_info "Installing packages from ${ATOM_PACKAGES_FILE}"
  # We use this method to just install new packages. NO updates. apm install doesn't handle this well yet
  for package ($(cat $ATOM_PACKAGES_FILE )); do
    [[ -e $HOME/.atom/packages/${package%%@*} ]] && e_success "${RESET}${package%%@*} already installed" && continue
    $APM_BIN install ${package}
  done;
}

function update_ssh_permissions() {
  e_info "Setting ~/.ssh folders to 0700"
  find $HOME/.ssh -type d -exec chmod 0700 {} \;
  e_info "Setting ~/.ssh files to 0600"
  find $HOME/.ssh -type f -exec chmod 0600 {} \;
  find $HOME/.ssh/known_hosts -type f -exec chmod 0744 {} \;
  e_success "${RESET} .ssh correctly set"
}

function update_gnupg_permissions() {
  e_info "Setting ~/.gnupg folders to 0700"
  find $HOME/.gnupg -type d -exec chmod 0700 {} \;
  e_info "Setting ~/.gnupg files to 0600"
  find $HOME/.gnupg -type f -exec chmod 0600 {} \;
  find $HOME/.gnupg -type s -exec chmod 0600 {} \;
  e_success "${RESET} .gnupg correctly set"
}

APM_BIN=$(which apm)
[[ -z $ATOM_PACKAGES_FILE ]] && export ATOM_PACKAGES_FILE=$DOTFILES/config/atom/.atom/my-packages

update_ssh_permissions
update_gnupg_permissions
install_atom_packages
