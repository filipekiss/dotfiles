" vim: ft=vim :tw=80 :sw=4

scriptencoding utf-8

if extensions#isInstalling()
    call extensions#loadExtension('https://github.com/itchyny/lightline.vim')
    finish
endif

if extensions#isMissing('lightline.vim', 'lightline.vim')
    finish
endif


let g:lightline = get(g:, 'lightline', {})
let s:left_status = [
            \ ['mode'],
            \ [ 'filename', 'readonly', 'modified' ] ]

" Don't forget the right status bar is reversed: the first item is the last one
" to show up
let s:right_status =[
            \ [ 'lineinfo' ],
            \ [ 'fileformat', 'fileencoding', 'filetype' ] ,
            \ ['linter_ok', 'linter_warnings', 'linter_errors'],
            \ ]

let g:lightline.component_expand = {
            \ 'linter_warnings': 'ale#StatuslineLinterWarnings',
            \ 'linter_errors': 'ale#StatuslineLinterErrors',
            \ 'linter_ok': 'ale#StatuslineLinterOK',
            \ 'filename': 'FilenamePrefix',
            \ }

let g:lightline.component_type = {
            \ 'linter_warnings': 'warning',
            \ 'linter_errors': 'error',
\ }

let g:lightline.active = {
            \ 'left': s:left_status,
            \ 'right': s:right_status,
            \ }

let g:lightline.inactive = {
            \ 'left': [ [ 'filename' ] ],
            \ 'right': [ [ 'lineinfo' ],
            \            [ 'percent' ] ] }
let g:lightline.tabline = {
            \ 'left': [ [ 'tabs' ] ],
            \ 'right': [ [ 'close' ] ] }

function! FilenamePrefix()
    " Get path without filename
    let l:basename=expand('%:h')
    " Get custom prefix if set. If not, use current folder name
    let l:pathPrefix=get(b:, 'fkBufPrefix', fnamemodify(getcwd(), ':t'))
    " Format
    let l:dimmedColor='%#LighlineMiddle_normal#'
    let l:normalColor='%#LightlineLeft_normal_0_1#'
    " Get current filename
    let l:fileName=expand('%:t')

    " If l:pathPrefix is set and doesn't end in /, add a trailing /
    if l:pathPrefix !=? '' && l:pathPrefix !~? '\/$'
        let l:pathPrefix = l:pathPrefix . '/'
    endif
    " If it's a buffer with no filename, show <prefix>/NO NAME
    if l:fileName ==? ''
        return l:dimmedColor . l:pathPrefix . l:normalColor . 'NO NAME'
    endif
    " If we're at the project root, avoid showing the filename with the leading
    " dot (like ./README.md, for example), but still add the prefix if set
    if  l:basename ==? '.'
        return l:dimmedColor . l:pathPrefix . l:normalColor . l:fileName
    endif
    " The `substitute` make sure we show $HOME as ~.
    return  l:dimmedColor . l:pathPrefix . substitute(l:basename . '/', '\C^' . $HOME, '~', '') . l:normalColor . l:fileName
endfunction

if extensions#isInstalled('falcon')
    let g:lightline.colorscheme = 'falcon'
endif

augroup LightLineUpdate
    autocmd!
    autocmd BufEnter * call lightline#update()
augroup END
