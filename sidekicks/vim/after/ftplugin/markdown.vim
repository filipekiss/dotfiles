" Use <C-L> to auto correct current line
" Taken from https://castel.dev/post/lecture-notes-1/
setlocal spell
inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u

nnoremap <buffer><leader>p :call functions#openMarkdownPreview()<CR>
