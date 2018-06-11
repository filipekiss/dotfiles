(( ! $+functions[has_dotfiles_function] )) && [[ -e $HOME/.dotfiles/bin/dotfiles ]] && source $HOME/.dotfiles/bin/dotfiles "source"
(( ! $+functions[has_dotfiles_function] )) && echo "Something went wrong. Try again" && exit 1

PACKAGES=(
     "setuptools"
     "pip"
     "pygments"
     "python-language-server[all]"
     "neovim"
     "neovim-remote"
     "typing"
     "vim-vint"
     "virtualenv"
     "jedi"
     "websocket-client"
)

for package in "${PACKAGES[@]}"; do
    [[ $package == "pip" ]] && FLAGS="--upgrade" || FLAGS="--user"
    pip3 install "$FLAGS" "$package" && pip2 install "$FLAGS" "${package}"
done;
