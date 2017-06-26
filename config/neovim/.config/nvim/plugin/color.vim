if has('termguicolors')
  set termguicolors
end

set background=dark
let g:gruvbox_italic=1
let g:gruvbox_contrast_dark='hard'
let g:gruvbox_invert_selection=0

let s:hour = strftime('%H')
colorscheme nord

" I hate bold tabline
hi Tabline cterm=None gui=None
hi TablineFill cterm=None gui=None
hi TablineSel cterm=None gui=None

" Italics
hi Comment cterm=italic gui=italic

" Highlight long lines
hi OverLength ctermbg=red ctermfg=white guibg=#592929

if has('nvim') && g:colors_name ==# 'nord'
  highlight! link Error ErrorMsg
  highlight! link ALEError ErrorMsg
  highlight! link ALEErrorSign ErrorMsg
  highlight! link ALEWarning GitGutterChange
  highlight! link ALEWarningSign GitGutterChange
endif
