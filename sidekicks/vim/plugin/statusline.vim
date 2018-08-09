scriptencoding utf-8
" See also config/vim/.vim/autoload/statusline.vim

set laststatus=2    " LAST WINDOW WILL ALWAYS HAVE A STATUS LINE
" set showtabline=2
" set tabline="%1T"

"------------------------------------------------------------------------------
" STATUS LINE CUSTOMIZATION
"------------------------------------------------------------------------------
"

set statusline=%!StatusLine()

function! StatusLine()

    let l:sline='%1* %{statusline#getMode(mode())} %*' " Show current mode
    let l:sline.='%2* %{statusline#fileprefix()}%*' " Show path prefix to file
    let l:sline.='%3*%t' " Show file name
    let l:sline.='%{statusline#modified()}' " Modified indicator
    let l:sline.='%{statusline#readOnly()} %w%2*' " Read-only indicator (%w shows [Preview] if the window is a preview)
    let l:sline.='%=' " Add space to align the rest at the right side of the statusline
    let l:sline.=statusline#LinterStatus() " Show linting status
    let l:sline.='%2* %y ' " Show file type (e.g. [vim])
    let l:sline.=statusline#fileSize() " Show fileSize
    let l:sline.=statusline#rhs() " Show cursor position, new-line markers, line count…
    let l:sline.=' ' " End the statusline with a space

    return l:sline
endfunction


execute 'hi! link User1 fcksMode'
execute 'hi! link User2 fcksDim'
execute 'hi! link User3 fcksHighlight'


" This is here to ensure proper statusline redraw when changing modes
augroup statusline
    autocmd!
    autocmd InsertEnter,InsertLeave * call statusline#getMode(mode())
    autocmd ColorScheme * call statusline#updateColors()
augroup END
