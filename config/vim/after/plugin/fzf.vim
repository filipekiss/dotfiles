" FZF
let g:fzf_files_options = $FZF_CTRL_T_OPTS
let g:fzf_layout = { 'window': 'enew' }
let g:fzf_commits_log_options = substitute(system("git config --get alias.l | awk '{$1=\"\"; print $0;}'"), '\n\+$', '', '')
let g:fzf_history_dir = '~/.fzf-history'

command! Plugs call fzf#run({
  \ 'source':  map(sort(keys(g:plugs)), 'g:plug_home."/".v:val'),
  \ 'options': '--delimiter / --nth -1',
  \ 'sink':    'Explore'})

" See https://github.com/junegunn/fzf.vim/issues/488#issuecomment-346909854
" https://github.com/BurntSushi/ripgrep/issues/696
" Color seems to make FZF slow on vim, so disable it
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=never '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

command! -bang -nargs=* Rga
            \ call fzf#vim#grep(
            \ 'rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "!.git/*" --glob "!tags" --color "always" '.shellescape(<q-args>), 1,
            \   <bang>0 ? fzf#vim#with_preview('up:60%')
            \           : fzf#vim#with_preview('right:50%:hidden', '?'),
            \   <bang>0)

nnoremap <silent> <leader><leader> :Files<cr>
nnoremap <silent> <Leader>c :Colors<cr>
nnoremap <silent> <Leader>b :Buffers<cr>
nnoremap <silent> <Leader>h :Helptags<cr>
nnoremap <silent> <Leader>t :Tags<cr>

function! s:fzf_statusline()
  " Override statusline as you like
  setlocal statusline=%4*\ fzf\ %6*V:\ ctrl-v,\ H:\ ctrl-x
endfunction

autocmd! User FzfStatusLine call <SID>fzf_statusline()
