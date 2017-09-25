if has('termguicolors')
  set termguicolors
end

" https://medium.com/@ericclifford/neovim-item2-truecolor-awesome-70b975516849
if has('nvim')
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
end

set background=dark
let g:gruvbox_italic=1
let g:gruvbox_contrast_dark='medium'
let g:gruvbox_invert_selection=0

let s:hour = strftime('%H')
syntax enable
filetype plugin indent on
colorscheme gruvbox

" I hate bold tabline
hi Tabline cterm=None gui=None
hi TablineFill cterm=None gui=None
hi TablineSel cterm=None gui=None

" Italics
hi Comment cterm=italic gui=italic

" Highlight long lines
hi OverLength ctermbg=red ctermfg=white guibg=#592929
