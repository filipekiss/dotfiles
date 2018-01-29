let s:root=expand('~/.dotfiles/config/vim/.vim')
if !empty(glob(s:root))
    let $VIMHOME=s:root
    let &runtimepath .= ','.$VIMHOME.','.$VIMHOME.'/after'
    call main#init()
endif
