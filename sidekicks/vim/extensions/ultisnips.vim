" vim: ft=vim :tw=80 :sw=4
scriptencoding utf-8

if extensions#isInstalling()
    call extensions#loadExtension('https://github.com/SirVer/ultisnips')
    finish
endif

if extensions#isMissing('ultisnips', 'UltiSnips.vim')
    finish
endif

let g:UltiSnipsExpandTrigger = '<c-u>'
let g:UltiSnipsJumpForwardTrigger = '<Plug>(ultisnips_expand)'
let g:UltiSnipsJumpBackwardTrigger = '<Plug>(ultisnips_backward)'
let g:UltiSnipsListSnippets = '<Plug>(ultisnips_list)'
let g:UltiSnipsRemoveSelectModeMappings = 0
let g:UltiSnipsSnippetsDir=$VIMHOME . '/ultisnips'
let g:UltiSnipsSnippetDirectories=[
            \ $VIMHOME . '/ultisnips'
            \ ]
let g:UltiSnipsEditSplit='context'
