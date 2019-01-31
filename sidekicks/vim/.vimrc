" Set vim root location to my dotfiles vim folder
let s:root=expand($DOTFILES.'/sidekicks/vim')

if !empty(glob(s:root))
    " If the root above is not empty, set $VIMHOME to it
    let $VIMHOME=s:root
else
    " If it is empty, set $VIMHOME to default $HOME/.vim
    let $VIMHOME=expand('~/.vim')
endif

" Add $VIMHOME/after to runtimepath
" :h 'runtimepath'
let &runtimepath .= ','.$VIMHOME.','.$VIMHOME.'/after'

" If the file setup.vim exists in $VIMHOME/autoload/setup.vim,
" call the setup#init() function
if !empty(glob($VIMHOME.'/autoload/setup.vim'))
    call setup#init()
endif
