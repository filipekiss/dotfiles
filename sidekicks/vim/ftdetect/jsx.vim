au! BufNewFile,BufRead *.js if &filetype !~ "jsx" | set filetype+=.jsx | endif
