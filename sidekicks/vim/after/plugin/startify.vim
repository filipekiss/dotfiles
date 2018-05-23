if !exists(':Startify')
    finish
endif


if has('nvim')
    let g:startify_ascii = [
                \ '      .            .      ',
                \ "    .,;'           :,.    ",
                \ '  .,;;;,,.         ccc;.  ',
                \ ".;c::::,,,'        ccccc: ",
                \ '.::cc::,,,,,.      cccccc.',
                \ ".cccccc;;;;;;'     llllll.",
                \ '.cccccc.,;;;;;;.   llllll.',
                \ ".cccccc  ';;;;;;'  oooooo.",
                \ "'lllllc   .;;;;;;;.oooooo'",
                \ "'lllllc     ,::::::looooo'",
                \ "'llllll      .:::::lloddd'",
                \ '.looool       .;::coooodo.',
                \ "  .cool         'ccoooc.  ",
                \ '    .co          .:o:.    ',
                \ "      .           .'      ",
                \]
else
    let g:startify_ascii = [
                \ '     ________ ;;     ________',
                \ '    /********\;;;;  /********\',
                \ '    \********/;;;;;;\********/',
                \ '     |******|;;;;;;;;/*****/',
                \ '     |******|;;;;;;/*****/''',
                \ '    ;|******|;;;;/*****/'';',
                \ '  ;;;|******|;;/*****/'';;;;;',
                \ ';;;;;|******|/*****/'';;;;;;;;;',
                \ '  ;;;|***********/'';;;;;;;;;',
                \ '    ;|*********/'';;;;;;;;;',
                \ '     |*******/'';;;;;;;;;',
                \ '     |*****/'';;;;;;;;;',
                \ '     |***/'';;;;;;;;;',
                \ '     |*/''   ;;;;;;',
                \ '              ;;',
                \]
endif

let g:startify_custom_header = map(g:startify_ascii, '"     ".v:val')

let g:startify_skiplist = [
            \ 'COMMIT_EDITMSG',
            \ '^/tmp',
            \ escape(fnamemodify(resolve($VIMRUNTIME), ':p'), '\') .'doc',
            \ 'bundle/.*/doc',
            \ ]

let g:startify_padding_left = 5
let g:startify_relative_path = 1
let g:startify_fortune_use_unicode = 1
let g:startify_change_to_vcs_root = 1
let g:startify_update_oldfiles = 1
let g:startify_use_env = 0

hi! link StartifyHeader Normal
hi! link StartifyFile Directory
hi! link StartifyPath LineNr
hi! link StartifySlash StartifyPath
hi! link StartifyBracket StartifyPath
hi! link StartifyNumber Title

augroup StartifyCustom
    autocmd User Startified setlocal cursorline
    if has('nvim')
        autocmd TabNewEntered * Startify
    else
        autocmd VimEnter * let t:startify_new_tab = 1
        autocmd BufEnter *
                    \ if !exists('t:startify_new_tab') && empty(expand('%')) |
                    \   let t:startify_new_tab = 1 |
                    \   Startify |
                    \ endif
    endif
augroup END
