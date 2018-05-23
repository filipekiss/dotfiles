let s:root=expand($DOTFILES.'/sidekicks/vim')

if !empty(glob(s:root))
    let $VIMHOME=s:root
else
    let $VIMHOME=expand('~/.vim')
endif

let &runtimepath .= ','.$VIMHOME.','.$VIMHOME.'/after'

if !empty(glob($VIMHOME.'/autoload/main.vim'))
    call main#init()
endif
