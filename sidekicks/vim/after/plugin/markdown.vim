let g:goyo_height = '95%'
let g:goyo_width = '120'
nmap <Leader>g :Goyo<CR>

" https://github.com/junegunn/goyo.vim/wiki/Customization
function! s:goyo_enter()
    Limelight
    let g:isGoyoActive = 1
    set number
    set norelativenumber
    " Ensure TMUX enter a full-screen mode when calling Goyo from vim.
    " Hide status bar
    " Hide pane status
    " Zoom in current pane
    if exists('$TMUX')
        silent !tmux set status off
        silent !tmux set pane-border-status off
        silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
    endif
    let b:quitting = 0
    let b:quitting_bang = 0
    augroup goyoQuit
        autocmd QuitPre <buffer> let b:quitting = 1
    augroup END
    cabbrev <buffer> q! let b:quitting_bang = 1 <bar> q!
endfunction

function! s:goyo_leave()
    Limelight!
    unlet g:isGoyoActive
    set number
    set relativenumber
    " Restore TMUX settings
    " Show status bar
    " Show pane status
    " Zoom out current pane
    if exists('$TMUX')
        silent !tmux set status on
        silent !tmux set pane-border-status top
        silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
    endif
    " Quit Vim if this is the only remaining buffer
    if b:quitting && len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) == 1
        if b:quitting_bang
            silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
            qa!
        else
            silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
            qa
        endif
    endif
endfunction

augroup goyoToggle
    autocmd! User GoyoEnter call <SID>goyo_enter()
    autocmd! User GoyoLeave call <SID>goyo_leave()
augroup END
