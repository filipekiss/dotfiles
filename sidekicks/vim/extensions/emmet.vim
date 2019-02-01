" vim: ft=vim :tw=80 :sw=4

scriptencoding utf-8

if extensions#isInstalling()
    call extensions#loadExtension('https://github.com/mattn/emmet-vim')
    finish
endif

if extensions#isMissing('emmet-vim', 'emmet.vim')
    finish
endif

" Enable JSX support on JS files
let g:user_emmet_install_global = 0
let g:user_emmet_settings = {
            \  'javascript.jsx' : {
            \      'extends' : 'jsx',
            \  },
            \ 'typescript' : {
            \ 'extends': 'jsx',
            \ },
            \}

let s:emmetEnableFor = [
            \ 'html',
            \ 'css',
            \ 'javascript',
            \ 'php.html',
            \ ]

augroup EmmetConf
    autocmd!
    execute 'autocmd FileType ' . join(s:emmetEnableFor, ',') . ' EmmetInstall'
    execute 'autocmd FileType ' . join(s:emmetEnableFor, ',') . ' imap <buffer> <expr> <tab> emmet#expandAbbrIntelligent("\<tab>")'
augroup END

