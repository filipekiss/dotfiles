(( ! $+functions[has_dotfiles_function] )) && [[ -e $HOME/.dotfiles/bin/dotfiles ]] && source $HOME/.dotfiles/bin/dotfiles "source"
(( ! $+functions[has_dotfiles_function] )) && echo "Something went wrong. Try again" && exit 1

function update_ssh_permissions() {
  e_info "Setting ~/.ssh folders to 0700"
  find $HOME/.ssh -exec chmod 0700 {} \;
  e_info "Setting ~/.ssh files to 0600"
  find $HOME/.ssh/* -type f -exec chmod 0600 {} \;
  find $HOME/.ssh/known_hosts -type f -exec chmod 0744 {} \;
  e_success "${RESET} .ssh correctly set"
}

function update_gnupg_permissions() {
  e_info "Setting ~/.gnupg folders to 0700"
  find $HOME/.gnupg -exec chmod 0700 {} \;
  e_info "Setting ~/.gnupg files to 0600"
  find $HOME/.gnupg/* -type f -exec chmod 0600 {} \;
  find $HOME/.gnupg/* -type s -exec chmod 0600 {} \;
  e_success "${RESET} .gnupg correctly set"
}

update_ssh_permissions
update_gnupg_permissions
