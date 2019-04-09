" vim: ft=vim :tw=80 :sw=4
scriptencoding utf-8

let s:coc_extensions = [
            \ 'coc-css',
            \ 'coc-emmet',
            \ 'coc-highlight',
            \ 'coc-html',
            \ 'coc-json',
            \ 'coc-omni',
            \ 'coc-snippets',
            \ 'coc-tag',
            \ 'coc-tsserver',
            \ ]

function! s:coc_hook(info) abort
    call coc#util#install()
    call coc#util#install_extension(get(s:, 'coc_extensions', []))
endfunction

if extensions#isInstalling()
    call extensions#loadExtension('https://github.com/neoclide/coc.nvim', { 'tag': '*', 'do': function('s:coc_hook') })
    call extensions#loadExtension('https://github.com/Shougo/neco-vim')
    call extensions#loadExtension('https://github.com/neoclide/coc-neco')
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
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K for show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

" Expand snippets
vmap <TAB> <Plug>(coc-snippets-select)

function! s:show_documentation()
    if &filetype ==# 'vim'
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
augroup end

function! coc#after() abort
    call coc#config('coc.preferences', {
                \ 'colorSupport': 1,
                \ })

    call coc#config('suggest', {
                \ 'noselect': 0,
                \ 'autoTrigger': 'always'
                \ })

    call coc#config('diagnostic', {
                \ 'errorSign': '×',
                \ 'warningSign': '●',
                \ 'infoSign': '!',
                \ 'hintSign': '!',
                \ 'displayByAle': 1
                \ })

    call coc#config('highlight', {
                \ 'colors': 1,
                \ 'disableLanguages': ['vim']
                \ })

    call coc#config('emmet', {
                \ 'includeLanguages': {
                    \ 'php': 'html'
                    \ }
                \ })
    call coc#config('snippets', {
                \ 'ultisnip.directories': ['ultisnips']
                \ })
endfunction
