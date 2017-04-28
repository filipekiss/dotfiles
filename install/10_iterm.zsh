# macOS-only stuff. Abort if not macOS.
(( ! $+functions[has_dotfiles_function] )) && [[ -e $HOME/.dotfiles/bin/dotfiles ]] && source $HOME/.dotfiles/bin/dotfiles "source"
(( ! $+functions[has_dotfiles_function] )) && echo "Something went wrong. Try again" && exit 1
is_macos || return 1

NORD_ITERM_RELEASES="https://github.com/arcticicestudio/nord-iterm2/releases/latest"
GITHUB_RELEASES_PREFIX="https://github.com"
TEMP_FILE_NAME="/tmp/nord-iterm-latest.tar.gz"

function get_latest_release() {
  local version_url
  version_url=$(curl -sL $NORD_ITERM_RELEASES | grep "/archive/.*\.tar.gz" | cut -d '"' -f2)
  echo "${GITHUB_RELEASES_PREFIX}${version_url}"
}

function download_nord_theme() {
  local final_url
  if [[ ! -f "$TEMP_FILE_NAME" ]]; then
    e_info "Retrieving URL"
    final_url=$(get_latest_release)
    e_info "Downloading Nord Theme for iTerm"
    sleep 0.5
    curl -o $TEMP_FILE_NAME -l $final_url
  else
    e_info "Cached file found at $TEMP_FILE_NAME"
  fi
  e_info "Extracting Nord Theme"
  cd /tmp
  extract nord-iterm-latest.tar.gz
  cd nord-iterm2*
  e_info "Adding Color Scheme to iTerm"
  open -a iTerm /tmp/nord-iterm2*/src/xml/*.itermcolors
  e_success "${RESET}Done"
}

download_nord_theme
