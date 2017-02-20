#!/usr/bin/env bash

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
. "${DIR}/../scripts/utils/utils"

sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

e_info "Updating apt-get"
e_start_spinner
sudo apt-get update 1> /dev/null
RETVAL=$?
e_stop_spinner
[[ $RETVAL ]] && e_error "Something went wrong updating apt" || e_success "Successfully update apt"

e_info "Installing Ubuntu Trusty Extras"
sudo apt-get install -y --no-install-recommends linux-image-extra-$(uname -r) linux-image-extra-virtual 1> /dev/null
RETVAL=$?
e_stop_spinner
[[ $RETVAL ]] && e_error || e_success "Done"

e_info "Enabling HTTP repositories"
sudo apt-get install -y --no-install-recommends apt-transport-https ca-certificates  curl  software-properties-common 1> /dev/null
RETVAL=$?
[[ $RETVAL ]] && e_error && e_success "Done"

e_info "Adding Docker GPG Key"
curl -fsSL https://apt.dockerproject.org/gpg | sudo apt-key add -
e_info "Adding Docker Repository"
sudo add-apt-repository \
       "deb https://apt.dockerproject.org/repo/ \
       ubuntu-$(lsb_release -cs) \
       main"
e_success "Done"


e_info "Updating apt-get"
e_start_spinner
sudo apt-get update 1> /dev/null
RETVAL=$?
e_stop_spinner
[[ $RETVAL ]] && e_error "Something went wrong updating apt" || e_success "Successfully update apt"

e_info "Installing Docker Engine"
e_start_spinner
sudo apt-get install -y 1> /dev/null
RETVAL=$?
e_stop_spinner
[[ $RETVAL ]] && e_error || e_success "Docker Engine installed Successfully"

e_inline " - Do you wish to run the ${PURPLE}hello world${BLUE} image? [y/N]:" $BLUE $LOG_STATUS_INFO
read -r RUN_DOCKER_TEST

case $RUN_DOCKER_TEST in
  [yY] )
    e_info "Runnning docker ${PURPLE}hello world${BLUE} image"
    sudo docker run hello-world
    ;;
  * )
    e_info "Ok. Exitting..."
  ;;
esac
