(( ! $+functions[has_dotfiles_function] )) && [[ -e $HOME/.dotfiles/bin/dotfiles ]] && source $HOME/.dotfiles/bin/dotfiles "source"
(( ! $+functions[has_dotfiles_function] )) && echo "Something went wrong. Try again" && exit 1

DOWNLOAD_LOCATION=$DOTFILES/config/vim/.vim/spell

VIM_SPELL_FILES=(
    http://ftp.vim.org/pub/vim/runtime/spell/en.utf-8.spl
    http://ftp.vim.org/pub/vim/runtime/spell/en.utf-8.sug
    http://ftp.vim.org/pub/vim/runtime/spell/pt.utf-8.spl
)


download_lang() {
    local fileUrl="$1"
    local fileName="${fileUrl:t}"
    [[ -f ${DOWNLOAD_LOCATION}/${fileName} ]] && e_success "${fileName}${RESET} already exists. Skipping…" && return 0
    e_set_inline
    e_activity "Saving ${fileName} to ${DOWNLOAD_LOCATION}/${fileName}"
    curl -sS "${fileUrl}" -o "$DOWNLOAD_LOCATION/${fileName}" && (e_activity_end && e_success "${fileName}${RESET} downloaded")|| (e_activity_end && e_error "Error Downloading ${fileName}")
}


__cleanup() {
    unset -v VIM_SPELL_FILES
    unset -v download_lang
    unset -v __cleanup
}

for LANG ($VIM_SPELL_FILES) download_lang "$LANG"
__cleanup
