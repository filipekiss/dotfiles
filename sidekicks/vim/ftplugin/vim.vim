setl foldmethod=marker
setl conceallevel=2
hi! link fmBegin Ignore
hi! link fmEnd Ignore
au BufRead,BufNewFile * syn match fmBegin '"*-* {{{'  conceal  cchar=▸ containedin=vimLineComment
au BufRead,BufNewFile * syn match fmEnd '"*}}} -*'  conceal  cchar=◂ containedin=vimLineComment
