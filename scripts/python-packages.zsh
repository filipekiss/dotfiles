(( ! $+functions[has_dotfiles_function] )) && [[ -e $HOME/.dotfiles/bin/dotfiles ]] && source $HOME/.dotfiles/bin/dotfiles "source"
(( ! $+functions[has_dotfiles_function] )) && echo "Something went wrong. Try again" && exit 1

PACKAGES=(
     --upgrade setuptools
     --upgrade pip
     pygments
     neovim
     tmuxp
     vim-vint
     jedi
)

pip2 install ${PACKAGES[@]} && pip3 install ${PACKAGES[@]}