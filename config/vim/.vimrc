let g:VIM_CONFIG_FOLDER=expand('~/.dotfiles/config/vim/.vim')
let &runtimepath .= ','.g:VIM_CONFIG_FOLDER.','.g:VIM_CONFIG_FOLDER.'/after'
execute 'source'.g:VIM_CONFIG_FOLDER.'/vimrc.vim'
