" Vim Plug is always auto-installed from the latest version when opening NeoVim
" for the first time. This file is here only to keep the configuration organized
"
if extensions#isInstalling()
    finish
endif

" https://github.com/junegunn/vim-plug/issues/435
function! s:plug_doc()
    let l:name = matchstr(getline('.'), '^- \zs\S\+\ze:')
    if has_key(g:plugs, l:name)
        for l:doc in split(globpath(g:plugs[l:name].dir, 'doc/*.txt'), '\n')
            execute 'tabe' l:doc
        endfor
    endif
endfunction

function! VimPlugDiffFold(lnum)
    if getline(a:lnum) =~? '\v^\s*$'
        return '-1'
    endif

    if getline(a:lnum) =~? '\v^- .+:$'
        return '>1'
    endif

    if getline(a:lnum) =~? '\v^\s+(\*?|\|).*$'
        return '1'
    endif

    return '0'
endfunction

augroup PlugExtra
    autocmd!
    autocmd FileType vim-plug nnoremap <buffer> <silent> H :call <sid>plug_doc()<cr>
    autocmd FileType vim-plug setlocal foldmethod=expr
    autocmd FileType vim-plug setlocal foldexpr=VimPlugDiffFold(v:lnum)
augroup END


