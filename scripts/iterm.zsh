# macOS-only stuff. Abort if not macOS.
(( ! $+functions[has_dotfiles_function] )) && [[ -e $HOME/.dotfiles/bin/dotfiles ]] && source $HOME/.dotfiles/bin/dotfiles "source"
(( ! $+functions[has_dotfiles_function] )) && echo "Something went wrong. Try again" && exit 1
is_macos || return 0

DOWNLOAD_LOCATION=$DOTFILES/caches/downloads

ITERM_THEMES_REPOS=(
    https://github.com/arcticicestudio/nord-iterm2.git
    https://github.com/morhetz/gruvbox-contrib.git
)

function update_iterm_config() {
  local full_package_location
  full_package_location="$1"
  cd $full_package_location
  e_info "Adding ${full_package_location:t:r} to iTerm"
  local itermfiles
  itermfiles=($(find $full_package_location -type f -iname "*.itermcolors"))
  for file ($itermfiles) open -a iTerm "$file"
  e_success "${RESET}Done"
}

function download_or_update_package() {
    local repo_url
    repo_url="$1"
    local package_name
    package_name=${repo_url:t:r}
    # Package will be under <user/org>/<package>
    local url_prefix
    url_prefix=${repo_url%/*/*.git}
    local package_author_name
    package_author_name=${repo_url#$url_prefix/}
    package_author_name=${package_author_name:r}
    local full_package_location
    full_package_location="${DOWNLOAD_LOCATION}/${package_author_name}"
    if [[ ! -d $full_package_location ]]; then
        e_info "${package_author_name} for iTerm2 not found. Cloning..."
        git clone $repo_url $full_package_location
        update_iterm_config "${full_package_location}"
    else
        cd ${full_package_location}
        prev_head="$(git rev-parse HEAD)"
        git reset --hard HEAD
        git pull
        current_head="$(git rev-parse HEAD)"
        if [[ $current_head != $prev_head ]]; then
            update_iterm_config ${full_package_location}
        else
            e_info "${package_author_name} Already at latest version"
        fi
    fi
}

for PACKAGE ($ITERM_THEMES_REPOS) download_or_update_package "$PACKAGE"
