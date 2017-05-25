(( ! $+functions[has_dotfiles_function] )) && [[ -e $HOME/.dotfiles/bin/dotfiles ]] && source $HOME/.dotfiles/bin/dotfiles "source"
(( ! $+functions[has_dotfiles_function] )) && echo "Something went wrong. Try again" && exit 1
# Ensure some files are absolute links (git hooks, for example).
# For now, use an specific solution. If this ever needs to be changed, write a
# proper way to make this automatic (maybe drop stow and link things manually)

function link_git_hooks() {
  local git_hooks=($(find "${DOTFILES}/config/git/.git_template/hooks" -type f))
  for hook in $git_hooks; do
    local final_name=$HOME/${hook##$DOTFILES/config/git/}
    e_info "Linking $(basename $hook)"
    ln -sf $hook $final_name
  done
}

link_git_hooks
