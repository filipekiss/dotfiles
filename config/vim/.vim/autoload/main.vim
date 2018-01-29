" vim: ft=vim

function! main#init() abort
    call packages#init()
    call main#pluginSettings()
    call main#setupCompletion()
    call main#pathSettings()
    call main#overrides()
endfunction

function! main#setupCompletion() abort
    if has('nvim')
        let g:UltiSnipsExpandTrigger		= '<Plug>(ultisnips_expand)'
        let g:UltiSnipsJumpForwardTrigger	= '<c-j>'
        let g:UltiSnipsJumpBackwardTrigger	= '<c-k>'
        let g:UltiSnipsRemoveSelectModeMappings = 0
        inoremap <silent> <c-u> <c-r>=cm#sources#ultisnips#trigger_or_popup("\<Plug>(ultisnips_expand)")<cr>
        inoremap <expr> <c-j> pumvisible() ? "\<C-n>" : "\<c-j>"
        inoremap <expr> <c-k> pumvisible() ? "\<C-p>" : "\<c-k>"
        xmap <c-u> <Plug>(ultisnips_expand)
        smap <c-u> <Plug>(ultisnips_expand)
    endif
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
endfunction

function! main#pathSettings() abort
    " Always have $HOME/.dotfiles on Vim path. No need for subfolders
    set path+=$HOME/.dotfiles/
    " Add current folder to path (and subfolders also)
    set path+=**
    set path+=.**
endfunction

function main#overrides() abort
    " Local overrides
    let s:vimrc_local = $HOME . '/.vimrc.local'
    if filereadable(s:vimrc_local)
        execute 'source ' . s:vimrc_local
    endif

    " Project specific override
    let s:vimrc_project = $PWD . '/.local.vim'
    if filereadable(s:vimrc_project)
        execute 'source ' . s:vimrc_project
    endif
endfunction
