(( ! $+functions[has_dotfiles_function] )) && [[ -e $HOME/.dotfiles/bin/dotfiles ]] && source $HOME/.dotfiles/bin/dotfiles "source"
(( ! $+functions[has_dotfiles_function] )) && echo "Something went wrong. Try again" && exit 1

PACKAGES=(
    "flow-language-server"
    "jscpd"
    "neovim"
    "prettier"
    "tern"
    "xo"
)

for package in "${PACKAGES[@]}"; do
    if (( $+commands[yarn] )); then
        yarn global add "$package"
    elif (( $+commands[npm] )); then
        npm install --global "$package"
    else
        e_error "Install yarn or npm before continuing" && exit 1
    fi
done

unset -v PACKAGES
