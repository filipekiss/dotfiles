" Make these commonly mistyped commands still work
command! WQ wq
command! Wq wq
command! Wqa wqa
command! W w
command! Q q

" Use :C to clear hlsearch
command! C nohlsearch

" Delete the current file and clear the buffer
command! Del :call delete(@%) | bdelete!

" Force write readonly files using sudo
command! WS w !sudo tee %

command! FormatJSON %!python -m json.tool

command! ClearRegisters call functions#ClearRegisters()
