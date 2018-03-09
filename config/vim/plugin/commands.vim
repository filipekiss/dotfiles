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
command! -range -nargs=? AddHR <line1>,<line2>call functions#TextHR(<f-args>)


" Commands to toggle ALE Fixers.
" See https://github.com/w0rp/ale/issues/1353
command! ALEDisableFixers       let g:ale_fix_on_save=0
command! ALEEnableFixers        let g:ale_fix_on_save=1
command! ALEDisableFixersBuffer let b:ale_fix_on_save=0
command! ALEEnableFixersBuffer  let b:ale_fix_on_save=0
command! ALEToggleFixers call functions#fckALEToggle('global')
command! ALEToggleFixersBuffer call functions#fckALEToggle('buffer')
