scriptencoding utf-8

" Used the idea from @ahmedelgabri, but instead of using a zero-width char just
" used no cchar at all. conceallevel=2 will hide the thext if no conceal char is
" passed (Also conceal stuff in comments)
"
" @TODO: Make this work for all filetypes
" @IDEA: Find a way to conceal commit urls to a short format, like
" ahmedelgabri/dotfiles/commit/41912
"
" Source: https://github.com/ahmedelgabri/dotfiles/commit/419121027c55a3b14940233cacf9e59c531fd66a

syn match githubUrlPrefix  /https\?\:\/\/github\.com\//  conceal containedin=vimString,vimLineComment
