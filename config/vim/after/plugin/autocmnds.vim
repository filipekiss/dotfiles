" Highlight custom TODO markers like IDEA and HACK
augroup ext_todo
  autocmd!
  autocmd Syntax * syntax match MyTodo /\v<(IDEA|HACK)/ containedin=.*Comment,vimCommentTitle
  highlight! def link MyTodo Todo
augroup END
