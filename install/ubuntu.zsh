! has_dotfiles_function > /dev/null 2>&1 && [[ -e $HOME/.dotfiles/bin/dotfiles ]] && source $HOME/.dotfiles/bin/dotfiles "source"
! has_dotfiles_function > /dev/null 2>&1 && echo "Something went wrong. Try again" && exit 1
is_ubuntu || return 1


trap cleanup EXIT INT
function cleanup {
  e_activity_end
}

function update_apt() {
  e_activity "Update apt-cache"
  sudo apt-get update > /dev/null
  RETVAL=$?
  e_activity_end
  [[ $RETVAL -eq 0 ]] && e_success "apt-cache updated" || e_error "Something went wrong updating apt-cache. Try again";
}

function install_from_apt() {
  local package="$1"
  local ppa="$2"
  HAS_PACKAGE_BINARY=$(yes_no command -v $package)
  HAS_PACKAGE_APT=$(yes_no sudo apt-cache show $package)
  [[ $HAS_PACKAGE_BINARY = "yes" ]] && e_success "${package} already installed" && return
  if [[ $HAS_PACKAGE_APT = "no" ]]; then
    if [[ -z $ppa ]]; then
      e_error "${RESET}${package} not found and no ppa provided."
      return 1
    fi
    e_info "${package} not found on cache. adding ppa."
    sudo add-apt-repository ${ppa}
    update_apt
  fi
  e_activity "$package not found. Installing..."
  sudo apt-get install -y $package > /dev/null 2>&1
  RETVAL=$?
  e_activity_end
  [[ $RETVAL -eq 0 ]] && e_success "Done. ${RESET}${package} installed" || e_error "Error installing $package"
}
## Sudo Keep Alive by Ben Alman
sudo -v
## Keep-alive: update existing sudo time stamp if set, otherwise do nothing.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

e_header "Install Ubuntu Stuff"
# Update apt-cache before everything
update_apt

## Youtube-DL
install_from_apt "youtube-dl" "ppa:nilarimogard/webupd8"
