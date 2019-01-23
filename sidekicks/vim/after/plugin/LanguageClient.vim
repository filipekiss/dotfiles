if !exists(':LanguageClientStart')
  finish
endif

let g:LanguageClient_autoStart = 1
let g:LanguageClient_completionPreferTextEdit = 1
" let g:LanguageClient_hasSnippetSupport = 0
let g:LanguageClient_loggingLevel='DEBUG'
let g:LanguageClient_serverCommands = {}

let s:LSP_CONFIG = {
      \'javascript-typescript-stdio': {
      \    'command': ['javascript-typescript-stdio'],
      \    'language': ['javascript', 'javascript.jsx', 'typescript']
      \  },
      \}

for [lsp, config] in items(s:LSP_CONFIG)
  if get(config, 'condition', v:true) && executable(lsp)
    for lang in get(config, 'language')
      let g:LanguageClient_serverCommands[lang] = get(config, 'command')
    endfor
  endif
endfor


if !has('nvim')
  aug VIM_COMPLETION
    au!
    autocmd FileType javascript,javascript.jsx setlocal omnifunc=LanguageClient#complete
    autocmd FileType python setlocal omnifunc=LanguageClient#complete
    autocmd FileType rust setlocal omnifunc=LanguageClient#complete
    autocmd FileType ocaml,reason setlocal omnifunc=LanguageClient#complete
    autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS noci
  aug END
end

aug lang_client_mappings
  au!
  au User LanguageClientBufReadPost nnoremap <buffer> K :call LanguageClient#textDocument_hover()<CR>
  au User LanguageClientBufReadPost nnoremap <buffer> gd :call LanguageClient#textDocument_definition()<CR>
  au User LanguageClientBufReadPost nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>
augroup END
