" vim: ft=vim :tw=80 :sw=4

scriptencoding utf-8

if extensions#isInstalling()
    call extensions#loadExtension('https://github.com/andymass/vim-matchup')
    finish
endif

if extensions#isMissing('vim-matchup', 'matchup.vim')
    finish
endif

" Enable experimental transmute module
" See https://github.com/andymass/vim-matchup#d1-parallel-transmutation
let g:matchup_transmute_enabled = 0

" Deferred highlight for performance reasons
let g:matchup_matchparen_deferred = 1

" Adjust highlight timeouts
let g:matchup_matchparen_timeout = 150
let g:matchup_matchparen_insert_timeout = 30

" Disable when in Visual Mode
" https://github.com/andymass/vim-matchup/commit/46852fcb0e490d4d67c9e8d1687307e4627fb26b
let g:matchup_matchparen_novisual = 1
