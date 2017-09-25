# macOS-only stuff. Abort if not macOS.
(( ! $+functions[has_dotfiles_function] )) && [[ -e $HOME/.dotfiles/bin/dotfiles ]] && source $HOME/.dotfiles/bin/dotfiles "source"
(( ! $+functions[has_dotfiles_function] )) && echo "Something went wrong. Try again" && exit 1
is_macos || return 1

DOWNLOAD_LOCATION=$DOTFILES/caches/downloads/

ITERM_THEMES_REPOS=(
    https://github.com/arcticicestudio/nord-iterm2.git
    https://github.com/herrbischoff/iterm2-gruvbox
)

function update_iterm_config() {
  local package_location="$1"
  cd $package_location
  e_info "Adding ${package_location:t:r} to iTerm"
  local itermfiles=$(find $package_location -type f -iname "*.itermcolors")
  for file ($itermfiles) open -a iTerm "$file"
  e_success "${RESET}Done"
}

function download_or_update_package() {
    local repo_url="$1"
    local package_name=${repo_url:t:r}
    local package_location="${DOWNLOAD_LOCATION}/${package_name}"
    if [[ ! -d $package_location ]]; then
        e_info "${package_name} for iTerm2 not found. Cloning..."
        git clone $repo_url $package_location
        update_iterm_config "${package_location}"
    else
        cd ${package_location}
        prev_head="$(git rev-parse HEAD)"
        git reset --hard HEAD
        git pull
        current_head="$(git rev-parse HEAD)"
        if [[ $current_head != $prev_head ]]; then
            update_iterm_config ${pacakge_location}
        else
            e_info "${package} Already at latest version"
        fi
    fi
}

for PACKAGE ($ITERM_THEMES_REPOS) download_or_update_package "$PACKAGE"
