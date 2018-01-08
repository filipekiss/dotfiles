" Matchup
if !exists(':MatchupReload')
    finish
endif

" Enable experimental transmute module
" See https://github.com/andymass/vim-matchup#d1-parallel-transmutation
let g:matchup_transmute_enabled = 1

" Deferred highlight for performance reasons
let g:matchup_matchparen_deferred = 1

" Adjust highlight timeouts
let g:matchup_matchparen_timeout = 150
let g:matchup_matchparen_insert_timeout = 30


