scriptencoding utf-8
" See also config/vim/.vim/autoload/statusline.vim

set laststatus=2    " LAST WINDOW WILL ALWAYS HAVE A STATUS LINE
" set showtabline=2
" set tabline="%1T"

"------------------------------------------------------------------------------
" STATUS LINE CUSTOMIZATION
"------------------------------------------------------------------------------

set statusline=
set statusline+=%0*
set statusline+=\ %{statusline#getMode()}
set statusline+=\ %<
set statusline+=\ %4*
set statusline+=\ %{statusline#fileprefix()}
set statusline+=%6*
set statusline+=%t
set statusline+=\ %{statusline#modified()}
set statusline+=\ %{statusline#readOnly()}\ %w
set statusline+=%#errormsg#
set statusline+=%*
set statusline+=%9*\ %=
set statusline+=%4*\ %y
set statusline+=%4*\ %{statusline#fileSize()}
set statusline+=%4*%{statusline#rhs()}
set statusline+=%*

execute 'highlight! User1 ctermfg=6 guifg=#88C0D0'
execute 'highlight! User2 ctermfg=8 gui=bold guifg=#434C5E'
execute 'highlight! User3 ctermfg=3 guifg=#EBCB8B guibg=Yellow'
execute 'highlight! User4 ctermfg=8 gui=bold guifg=#434C5E'

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
