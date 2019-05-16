" vim: ft=vim :tw=80 :sw=4

scriptencoding utf-8

if extensions#isInstalling()
    call extensions#loadExtension('~/code/filipekiss/night-hawk/')
    finish
endif

let g:nighthawk_background = 0
let g:nighthawk_inactive = 1
