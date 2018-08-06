augroup MyAutoCmds
    autocmd!
    " Automatically make splits equal in size
    autocmd VimResized * wincmd =

    " Close preview buffer with q
    autocmd FileType * if functions#should_quit_on_q() | nmap <buffer> <silent>  q :q<cr> | endif

    " https://github.com/wincent/wincent/blob/c87f3e1e127784bb011b0352c9e239f9fde9854f/roles/dotfiles/files/.vim/plugin/autocmds.vim#L27-L40
    if has('mksession')
        " Save/restore folds and cursor position.
        autocmd BufWritePost,BufLeave,WinLeave ?* if functions#should_mkview() | call functions#mkview() | endif
        if has('folding')
            autocmd BufWinEnter ?* if functions#should_mkview() | silent! loadview | execute 'silent! ' . line('.') . 'foldopen!' | endif
        else
            autocmd BufWinEnter ?* if functions#should_mkview() | silent! loadview | endif
        endif
    elseif has('folding')
        " Like the autocmd described in `:h last-position-jump` but we add `:foldopen!`.
        autocmd BufWinEnter * if line("'\"") > 1 && line("'\"") <= line('$') | execute "normal! g`\"" | execute 'silent! ' . line("'\"") . 'foldopen!' | endif
    else
        autocmd BufWinEnter * if line("'\"") > 1 && line("'\"") <= line('$') | execute "normal! g`\"" | endif
    endif

    autocmd BufWritePre * if functions#should_strip_whitespace() | call functions#Preserve("%s/\\s\\+$//e") | endif
    " autocmd VimEnter,ColorScheme * call functions#change_iterm2_profile()
    autocmd InsertLeave,WinEnter * if functions#shouldDisplayLineNumbers() | set relativenumber | endif
    autocmd InsertEnter,WinLeave * if functions#shouldDisplayLineNumbers() | set norelativenumber | endif

    autocmd FileType crontab setlocal bkc=yes

    autocmd VimEnter * call functions#SetupNCM()

    " Update cd for current window
    autocmd BufEnter * call functions#SetProjectDir()
    autocmd BufEnter * call main#overrides()

    " Ensure Sleuth is run
    if exists(':Sleuth')
        autocmd BufEnter * :Sleuth
    endif

augroup END

aug completionCmd
    autocmd!
    autocmd InsertEnter * call ncm2#enable_for_buffer()
    if exists('g:plugs["emmet-vim"]')
        autocmd FileType html,htmldjango,jinja2 setl omnifunc=emmet#completeTag
    endif
aug END

augroup javascript_folding
    au!
    au FileType javascript setlocal foldmethod=syntax
augroup END

augroup fckCustomSyntax
    autocmd BufRead,BufNewFile * call syntax#concealGithubUrls()
augroup END
