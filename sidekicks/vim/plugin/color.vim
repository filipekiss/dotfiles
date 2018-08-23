if has('termguicolors')
    set termguicolors
end

" set background=dark
" syntax enable
" filetype plugin indent on

try
    colorscheme falcon
catch
    colorscheme ron
endtry

" Italics
hi! Comment cterm=italic gui=italic

" Adjust highlighting for MatchParen
hi! link MatchParen CursorLineNr

" Adjust Git Subject line setting
hi! link gitcommitSummary Normal
hi! link gitcommitOverflow ErrorMsg

" Spellcheck
hi! link SpellBad WarningMsg
