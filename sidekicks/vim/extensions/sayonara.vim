" vim: ft=vim :tw=80 :sw=4

scriptencoding utf-8

if extensions#isInstalling()
    call extensions#loadExtension('https://github.com/mhinz/vim-sayonara', {'on': 'Sayonara'})
    finish
endif

if has('macunix')
    nnoremap ∂ :Sayonara!<CR>
else
    nnoremap <M-d> :Sayonara!<CR>
endif


