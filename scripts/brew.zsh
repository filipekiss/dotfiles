(( ! $+functions[has_dotfiles_function] )) && [[ -e $HOME/.dotfiles/bin/dotfiles ]] && source $HOME/.dotfiles/bin/dotfiles "source"
(( ! $+functions[has_dotfiles_function] )) && echo "Something went wrong. Try again" && exit 1

function select_brewfiles() {
    local BREWFILES
    BREWFILES=($1)
    e_info "Selecting brewfiles"
    # If no brewfile was passed, install common and then the specific distro brewfile.
    if [[ -z $BREWFILES ]]; then
        e_info "No brewfiles passed. Auto-Selecting..."
        SYSTEM_BREW=$(get_os)
        BREWFILES=("common" ${SYSTEM_BREW})
    fi
    e_info "Brewfiles selected for installation: ${YELLOW}${BREWFILES}"
    if [[ -n $BREWFILES ]]; then
        for BREWFILE ($BREWFILES) install_brewfile $BREWFILE
        if [[ -n $RUN_CLEANUP ]]; then
            e_info "Post-Install Clean-up"
            brew cleanup
            e_info "Maybe running \`brew doctor\` is a good idea"
        fi
        hash -r
    else
        e_info "No Brewfile selected for installation"
    fi
}

function install_brewfile() {
    local BREWFILE_NAME
    BREWFILE_NAME="$1"
    local BREWFILE
    BREWFILE="${DOTFILES}/homebrew/${BREWFILE_NAME}"
    if [[ -f ${BREWFILE} ]]; then
        check_brew_update
        e_info "Installing brewfile ${BREWFILE}"
        brew bundle --file=$BREWFILE --verbose
        RUN_CLEANUP="YES"
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

select_brewfiles "$@"
