" Make these commonly mistyped commands still work
" ------------------------------------------------
command! WQ wq
command! Wq wq
command! Wqa wqa
command! W w
command! Q q

" Use :C to clear hlsearch
" ------------------------
command! C nohlsearch

" Delete the current file and clear the buffer
" --------------------------------------------
command! Del :call delete(@%) | bdelete!

" Force write readonly files using sudo
" -------------------------------------
command! WS w !sudo tee %

" Format Json using Python's Json Tool
" ------------------------------------
command! FormatJSON %!python -m json.tool

" Call :AddHR to add dashed lines below the current one
" -----------------------------------------------------
command! AddHR :call functions#TextHR()
