#!/usr/bin/env bash

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
. "${DIR}/../scripts/utils/utils"

install_ppa() {
    local __PPA=(
      "git-core/ppa"
      "webupd8team/terminix"
      "ondrej/php"
    )

    sudo -v
    # Keep-alive: update existing sudo time stamp if set, otherwise do nothing.
    while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

    e_header "Adding PPA"
    ADDED_PPA=0
    for __repo in ${__PPA[@]}; do
      PPA_EXISTS=$(grep "${__repo}" /etc/apt/sources.list /etc/apt/sources.list.d/*)
      [[ ${PPA_EXISTS} ]] && e_success "${__repo} already added. Skipping..." && continue #go to next PPA if this one is already added
      e_info "Adding ${__repo}"
      sudo add-apt-repository -y "ppa:${__repo}" > /dev/null 2>&1 && e_success "${__repo} successfully added" && ADDED_PPA=$((${ADDED_PPA} + 1)) || e_error "Error adding ${__repo}"
    done;
    if [[ ${ADDED_PPA} -gt 0 ]]; then
      e_info "Updating apt-get"
      sudo apt-get update > /dev/null 2>&1 && e_success "Done!"
    else
      e_info "No PPA addeds. No updated needed for now..."
    fi

}

install_ppa
