if !exists(':LanguageClientStart')
    finish
endif

let g:LanguageClient_autoStart = 1
let g:LanguageClient_loggingLevel='DEBUG'
let g:LanguageClient_serverCommands = {}

if executable('flow') && executable('flow-language-server')
    let g:LanguageClient_serverCommands.javascript = ['flow-language-server', '--stdio']
    let g:LanguageClient_serverCommands['javascript.jsx'] = ['flow-language-server', '--stdio']
endif

if executable('pyls')
    let g:LanguageClient_serverCommands.python = ['pyls']
endif

augroup LanguageClientConfig
    autocmd!
    autocmd FileType javascript,javascript.jsx let g:LanguageClient_diagnosticsEnable = 0
augroup END

if !has('nvim')
    aug VIM_COMPLETION
        au!
        autocmd FileType javascript,javascript.jsx setlocal omnifunc=LanguageClient#complete
        autocmd FileType python setlocal omnifunc=LanguageClient#complete
        autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS noci
    aug END
endif
