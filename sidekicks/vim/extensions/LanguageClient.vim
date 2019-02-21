" vim: ft=vim :tw=80 :sw=4

scriptencoding utf-8

if extensions#isInstalling()
    call extensions#loadExtension('https://github.com/autozimu/LanguageClient-neovim', {
                \ 'branch': 'next',
                \ 'do': 'bash install.sh',
                \ })
    finish
endif

if extensions#isMissing('LanguageClient-neovim', 'LanguageClient.vim')
    finish
endif


let g:LanguageClient_autoStart = 1
let g:LanguageClient_completionPreferTextEdit = 1
let g:LanguageClient_serverCommands = {}
let g:LanguageClient_diagnosticsEnable = 0

let s:LSP_CONFIG = {
      \'javascript-typescript-stdio': {
      \    'command': ['javascript-typescript-stdio'],
      \    'language': ['javascript', 'javascript.jsx', 'typescript', 'typescript.tsx']
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
  au User LanguageClientTextDocumentDidOpenPost nnoremap <buffer> K :call LanguageClient#textDocument_hover()<CR>
  au User LanguageClientTextDocumentDidOpenPost nnoremap <buffer> gd :call LanguageClient#textDocument_definition({'gotoCmd': 'vsplit'})<CR>
  au User LanguageClientTextDocumentDidOpenPost nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>
augroup END
