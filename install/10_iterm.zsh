# macOS-only stuff. Abort if not macOS.
(( ! $+functions[has_dotfiles_function] )) && [[ -e $HOME/.dotfiles/bin/dotfiles ]] && source $HOME/.dotfiles/bin/dotfiles "source"
(( ! $+functions[has_dotfiles_function] )) && echo "Something went wrong. Try again" && exit 1
is_macos || return 1

NORD_ITERM_REPO_URL=https://github.com/arcticicestudio/nord-iterm2.git
NORD_LOCAL_REPO=$DOTFILES/caches/downloads/nord-iterm2

function update_iterm_config() {
  cd $NORD_LOCAL_REPO
  e_info "Adding Color Scheme to iTerm"
  open -a iTerm "${NORD_LOCAL_REPO}/src/xml/Nord.itermcolors"
  e_success "${RESET}Done"
}
if [[ ! -d $NORD_LOCAL_REPO ]]; then
  e_info "Nord Colors for iTerm2 not found. Cloning..."
  git clone $NORD_ITERM_REPO_URL $NORD_LOCAL_REPO
  update_iterm_config
else
  cd $NORD_LOCAL_REPO
  prev_head="$(git rev-parse HEAD)"
  git reset --hard HEAD
  git pull
  current_head="$(git rev-parse HEAD)"
  if [[ $current_head != $prev_head ]]; then
    update_iterm_config
  else
    e_info "Already at latest version"
  fi
fi
