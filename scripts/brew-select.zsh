(( ! $+functions[has_dotfiles_function] )) && [[ -e $HOME/.dotfiles/bin/dotfiles ]] && source $HOME/.dotfiles/bin/dotfiles "source"
(( ! $+functions[has_dotfiles_function] )) && echo "Something went wrong. Try again" && exit 1
is_macos && source $DOTFILES/scripts/homebrew.zsh
is_ubuntu && source $DOTFILES/scripts/linuxbrew.zsh
