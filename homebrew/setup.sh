#!/usr/bin/env bash

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
source "${DIR}/../scripts/utils/utils"

homebrew() {
  e_header "Installing Homebrew"
  [[ ${IS_OSX} == "${NO}" ]]  && e_warning "Not OSX. Skipping homebrew..." && return 0
  #install homebrew if missing
  if [[ ! $HAS_BREW ]]; then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" && e_success "Homebrew Installed"
  fi
}
