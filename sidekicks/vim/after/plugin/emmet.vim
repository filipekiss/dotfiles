" Enable JSX support on JS files
let g:user_emmet_install_global = 0
let g:user_emmet_settings = {
            \  'javascript.jsx' : {
            \      'extends' : 'jsx',
            \  },
            \}

augroup EmmetConf
    autocmd FileType html,css,javascript,htmldjango,jinja2,twig EmmetInstall
    " autocmd FileType html,css,javascript,htmldjango,jinja2,twig imap <tab> <plug>(emmet-expand-abbr)
augroup END
