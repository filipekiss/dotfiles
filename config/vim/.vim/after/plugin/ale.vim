scriptencoding utf-8

if !exists(':ALELint')
    finish
endif

let g:ale_sign_error = 'E'
let g:ale_sign_warning = 'W'
let g:ale_statusline_format = ['E %d', 'W %d', 'ok']
let g:ale_echo_msg_format = '[%linter%] %s'

let g:ale_linters = {'javascript': ['eslint', 'flow']}
let g:ale_linter_aliases = {'reason': 'ocaml'}
let g:ale_javascript_eslint_executable = g:current_eslint_path
let g:ale_javascript_flow_executable = g:current_flow_path
