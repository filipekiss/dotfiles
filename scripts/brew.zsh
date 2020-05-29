function install_homebrew() {
	local brew_path=$(command -v brew)
	if [[ -z $brew_path ]]; then
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
	fi
}

function install_brewfile() {
    BREWFILE="${PWD}/homebrew/Brewfile"
    if [[ -f ${BREWFILE} ]]; then
        check_brew_update
        echo "Installing ${BREWFILE}"
        brew bundle --file=$BREWFILE --verbose
        echo "Post-Install Clean-up"
        brew cleanup
        echo "Maybe running \`brew doctor\` is a good idea"
        hash -r
    else
        echo "${RESET}No brewfile found for ${BREWFILE_NAME}. Skipping"
    fi
}

function check_brew_update() {
    [[ -n $SKIP_HOMEBREW_UPDATE ]] && return
    echo "Updating Homebrew"
    brew update
    SKIP_HOMEBREW_UPDATE="YES"
}

install_homebrew
install_brewfile
