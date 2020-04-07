PACKAGES=(
     "setuptools"
     "neovim-remote"
     "pip"
     "pygments"
     "python-language-server[all]"
     "typing"
     "vim-vint"
     "virtualenv"
     "jedi"
     "websocket-client"
)

for package in "${PACKAGES[@]}"; do
    [[ $package == "pip" ]] && FLAGS="--upgrade" || FLAGS="--user"
    pip install "$FLAGS" "$package"
done;
