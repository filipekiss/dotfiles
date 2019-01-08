(( ! $+functions[has_dotfiles_function] )) && [[ -e $HOME/.dotfiles/bin/dotfiles ]] && source $HOME/.dotfiles/bin/dotfiles "source"
(( ! $+functions[has_dotfiles_function] )) && echo "Something went wrong. Try again" && exit 1

function install_brewfile() {
    BREWFILE="${PWD}/homebrew/Brewfile"
    if [[ -f ${BREWFILE} ]]; then
        check_brew_update
        e_info "Installing ${BREWFILE}"
        brew bundle --file=$BREWFILE --verbose
        e_info "Post-Install Clean-up"
        brew cleanup
        e_info "Maybe running \`brew doctor\` is a good idea"
        hash -r
    else
        e_error "${RESET}No brewfile found for ${BREWFILE_NAME}. Skipping"
    fi
}

function check_brew_update() {
    [[ -n $SKIP_HOMEBREW_UPDATE ]] && return
    e_info "Updating Homebrew"
    brew update
    SKIP_HOMEBREW_UPDATE="YES"
}

install_brewfile
