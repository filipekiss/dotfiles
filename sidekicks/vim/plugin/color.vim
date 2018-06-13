if has('termguicolors')
    set termguicolors
end

set background=dark
syntax enable
filetype plugin indent on

try
    let g:gruvbox_italic=1
    let g:gruvbox_hls_cursor="blue"
    let g:gruvbox_invert_selection=0
    colorscheme gruvbox
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
