#!/usr/bin/env bash

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
. "${DIR}/../scripts/utils/utils"

[[ ${IS_UBUNTU} == ${NO} ]] && e_error "Oops. This is not an Ubuntu distro"

install_apt_packages() {
  local __APT=(
      "terminix"
      "php5.6 php5.6-mbstring php5.6-mcrypt php5.6-mysql php5.6-xml"
      "mysql-server"
  )

  sudo -v
  # Keep-alive: update existing sudo time stamp if set, otherwise do nothing.
  while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

  e_header "Installing packages"
  e_info "Updating apt-get"
  sudo apt-get update > /dev/null 2>&1 && e_success "Done!"
  for __package in ${__APT[@]}; do
    e_info "Installing ${__package}"
    sudo apt-get -y install "${__package}" > /dev/null 2>&1 && e_success "${__package} successfully installed" || e_error "Error installing ${__package}"
  done;
}

install_apt_packages
