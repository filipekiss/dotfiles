" vim: ft=vim :tw=80 :sw=4

scriptencoding utf-8

if extensions#isInstalling()
    call extensions#loadExtension('https://github.com/chaoren/vim-wordmotion')
    finish
endif

let g:wordmotion_spaces = '_'

" Make operator pending commands treat iW as vim would treat iw:
" function(SAMPLE_WOR|D) (| is the cursor position):
"
" viw -> function(SAMPLE_[WORD]) ([is the text that will be affected])
" viW -> function([SAMPLE_WORD])
onoremap <silent> iW :<C-U>normal! viw<CR>
xnoremap <silent> iW :<C-U>normal! viw<CR>
