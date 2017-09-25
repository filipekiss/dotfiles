scriptencoding utf-8
" See also config/vim/.vim/autoload/statusline.vim

set laststatus=2    " LAST WINDOW WILL ALWAYS HAVE A STATUS LINE
" set showtabline=2
" set tabline="%1T"

"------------------------------------------------------------------------------
" STATUS LINE CUSTOMIZATION
"------------------------------------------------------------------------------

set statusline= " Start statusline
set statusline+=%1* " Define the User1 to color our mode indicator"
set statusline+=\ %{statusline#getMode()} " Display currrent mode
set statusline+=\ %2* " Define the User2 to color our file prefix
set statusline+=\ %{statusline#fileprefix()}
set statusline+=%3* " Define the User3 to color the filename
set statusline+=%t " The current filename
set statusline+=\ %{statusline#modified()} " Modified indicator
set statusline+=\ %{statusline#readOnly()}\ %w " Read-only indicator
set statusline+=%*
set statusline+=%4*\ %= " Add space to align the rest at the right side of the statusline
set statusline+=%5*\ %y
set statusline+=%5*\ %{statusline#fileSize()}
set statusline+=%5*%{statusline#rhs()}
set statusline+=%*

execute 'highlight! User2 gui=none guifg=#84a598'
execute 'highlight! User3 gui=bold guifg=#488587'
execute 'highlight! User4 gui=none guifg=none'
execute 'highlight! User5 guifg=#6a9c6c'

augroup fckStatusLine
  autocmd!
  if exists('#TextChangedI')
    autocmd BufWinEnter,BufWritePost,FileWritePost,TextChanged,TextChangedI,WinEnter,InsertEnter,InsertLeave,CmdWinEnter,CmdWinLeave,ColorScheme * call statusline#getMode()
  else
    autocmd BufWinEnter,BufWritePost,FileWritePost,WinEnter,InsertEnter,InsertLeave,CmdWinEnter,CmdWinLeave,ColorScheme * call statusline#getMode()
  endif
augroup END

" augroup moonflyStatusLine
"     autocmd!
"     autocmd VimEnter,WinEnter,BufWinEnter,InsertLeave * call s:StatusLine()
"     autocmd WinLeave,FilterWritePost * call s:StatusLine()
"     autocmd InsertEnter * call s:StatusLine()
"     autocmd CursorMoved,CursorHold * call s:StatusLine()
"     if has('nvim')
"         autocmd TermOpen * call s:StatusLine()
"     endif
" augroup END
"
