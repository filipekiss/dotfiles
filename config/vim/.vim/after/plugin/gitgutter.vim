hi clear SignColumn
hi GitGutterAdd ctermbg=None guifg=green
hi GitGutterChange ctermbg=None guifg=orange
hi GitGutterDelete ctermbg=None guifg=red
hi GitGutterChangeDelete ctermbg=None guifg=DarkRed
let g:gitgutter_highlight_lines = 1
let g:gitgutter_realtime = 0
let g:gitgutter_eager = 0

if exists('&signcolumn')  " Avoid deprecation warning
  set signcolumn=yes
else
  let g:gitgutter_sign_column_always = 1
endif
