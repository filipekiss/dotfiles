" If phpactor is installed
if functions#plugExists('phpactor')
    " context-aware menu with all functions (ALT-m)
    if has('macunix')
        nnoremap µ :call phpactor#ContextMenu()<cr>
    elseif has('unix')
        nnoremap <m-m> :call phpactor#ContextMenu()<cr>
    endif

    nnoremap <buffer> gd :call phpactor#GotoDefinition()<CR>
    nnoremap <buffer> gr :call phpactor#FindReferences()<CR>

    " Extract method from selection
    vmap <buffer> <silent><Leader>em :<C-U>call phpactor#ExtractMethod()<CR>
    " extract variable
    vnoremap <buffer> <silent><Leader>ee :<C-U>call phpactor#ExtractExpression(v:true)<CR>
    nnoremap <buffer> <silent><Leader>ee :call phpactor#ExtractExpression(v:false)<CR>
    " extract interface
    nnoremap <buffer> <silent><Leader>rei :call phpactor#ClassInflect()<CR>
endif

