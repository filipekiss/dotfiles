#!/usr/bin/env bash

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
. "${DIR}/../scripts/utils/utils"

ask_for_sudo() {
  sudo -v
  while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
}

setup_docker_group() {
  username=$(whoami)
  if groups $username | grep &>/dev/null '\bdocker\b'; then
      e_info "User already in Docker group. Nothing else necessary."
      return
  fi
  if cut -d: -f1 /etc/group | grep &>/dev/null 'docker'; then
    e_info "Docker group already present";
  else
    e_info "Adding docker group"
    sudo groupadd docker
  fi
  e_info "Adding ${USER} to docker group"
  sudo gpasswd -a ${USER} docker
  e_info "Restarting Docker Daemon"
  sudo service docker restart
  e_success "Added${RESET} ${PURPLE}$(whoami)${RESET} to ${PURPLE}docker${RESET} group."
  e_info "  You may need to logout and login again for these changes to take effect."
}

install_docker() {
  e_activity "Adding Docker APT Key"
  sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D > /dev/null 2>&1
  e_activity_end
  e_success "Added Docket APT Key"
  #Add Docker Repository
  e_activity "Adding Docker Repository Info"
  sudo apt-add-repository 'deb https://apt.dockerproject.org/repo ubuntu-xenial main' > /dev/null
  e_activity_end
  e_success "Added Docker Repository Info"
  e_activity "Updating APT Cache"
  # sudo apt-get update > /dev/null
  e_activity_end
  e_success "Updated APT Cache"
  e_activity "Installing Docker Engine"
  sudo apt-get install -y docker-engine > /dev/null
  e_activity_end
  e_success "Installed Docker Engine"
}

ask_group_setup() {
  e_set_inline
  e_info "Do you wish to use docker without sudo? [Y/n]: "
  read USE_DOCKER_WITHOUT_SUDO
  e_reset_line
  case $USE_DOCKER_WITHOUT_SUDO in
    [Nn] )
      e_info "Okay. Remember to use sudo when using docker"
      ;;
    * )
      setup_docker_group
      ;;
  esac
}

validate_docker_installation() {
  docker ps > /dev/null 2>&1
  DOCKER_SUDO=$?
  [[ $DOCKER_SUDO ]] && DOCKER_SUDO="sudo " || DOCKER_SUDO=""
  e_info "Running Hello World Container"
  $DOCKER_SUDO docker run hello-world
}

install_docker_compose() {
  e_info "Retrieving Latest Docker Compose Version"
  COMPOSE_VERSION=`git ls-remote https://github.com/docker/compose | grep refs/tags | grep -oP "[0-9]+\.[0-9][0-9]+\.[0-9]+$" | tail -n 1`
  COMPOSE_DISTRO=$(uname -s)
  COMPOSE_ARCH=$(uname -m)
  e_info "Downloading docker-compose ${COMPOSE_VERSION} for ${COMPOSE_DISTRO}-${COMPOSE_ARCH}"
  sudo sh -c "curl -L https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-${COMPOSE_DISTRO}-${COMPOSE_ARCH} > /usr/local/bin/docker-compose"
  sudo chmod +x /usr/local/bin/docker-compose
}

install_docker
ask_group_setup
validate_docker_installation
install_docker_compose

e_success "Eveyrthing is setup. Happy Docking."