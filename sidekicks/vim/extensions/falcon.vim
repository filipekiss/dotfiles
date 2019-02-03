" vim: ft=vim :tw=80 :sw=4

scriptencoding utf-8

if extensions#isInstalling()
    call extensions#loadExtension('https://github.com/fenetikm/falcon')
    finish
endif

if extensions#isMissing('falcon')
    finish
endif

let g:falcon_background = 0
let g:falcon_inactive = 1
