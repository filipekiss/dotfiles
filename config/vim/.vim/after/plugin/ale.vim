scriptencoding utf-8

if !exists(':ALEInfo')
  finish
endif

let g:ale_javascript_eslint_suppress_eslintignore = 1
let g:ale_javascript_eslint_suppress_missing_config = 1
let g:ale_fix_on_save = 1
let g:ale_sign_error = '⨉'
let g:ale_sign_warning = g:ale_sign_error
let g:ale_sign_style_error  = '●'
let g:ale_sign_style_warning  = g:ale_sign_error
let g:ale_statusline_format = ['E•%d', 'W•%d', 'OK']
let g:ale_echo_msg_format = '[%linter%] %s'
let g:ale_javascript_prettier_use_local_config = 1
let g:ale_javascript_prettier_options = '--single-quote --no-editorconfig --print-width ' . &textwidth . ' --prose-wrap always --trailing-comma all --no-semi --config-precedence file-override'
let g:ale_javascript_xo_options = '--cwd=' . expand('%:p:h') " Ensure xo will run at the current file's folder

" Don't auto fix (format) files inside `node_modules`, `forks` directory or minified files, or jquery files :shrug:
let g:ale_linter_aliases = {
      \ 'mail': 'markdown',
      \ 'html': ['html', 'javascript', 'css']
      \}

let g:ale_linters = {
      \ 'javascript': ['xo', 'eslint'],
      \}

let g:ale_fixers = {
      \   'markdown': [
      \       'prettier',
      \   ],
      \   'javascript': [
      \       'prettier',
      \   ],
      \   'css': [
      \       'prettier',
      \   ],
      \   'scss': [
      \       'prettier',
      \   ],
      \}

" Don't auto fix (format) files inside `node_modules`, minified files and jquery (for legacy codebases)
let g:ale_pattern_options_enabled = 1
let g:ale_pattern_options = {
      \   '\.min\.(js\|css)$': {
      \       'ale_linters': [],
      \       'ale_fixers': []
      \   },
      \   'jquery.*': {
      \       'ale_linters': [],
      \       'ale_fixers': []
      \   },
      \   'node_modules/.*': {
      \       'ale_linters': [],
      \       'ale_fixers': []
      \   }
      \}
