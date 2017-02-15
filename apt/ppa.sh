#!/usr/bin/env bash

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
. "${DIR}/../scripts/utils/log"

clear

_log_border
_log_line "Add PPA Repositories"
_log_line ""
_log_line "Attention: this is for Ubuntu based distros."
_log_pad 15
_log_line "${RED}${BOLD}I hold no responsibility if something goes wrong${RESET}${LOG_COLOR}"
_reset_log_padding
_log_line
_log_border


__PPA=(
  ppa:git-core/ppa
  ppa:webupd8team/terminix
)
