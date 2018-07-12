" Restore Tab/S-Tab for buffer navigation
nmap <silent><buffer> <Tab> :bn<CR>
nmap <silent><buffer> <S-Tab> :bp<CR>
" Use { and } to navigate between topics on current wiki
nmap <silent><buffer> } <Plug>VimwikiNextLink
nmap <silent><buffer> { <Plug>VimwikiNextLink
" Delete current page
nmap <silent><buffer> <Leader>dd <Plug>VimwikiDeleteLink
" Rename current page
nmap <silent><buffer> <Leader>rr <Plug>VimwikiRenameLink
