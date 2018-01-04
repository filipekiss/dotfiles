(( ! $+functions[has_dotfiles_function] )) && [[ -e $HOME/.dotfiles/bin/dotfiles ]] && source $HOME/.dotfiles/bin/dotfiles "source"
(( ! $+functions[has_dotfiles_function] )) && echo "Something went wrong. Try again" && exit 1

PACKAGES=(
     setuptools
     pip
     pygments
     neovim
     neovim-remote
     typing
     vim-vint
     virtualenv
     jedi
     websocket-client
)

for package in "${PACKAGES[@]}"; do
    pip3 install --user --upgrade "$package" && pip2 install --user --upgrade "${package}"
done;
