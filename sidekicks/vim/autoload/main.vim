" vim: ft=vim
"
" +TODO: Try to find what's breaking when the plugins are not installed
" +BODY: I have to run vim a few times before it actually works

function! main#init() abort
    if has('nvim')
        let g:python_host_skip_check = 1
        let g:python3_host_skip_check = 1
        if executable('python2')
            let g:python_host_prog = '/usr/local/bin/python2'
        endif
        if executable('python3')
            let g:python3_host_prog = '/usr/local/bin/python3'
        endif
    endif
    call main#pluginSettings()
    call packages#init()
    call functions#SetupNCM()
    call main#pathSettings()
    call main#overrides()
endfunction

function! main#pluginSettings() abort
    " Enable highlight only when search for something
    let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
    " Use ,, to expand emmet abbreviation
    let g:user_emmet_leader_key=','
    " Use tmux reported events
    let g:diminactive_enable_focus = 1
    " Disable CSS from polyglot, we'll use the post-css syntax
    let g:polyglot_disabled = ['css']
    " Enable MatchTagAlways for the following types
    let g:mta_filetypes = {
                \ 'html' : 1,
                \ 'xhtml' : 1,
                \ 'xml' : 1,
                \ 'jinja' : 1,
                \ 'jinja2' : 1,
                \ 'twig' : 1,
                \ 'javascript' : 1,
                \ 'javascript.jsx' : 1,
                \}
    " Config indent guide lines
    let g:indent_guides_enable_on_vim_startup = 1
    let g:indent_guides_guide_size = 1
    let g:indent_guides_start_level = 2
    let g:indent_guides_exclude_filetypes = ['help', 'startify']
    " Enable rainbow parens by default
    let g:rainbow_active = 1

    " Disable .local.vim overrides for the following filetypes
    let g:fck_disable_override = ['help', 'startify', 'fzf', 'newtr']
endfunction

function! main#pathSettings() abort
    " Always have $HOME/.dotfiles on Vim path. No need for subfolders
    set path+=$HOME/.dotfiles/
    " Add current folder to path (and subfolders also)
    set path+=**
    set path+=.**
endfunction

function main#overrides(...) abort

    if !exists('g:fck_disable_override')
        let g:fck_disable_override = []
    endif

    if index(g:fck_disable_override, &filetype) != -1
        return
    endif

    let s:projectPath = get(a:, 1, $PWD)

    " Local overrides
    let s:vimrc_local = $HOME . '/.local.vim'
    if filereadable(s:vimrc_local)
        execute 'source ' . s:vimrc_local
        let b:fck_loaded_local_vim=s:vimrc_local
    endif

    " Project specific override
    let s:vimrc_project = s:projectPath . '/.local.vim'
    if filereadable(s:vimrc_project) && !exists('b:fck_loaded_project_vim')
        execute 'source ' . s:vimrc_project
        let b:fck_loaded_project_vim=1
    endif
endfunction
