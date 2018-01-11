function vim-gen-related() {
    [[ $PWD != $DOTFILES ]] && echo "Go to $DOTFILES first" && return 1
    local __vim_related_files=($(find config/vim/.vim -not -path \*plugged\* -not -path \*tmp\* -type f | sort))
    local __vim_related_files_count=($(find config/vim/.vim -not -path \*plugged\* -not -path \*tmp\* -type f | sort | wc -l))
    __vim_related_files=("\" "${^__vim_related_files})
    echo "\" Other Files ---------------------------------------- {{{" | tee /tmp/vim-related-files > /dev/null
    echo ${(iF)__vim_related_files} | tee -a /tmp/vim-related-files > /dev/null
    echo "\" }}} ---------------------------------------- /Other Files" | tee -a /tmp/vim-related-files > /dev/null
    # Backup current .vimrc in case anything goes wrong
    command cp -f $DOTFILES/config/vim/.vimrc $DOTFILES/config/vim/.vimrc-pre-insert-backup
    # Manipulate the copy instead of the current .vimrc
    sed -i.bak -e '/" Other Files/,/Other Files/d' $DOTFILES/config/vim/.vimrc-pre-insert-backup
    # Append the reference we created to the current file
    command cat /tmp/vim-related-files | tee -a $DOTFILES/config/vim/.vimrc-pre-insert-backup > /dev/null
    # Ensure Other Files is correctly in place (that means only 2 'Other Files' references)
    local __other_files_ref_count=$(grep -ir "Other Files" $DOTFILES/config/vim/.vimrc-pre-insert-backup | wc -l)
    [[ $__other_files_ref_count == 2 ]] && __is_valid_file="yes"
    if [[ ${__is_valid_file:-no} == "yes" ]]; then
    #     # Copy the updated .vimrc to $DOTFILES/config/vim/.vimrc
        command cp -f $DOTFILES/config/vim/.vimrc-pre-insert-backup $DOTFILES/config/vim/.vimrc
        echo "Updated vim related config files."
        echo "${__vim_related_files_count} files related added to .vimrc"
    fi
    # # Remove all the temporary files we created
    command rm -rf $DOTFILES/config/vim/.vimrc-pre-insert-backup
    command rm -rf $DOTFILES/config/vim/.vimrc-pre-insert-backup.bak
}
