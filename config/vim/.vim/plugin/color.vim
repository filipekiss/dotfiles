if has('termguicolors')
  set termguicolors
end

set background=dark
let g:gruvbox_italic=1
let g:gruvbox_invert_selection=0

let s:hour = strftime('%H')
syntax enable
filetype plugin indent on

" I hate bold tabline
hi Tabline cterm=None gui=None
hi TablineFill cterm=None gui=None
hi TablineSel cterm=None gui=None

" Italics
hi Comment cterm=italic gui=italic

" Highlight long lines
hi OverLength ctermbg=red ctermfg=white guibg=#592929

" Adjust highlighting for MatchParen
hi! link MatchParen CursorLineNr

function! s:CheckColorScheme()

    let s:config_file = expand('~/.vimrc_bg')

    if filereadable(s:config_file)
        execute 'source ' . s:config_file
    else
        colorscheme gruvbox
    endif
endfunction

call s:CheckColorScheme()

autocmd FocusGained * call s:CheckColorScheme()
