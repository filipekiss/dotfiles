" ┌━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┐
" │ Make these commonly mistyped commands still work │
" └━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┘
command! WQ wq
command! Wq wq
command! Wqa wqa
command! W w
command! Q q

" ┏━━━━━━━━━━━━━━━━━━━━━━━━━━┓
" ┃ Use :C to clear hlsearch ┃
" ┗━━━━━━━━━━━━━━━━━━━━━━━━━━┛
command! C nohlsearch

" ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
" ┃ Delete the current file and clear the buffer ┃
" ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
command! Del :call delete(@%) | bdelete!

" ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
" ┃ Force write readonly files using sudo ┃
" ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
command! WS w !sudo tee %

" ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
" ┃ Format Json using Python's Json Tool ┃
" ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
command! FormatJSON %!python -m json.tool

" ┌━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┐
" │ Edit Snippets for a give filetype │
" └━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┘
command! -bang -nargs=? EditSnippets :call functions#EditSnippets(<q-bang>, <q-args>)

" ┌━━━━━━━━━━━━━━━━━━━━━━━━━━━┐
" │ Add/edit extension to vim │
" └━━━━━━━━━━━━━━━━━━━━━━━━━━━┘
command! -bang -nargs=? EditExtension :call functions#EditExtension(<q-bang>, <q-args>)

" ┌━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┐
" │ Reload and install new extensions │
" └━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┘
command! ReloadExtensions :call extensions#reload()
