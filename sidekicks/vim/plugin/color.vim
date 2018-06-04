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

" Adjust highlighting for MatchParen
hi! link MatchParen CursorLineNr
