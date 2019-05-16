" vim: ft=vim :tw=80 :sw=4
scriptencoding utf-8

let s:coc_extensions = [
            \ 'coc-css',
            \ 'coc-emmet',
            \ 'coc-highlight',
            \ 'coc-html',
            \ 'coc-json',
            \ 'coc-lists',
            \ 'coc-tsserver',
            \ 'coc-ultisnips',
            \ ]


function! s:coc_hook(info) abort
    call coc#util#install()
    call coc#util#install_extension(get(s:, 'coc_extensions', []))
endfunction

if extensions#isInstalling()
    call extensions#loadExtension('https://github.com/Shougo/neco-vim')
    call extensions#loadExtension('https://github.com/neoclide/coc-neco')
    call extensions#loadExtension('https://github.com/neoclide/coc.nvim', { 'tag': '*', 'do': function('s:coc_hook') })
    finish
endif

let g:coc_snippet_next='<c-j>'
let g:coc_snippet_prev='<c-k>'

function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <TAB>
            \ pumvisible() ? "\<C-n>" :
            \ <SID>check_back_space() ? "\<TAB>" :
            \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" Use <cr> for confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <silent><expr> <c-space> coc#refresh()


" Remap keys for gotos
" gd - go to definition of word under cursor
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K or gh for show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>
nnoremap <silent> gh :call <SID>show_documentation()<CR>

" List errors
nnoremap <silent> <leader>cl :<C-u>CocList locationlist<cr>

" list commands available in tsserver (and others)
nnoremap <silent> <leader>cc :<C-u>CocList commands<cr>

" restart when tsserver gets wonky
nnoremap <silent> <leader>cR :<C-u>CocRestart<CR>

" manage extensions
nnoremap <silent> <leader>cx :<C-u>CocList --normal extensions<cr>

" rename the current word in the cursor
nmap <leader>cr  <Plug>(coc-rename)

" Expand snippets
vmap <TAB> <Plug>(coc-snippets-select)

function! s:show_documentation()
    if (&filetype ==# 'vim' || &filetype ==# 'help')
        execute 'h '.expand('<cword>')
    else
        call CocAction('doHover')
    endif
endfunction

" Show signature help while editing
augroup COC_SIGNATURE
    autocmd!
    " Update signature help on jump placeholder
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
    autocmd CursorHold * silent call CocActionAsync('highlight')
augroup end
