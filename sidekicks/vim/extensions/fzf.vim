" vim: ft=vim :tw=80 :sw=4

scriptencoding utf-8

if extensions#isInstalling()
    call extensions#loadExtension('https://github.com/junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' })
call extensions#loadExtension('https://github.com/junegunn/fzf.vim')
    finish
endif

if extensions#isMissing('fzf.vim', 'fzf.vim')
    finish
endif

let g:fzf_files_options = $FZF_CTRL_T_OPTS
let g:fzf_layout = { 'down': '~40%' }
let g:fzf_commits_log_options = substitute(system("git config --get alias.l | awk '{$1=\"\"; print $0;}'"), '\n\+$', '', '')
let g:fzf_history_dir = '~/.fzf-history'

command! Plugs call fzf#run({
            \ 'source':  map(sort(keys(g:plugs)), 'g:plug_home."/".v:val'),
            \ 'options': '--delimiter / --nth -1',
            \ 'sink':    'Explore'}
            \ )

command! IMaps call fzf#vim#maps('i')

nnoremap <silent><expr> <leader><leader> functions#isGit() ? ':GFiles<CR>' : ':Files<CR>'
nnoremap <silent> <Leader>c :Colors<cr>
nnoremap <silent> <Leader>b :Buffers<cr>
nnoremap <silent> <Leader>h :Helptags<cr>
nnoremap <silent> <Leader>t :Tags<cr>
nnoremap <silent> <Leader>r :BTags<cr>

function! s:fzf_statusline()
    " Override statusline as you like
    setlocal statusline=%4*\ fzf\ %6*V:\ ctrl-v,\ H:\ ctrl-x
endfunction

" Stolen from here
" https://github.com/ahmedelgabri/dotfiles/blob/f4423acc248e891f7b0314e193028c50ab2e8214/files/.vim/after/plugin/fzf.vim#L38-L45
augroup FzfStatus
    autocmd!
    autocmd User FzfStatusLine call <SID>fzf_statusline()
augroup end

function! FzfSpellSink(word)
    exe 'normal! "_ciw'.a:word
endfunction

function! FzfSpell()
    let suggestions = spellsuggest(expand('<cword>'))
return fzf#run({'source': suggestions, 'sink': function('FzfSpellSink'), 'down': 10 })
endfunction
nnoremap z= :call FzfSpell()<CR>
