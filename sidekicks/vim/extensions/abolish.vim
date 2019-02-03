" vim: ft=vim :tw=80 :sw=4

scriptencoding utf-8

if extensions#isInstalling()
    call extensions#loadExtension('https://github.com/tpope/vim-abolish')
    finish
endif

if extensions#isMissing('vim-abolish', 'abolish.vim')
    finish
endif

function! abolish#after() abort
    Abolish ret{run,unr}    return
    Abolish delte{,e}       delete{}
    Abolish funciton{,ed,s} function{}
    Abolish seconde{,s}     second{,s}
    Abolish relatvie        relative
    Abolish haeder          header
    Abolish realted         related
    Abolish withouth without
endfunction
