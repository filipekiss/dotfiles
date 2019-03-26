augroup MyAutoRead
    " autocmd! is used to clear the group and ensure we don't keep defining the
    " same command over and over again. See http://learnvimscriptthehardway.stevelosh.com/chapters/14.html
    " Triger `autoread` when files changes on disk
    autocmd!
    " https://unix.stackexchange.com/questions/149209/refresh-changed-content-of-file-opened-in-vim/383044#383044
    " https://vi.stackexchange.com/questions/13692/prevent-focusgained-autocmd-running-in-command-line-editing-mode
    autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != 'c' | checktime | endif
    " Notification after file change
    " https://vi.stackexchange.com/questions/13091/autocmd-event-for-autoread
    autocmd FileChangedShellPost *
                \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None
augroup END

augroup MyAutoCmds
    autocmd!
    " Automatically make splits equal in size
    autocmd VimResized * wincmd =

    " Close preview buffer with q
    autocmd FileType * if functions#should_quit_on_q() | nmap <buffer> <silent>  q :q<cr> | endif

    " Strip trailing whitespace when saving files.
    autocmd BufWritePre * if functions#should_strip_whitespace() | call functions#Preserve("%s/\\s\\+$//e") | endif
    " Decide if will show line number, relative line numbers or nothing
    autocmd InsertLeave,BufAdd * call functions#displayLineNumbers('n')
    autocmd InsertEnter * call functions#displayLineNumbers('i')

    " Enable backup for crontab files
    autocmd FileType crontab setlocal bkc=yes

    " Update cd for current window
    autocmd BufAdd,BufEnter * call functions#SetProjectDir()
    autocmd BufAdd,BufEnter * call setup#overrides()
augroup END

augroup javascript_folding
    au!
    au FileType javascript setlocal foldmethod=syntax
augroup END

" augroup fckCustomSyntax
"     autocmd BufRead,BufNewFile * call syntax#concealGithubUrls()
" augroup END
