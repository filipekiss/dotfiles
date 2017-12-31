(( ! $+functions[has_dotfiles_function] )) && [[ -e $HOME/.dotfiles/bin/dotfiles ]] && source $HOME/.dotfiles/bin/dotfiles "source"
(( ! $+functions[has_dotfiles_function] )) && echo "Something went wrong. Try again" && exit 1

(( ! $+commands[transcrypt] )) && echo "Transcrypt needs to be installed. Aborting..." && exit 1

if [[ -f ~/.gitconfig.private ]]; then
    PRIVATE_FILE=$HOME/.gitconfig.private
elif [[ -f $DOTFILES/config/git/.gitconfig.private ]]; then
    PRIVATE_FILE=$DOTFILES/config/git/.gitconfig.private
fi

[[ -z $PRIVATE_FILE ]] && e_info "No private gitconfig file found. Skipping..." && exit 0

e_info "Setting up transcrypt"

transcrypt

IS_DECRYPTED=$(command git config --get -f $DOTFILES/config/git/.gitconfig.private dotfiles.decrypted || command git config --get dotfiles.decrypted)

e_info "Decrypted: ${IS_DECRYPTED}"

if [[ $IS_DECRYPTED == true ]]; then
    e_info "Enabling private gitconfig file"
    command git config -f ~/.gitconfig.local include.path $PRIVATE_FILE
else
    e_error "Your repository seems to be encrypted. Try again"
    exit 1
fi

