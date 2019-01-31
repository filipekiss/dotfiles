" vim: ft=vim :tw=80 :sw=4
scriptencoding utf-8

if extensions#isInstalling()
    call extensions#loadExtension('https://github.com/roxma/nvim-yarp')
    call extensions#loadExtension('https://github.com/ncm2/ncm2')
    call extensions#loadExtension('https://github.com/ncm2/ncm2-bufword')
    call extensions#loadExtension('https://github.com/ncm2/ncm2-path')
    call extensions#loadExtension('https://github.com/ncm2/ncm2-cssomni')
    call extensions#loadExtension('https://github.com/ncm2/ncm2-html-subscope')
    call extensions#loadExtension('https://github.com/ncm2/ncm2-markdown-subscope')
    call extensions#loadExtension('https://github.com/ncm2/ncm2-tagprefix')
    call extensions#loadExtension('https://github.com/wellle/tmux-complete.vim')
    if extensions#isInstalled('ultisnips', 'UltiSnips.vim')
        call extensions#loadExtension('https://github.com/ncm2/ncm2-ultisnips')
    endif
    finish
endif

if extensions#isMissing('ncm2', 'ncm2.vim', 'autoload')
    finish
endif


augroup NCM2_SETUP
    autocmd!
    autocmd BufEnter * call ncm2#enable_for_buffer()
    autocmd TextChangedI * call ncm2#auto_trigger()
    autocmd User Ncm2PopupOpen set completeopt=noinsert,menuone,noselect,preview
    autocmd User Ncm2PopupClose set completeopt=menuone
augroup END

if extensions#isInstalled('ultisnips', 'UltiSnips.vim')
    inoremap <silent> <expr> <CR> ((pumvisible() && empty(v:completed_item)) ?  "\<c-y>\<cr>" : (!empty(v:completed_item) ? ncm2_ultisnips#expand_or("\<cr>", 'n') : "\<CR>" ))
    imap <C-Space> <Plug>(ncm2_manual_trigger)

    imap <silent> <expr> <C-j> pumvisible() ? "\<C-n>" : "\<C-r>=UltiSnips#ExpandSnippetOrJump()\<cr>\<Plug>(ultisnip_expand_or_jump_result)"
    vnoremap <expr> <Plug>(ultisnip_expand_or_jump_result) g:ulti_expand_or_jump_res ? '' : "\<C-j>"
    inoremap <expr> <Plug>(ultisnip_expand_or_jump_result) g:ulti_expand_or_jump_res ? '' : "\<C-j>"
    xmap <C-j> <Plug>(ultisnips_expand)
    smap <C-j> <Plug>(ultisnips_expand)

    imap <silent> <expr> <C-k> pumvisible() ? "\<C-p>" : "\<C-r>=UltiSnips#JumpBackwards()\<cr>\<Plug>(ultisnips_backwards_result)"
    vnoremap <expr> <Plug>(ultisnips_backwards_result) g:ulti_jump_backwards_res ? '' : "\<C-k>"
    inoremap <expr> <Plug>(ultisnips_backwards_result) g:ulti_jump_backwards_res ? '' : "\<C-k>"
    xmap <C-k> <Plug>(ultisnips_backward)
    smap <C-k> <Plug>(ultisnips_backward)
else
    inoremap <silent> <expr> <CR> (pumvisible() ?  "\<c-y>\<cr>" : "\<CR>" )
    imap <C-Space> <Plug>(ncm2_manual_trigger)

    imap <silent> <expr> <C-j> pumvisible() ? "\<C-n>" : "\<C-j>"
    imap <silent> <expr> <C-k> pumvisible() ? "\<C-p>" : "\<C-k>"
endif
