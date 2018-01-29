(( ! $+functions[has_dotfiles_function] )) && [[ -e $HOME/.dotfiles/bin/dotfiles ]] && source $HOME/.dotfiles/bin/dotfiles "source"
(( ! $+functions[has_dotfiles_function] )) && echo "Something went wrong. Try again" && exit 1

function validate_stow() {
    if (( ! $+commands[stow] )); then
        e_info "Installing Stow"
        brew install stow
        hash -r
    fi
    # If Stow isn't installed by now, something exploded. We gots to quit!
    if (( ! $+commands[stow] )); then
        e_error "Stow should be installed. It isn't. Aborting."
        exit 1
    fi
}

function link_config() {
    IFS=$'\n'
    local files
    files=($(git --work-tree=$DOTFILES --git-dir=$DOTFILES/.git ls-files config/**/*))
    local stow_paths
    stow_paths=($(find $DOTFILES/config -maxdepth 1 -mindepth 1 -type d))
    local managed_folders
    managed_folders=($(find ~/.dotfiles/config/* -mindepth 1 -type d))
    unset IFS

    for file in $files; do
        file=${file#*/*/}
        backup_stuff $file
    done

    for stow_path in $stow_paths; do
        stow_path=${stow_path#$DOTFILES/config/}
        do_stow "${stow_path}"
    done;
}

function do_stow() {
    local stow_path
    stow_path="$1"
    if [[ -d "${DOTFILES}/config/${stow_path}" ]]; then
        e_info "Stowing ${YELLOW}${stow_path}${RESET}"
        stow --ignore ".DS_Store" --target="$HOME" --dir="${DOTFILES}/config" $stow_path
    fi
}

function prepare_folders() {
    # If backups are needed, this is where they'll go.
    DOTFILES_BACKUP_DIR="${DOTFILES}_backups/$(date "+%s")"
    backup=""
}

function show_backup_message() {
    # Alert if backups were made.
    if [[ "$backup" ]]; then
        e_info "Backups were moved to ${BLUE}~/${DOTFILES_BACKUP_DIR#$HOME/}${RESET}"
    fi
}

function backup_stuff() {
    local DEST
    local TARGET
    TARGET="$1"
    SOURCE="${HOME}/${TARGET}"
    REALPATH=${SOURCE:A}
    DEST="${DOTFILES_BACKUP_DIR}/${TARGET}"
    # Only continue if the file is not a symlink
    if [[ -f ${SOURCE} && ${SOURCE} == ${REALPATH} ]]; then
        e_info "Preparing ${TARGET}..."
        make_folder ${DOTFILES_BACKUP_DIR}
        if [[ ${TARGET} != $(basename ${TARGET}) ]]; then
            #this config file is located in a subfolder.
            make_folder ${DOTFILES_BACKUP_DIR}/${TARGET%/*}
        fi
        mv "${SOURCE}" "${DEST}" && e_success "${TARGET} backed up" && backup="1"
    fi
}

function make_folder() {
    local FOLDER
    FOLDER=$1
    [[ -e "${FOLDER}" ]] && return
    mkdir -p "${FOLDER}" && e_success "${FOLDER} created"
}

validate_stow
prepare_folders
link_config
show_backup_message
