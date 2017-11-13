(( ! $+functions[has_dotfiles_function] )) && [[ -e $HOME/.dotfiles/bin/dotfiles ]] && source $HOME/.dotfiles/bin/dotfiles "source"
(( ! $+functions[has_dotfiles_function] )) && echo "Something went wrong. Try again" && exit 1

PACKAGES=(
     setuptools
     pip
     pygments
     neovim
     typing
     vim-vint
     virtualenv
     jedi
     websocket-client
)

pip2 install --upgrade ${PACKAGES[@]} && pip3 install --upgrade ${PACKAGES[@]}
