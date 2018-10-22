" Custom folding for vim-plug diffs:
" Allows me to fold the logs on vim-plug, making it easier to skim through
" updated modules
setl foldmethod=expr
setl foldexpr=VimPlugDiffFold(v:lnum)


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
