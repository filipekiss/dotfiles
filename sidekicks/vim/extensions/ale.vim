" vim: ft=vim :tw=80 :sw=4

scriptencoding utf-8

if extensions#isInstalling()
    call extensions#loadExtension('https://github.com/w0rp/ale')
    finish
endif

if extensions#isMissing('ale')
    finish
endif

function! s:prettierSettings(...)
    let s:prettierDefaultOptions = {
                \ 'tab-width': '4',
                \ 'single-quote': 1,
                \ 'use-tabs': 0,
                \ 'trailing-comma': 'es5',
                \ 'arrow-parens': 'always',
                \ 'no-bracket-spacing': 1,
                \ 'prose-wrap': 'always',
                \ 'no-editorconfig': 1,
                \ 'config-precedence': 'prefer-file',
                \ 'print-width': &textwidth
                \ }
    let a:newOptions = get(a:, 1, {})
    let s:prettierFinalOptions = extend(s:prettierDefaultOptions, a:newOptions)
    let s:cliOptions=[]
    for s:pKey in keys(s:prettierDefaultOptions)
        let s:optionValue=s:prettierDefaultOptions[s:pKey]
        if s:optionValue ==# '0'
            continue
        endif
        call add(s:cliOptions, '--'.s:pKey)
        if s:optionValue !=# '1'
            call add(s:cliOptions,  s:optionValue)
        endif
        let s:optionValue = ''
    endfor
    return join(s:cliOptions, ' ')
endfunction

let g:ale_fix_on_save = 1
let g:ale_lint_on_save = 1
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_enter = 0
let g:ale_lint_on_text_changed = 'never'
let g:ale_sign_error = '⨉'
let g:ale_open_list = 0
let g:ale_set_signs = 0
let g:ale_set_loclist = 1
let g:ale_set_quickfix = 0
let g:ale_sign_warning = g:ale_sign_error
let g:ale_sign_style_error  = '●'
let g:ale_sign_style_warning  = g:ale_sign_error
let g:ale_statusline_format = ['E•%d', 'W•%d', 'OK']
let g:ale_echo_msg_format = '%severity% %linter% -> [%code%] -> %s'
let g:ale_javascript_eslint_suppress_missing_config = 1
let g:ale_javascript_eslint_suppress_eslintignore = 1
let g:ale_javascript_eslint_use_global = 1
let g:ale_javascript_prettier_use_global = 1
let g:ale_javascript_prettier_use_local_config = 1
let g:ale_linters_explicit = 1

let g:ale_javascript_prettier_options = s:prettierSettings({'print-width': &textwidth})
augroup PrettierTW
    autocmd!
    autocmd OptionSet textwidth let g:ale_javascript_prettier_options = s:prettierSettings({'print-width': &textwidth})
augroup end

let g:ale_linters = {
            \ 'javascript': ['eslint', 'flow'],
            \ 'typescript': ['eslint', 'tsserver'],
            \ 'vim': ['vint'],
            \ 'markdown': ['alex'],
            \}

let g:ale_fixers = {
            \ 'markdown': [
            \   'prettier',
            \ ],
            \ 'javascript': [
            \   'prettier',
            \   'eslint',
            \ ],
            \ 'typescript': [
            \   'prettier',
            \ ],
            \ 'typescript.tsx': [
            \ 'prettier'
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
            \ 'graphql': ['prettier'],
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

function! ale#StatuslineLinterWarnings() abort
    let l:counts = ale#statusline#Count(bufnr(''))
    let l:all_errors = l:counts.error + l:counts.style_error
    let l:all_non_errors = l:counts.total - l:all_errors
    return l:counts.total == 0 ? '' : printf('%d %s', all_non_errors, g:ale_sign_warning)
endfunction

function! ale#StatuslineLinterErrors() abort
    let l:counts = ale#statusline#Count(bufnr(''))
    let l:all_errors = l:counts.error + l:counts.style_error
    let l:all_non_errors = l:counts.total - l:all_errors
    return l:counts.total == 0 ? '' : printf('%d %s', all_errors, g:ale_sign_error)
endfunction

function! ale#StatuslineLinterOK() abort
    let l:counts = ale#statusline#Count(bufnr(''))
    let l:all_errors = l:counts.error + l:counts.style_error
    let l:all_non_errors = l:counts.total - l:all_errors
    return l:counts.total == 0 ? '✓' : ''
endfunction

if extensions#isInstalled('lightline.vim', 'lightline.vim')
    augroup ALEStatus
        autocmd!
        autocmd User ALELintPre let g:ale_is_linting = 1 | call lightline#update()
        autocmd User ALELintPost let g:ale_is_linting = 0 | call lightline#update()
    augroup end
endif

" Commands to toggle ALE Fixers.
" See https://github.com/w0rp/ale/issues/1353
command! ALEDisableFixers       let g:ale_fix_on_save=0
command! ALEEnableFixers        let g:ale_fix_on_save=1
command! ALEDisableFixersBuffer let b:ale_fix_on_save=0
command! ALEEnableFixersBuffer  let b:ale_fix_on_save=0
