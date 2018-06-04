if has('termguicolors')
    set termguicolors
end

set background=dark
syntax enable
filetype plugin indent on

try
    colorscheme dracula
catch
    colorscheme ron
endtry

" Italics
hi! Comment cterm=italic gui=italic

" Highlight long lines
hi! link OverLength ErrorMsg

" Adjust highlighting for MatchParen
hi! link MatchParen CursorLineNr
