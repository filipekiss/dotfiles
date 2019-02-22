" vim: ft=vim :tw=80 :sw=4

scriptencoding utf-8

if extensions#isInstalling()
    call extensions#loadExtension('https://github.com/chaoren/vim-wordmotion')
    finish
endif

let g:wordmotion_spaces = '_'
