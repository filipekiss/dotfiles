(( ! $+functions[has_dotfiles_function] )) && [[ -e $HOME/.dotfiles/bin/dotfiles ]] && source $HOME/.dotfiles/bin/dotfiles "source"
(( ! $+functions[has_dotfiles_function] )) && echo "Something went wrong. Try again" && exit 1

yarn config set prefix $HOME/.yarn

PACKAGES=(
    "jscpd"
    "tern"
    "neovim"
)

for package in "${PACKAGES[@]}"; do
  yarn global add "$package"
done

unset -v PACKAGES
