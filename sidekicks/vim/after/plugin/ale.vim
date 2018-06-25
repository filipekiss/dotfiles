scriptencoding utf-8

if !exists(':ALEInfo')
    finish
endif

let g:ale_html_tidy_executable='/usr/local/bin/tidy'
let g:ale_javascript_eslint_suppress_eslintignore = 1
let g:ale_javascript_eslint_suppress_missing_config = 1
let g:ale_fix_on_save = 1
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_enter = 0
let g:ale_lint_on_text_changed = 'never'
let g:ale_sign_error = '⨉'
let g:ale_open_list = 0
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1
let g:ale_sign_warning = g:ale_sign_error
let g:ale_sign_style_error  = '●'
let g:ale_sign_style_warning  = g:ale_sign_error
let g:ale_statusline_format = ['E•%d', 'W•%d', 'OK']
let g:ale_echo_msg_format = '[%linter%] [%code%] %s'
let g:ale_javascript_prettier_use_local_config = 1
let g:ale_javascript_xo_use_global = 1
let g:ale_javascript_xo_options = '--prettier --space=4'
call functions#prettierSettings({'print-width': &textwidth})
au! OptionSet textwidth call functions#prettierSettings({'print-width': &textwidth})

let g:ale_linters_explicit = 1
let g:ale_linter_aliases = {
            \ 'mail': 'markdown'
            \}

let g:ale_linters = {
            \ 'html': ['tidy'],
            \ 'javascript': ['eslint', 'flow'],
            \}

let g:ale_fixers = {
            \ 'markdown': [
            \   'prettier',
            \ ],
            \ 'javascript': [
            \   'prettier',
            \ ],
            \ 'json': [
            \   'prettier',
            \ ],
            \ 'css': [
            \   'prettier',
            \ ],
            \ 'scss': [
            \   'prettier',
            \ ],
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
