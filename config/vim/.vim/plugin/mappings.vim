" leader is space, only works with double quotes around it?!
let mapleader="\<Space>"

" stolen from https://bitbucket.org/sjl/dotfiles/src/tip/vim/vimrc
" Keep search matches in the middle of the window.
nnoremap n nzzzv
nnoremap N Nzzzv

" Movement
"-----------------
" highlight last inserted text
nnoremap gV `[v`]

" Treat overflowing lines as having line breaks.
map <expr> j v:count ? 'j' : 'gj'
map <expr> k v:count ? 'k' : 'gk'
" map j gj
" map k gk
"
" Make `Y` behave like `C` and `D` (to the end of line)
nnoremap Y y$

" Use Ctrl<hjkl> to move between buffers on the same tab
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l
" Use Alt<hjkl> to move between buffers on the same tab
if has('macunix')
    nnoremap ˙      <c-w>h
    nnoremap ∆      <c-w>j
    nnoremap ˚      <c-w>k
    nnoremap ¬      <c-w>l
elseif has('unix')
    nnoremap <M-h>      <c-w>h
    nnoremap <M-j>       <c-w>j
    nnoremap <M-k>       <c-w>k
    nnoremap <M-l>       <c-w>l
endif


" Disable arrow keys (hardcore)
nmap  <up>    <nop>
"imap <up>    <nop>
nmap  <down>  <nop>
"imap <down>  <nop>
nmap  <left>  <nop>
"imap <left>  <nop>
nmap  <right> <nop>
"imap <right> <nop>

" Make arrowkey do something usefull, resize the viewports accordingly
nnoremap <Left> :vertical resize -2<CR>
nnoremap <Right> :vertical resize +2<CR>
nnoremap <Up> :resize -2<CR>
nnoremap <Down> :resize +2<CR>

" Pressing up/down exits insert mode
inoremap <silent> <Up> <ESC>
inoremap <silent> <Down> <ESC>

nnoremap <silent> <leader>ev :e $MYVIMRC<CR>

nnoremap gb  :Gina browse :% --exact<CR> " Open current file on github.com
vnoremap gb  :Gina browse :% --exact<CR> " Make it work in Visual mode to open with highlighted linenumbers
nnoremap gs  :Gina status<CR>
vnoremap gs  :Gina status<CR>

" Quickly move current line, also accepts counts 2<leader>j
nnoremap <leader>j :<c-u>execute 'move +'. v:count1<cr>
nnoremap <leader>k :<c-u>execute 'move -1-'. v:count1<cr>

nnoremap <leader>q :quit<CR>

" https://github.com/mhinz/vim-galore#quickly-edit-your-macros
nnoremap <leader>m  :<c-u><c-r>='let @'. v:register .' = '. string(getreg(v:register))<cr><c-f><left>
" Quickly return to normal mode
inoremap jj <ESC>
inoremap kk <ESC>

nnoremap \ :Grepper -side -tool rg -query<SPACE>
" nnoremap \\ :Grepper -side -tool git -query<SPACE>
" nnoremap <silent> <leader>d :20Lex<CR>
nnoremap <silent> <leader>d :NERDTreeFind<CR>

if has('macunix')
    nnoremap ∂ :Sayonara!<CR>
elseif has('unix')
    nnoremap <M-d> :Sayonara!<CR>
endif
nnoremap <Leader><TAB> <C-w><C-w>
nnoremap <M-Tab> <C-^>
" set text wrapping toggles
nnoremap <silent> <leader>tw :set invwrap<CR>:set wrap?<CR>
nnoremap -- :UndotreeToggle<CR>
nnoremap <leader>= <C-w>t<C-w>K<CR>
nnoremap <leader>\ <C-w>t<C-w>H<CR>
" Use | and _ to split windows (while preserving original behaviour of [count]bar and [count]_).
nnoremap <expr><silent> <Bar> v:count == 0 ? "<C-W>v<C-W><Right>" : ":<C-U>normal! 0".v:count."<Bar><CR>"
nnoremap <expr><silent> _     v:count == 0 ? "<C-W>s<C-W><Down>"  : ":<C-U>normal! ".v:count."_<CR>"

" open prev file
nnoremap <Leader>p :e#<CR>

" https://github.com/mhinz/vim-galore#dont-lose-selection-when-shifting-sidewards
xnoremap <  <gv
xnoremap >  >gv

" new file in current directory
nnoremap <Leader>n :e <C-R>=expand("%:p:h") . "/" <CR>


" Tab and Shift + Tab Circular buffer navigation
nnoremap <tab>   :bnext<CR>
nnoremap <S-tab> :bprevious<CR>


" use tab to toggle folds
" nnoremap <Enter> za


" qq to record, Q to replay
nnoremap Q @q

" Make dot work in visual mode
vmap . :norm.<CR>

" For neovim terminal :term
if has('nvim')
  " nnoremap <leader>t  :vsplit +terminal<cr>
  " ignore when inisde FZF buffer
  tnoremap <expr> <esc> &filetype == 'fzf' ? "\<esc>" : "\<c-\>\<c-n>"
  if has('macunix')
    tnoremap ˙      <c-\><c-n><c-w>h
    tnoremap ∆      <c-\><c-n><c-w>j
    tnoremap ˚      <c-\><c-n><c-w>k
    tnoremap ¬      <c-\><c-n><c-w>l
  else
    tnoremap <a-h>      <c-\><c-n><c-w>h
    tnoremap <a-j>      <c-\><c-n><c-w>j
    tnoremap <a-k>      <c-\><c-n><c-w>k
    tnoremap <a-l>      <c-\><c-n><c-w>l
endif
  autocmd BufEnter term://* startinsert
endif

nnoremap <silent> <leader>z :call functions#ZoomToggle()<CR>
nmap <c-g> :call functions#SynStack()<CR>

vnoremap * :<c-u>call functions#VSetSearch()<cr>//<cr><c-o>
vnoremap # :<c-u>call functions#VSetSearch()<cr>??<cr><c-o>

map <leader>r :call functions#RenameFile()<cr>

nnoremap _$ :call functions#Preserve("%s/\\s\\+$//e")<CR>
nnoremap _= :call functions#Preserve("normal gg=G")<CR>

map <silent> <Leader>he :call functions#HtmlEscape()<CR>
map <silent> <Leader>hu :call functions#HtmlUnEscape()<CR>

" maintain the same shortcut as vim-gtfo becasue it's in my muscle memory.
nmap <silent> gof :call functions#OpenFileFolder()<CR>

" https://github.com/junegunn/vim-plug/issues/435
function! s:plug_doc()
  let l:name = matchstr(getline('.'), '^- \zs\S\+\ze:')
  if has_key(g:plugs, l:name)
    for l:doc in split(globpath(g:plugs[l:name].dir, 'doc/*.txt'), '\n')
      execute 'tabe' l:doc
    endfor
  endif
endfunction

augroup PlugExtra
  autocmd!
  autocmd FileType vim-plug nnoremap <buffer> <silent> H :call <sid>plug_doc()<cr>
augroup END


" Allows you to visually select a section and then hit @ to run a macro on all lines
" https://medium.com/@schtoeffel/you-don-t-need-more-than-one-cursor-in-vim-2c44117d51db#.3dcn9prw6
xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>

function! ExecuteMacroOverVisualRange()
  echo '@'.getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction

" Make the dot command work as expected in visual mode (via
" https://www.reddit.com/r/vim/comments/3y2mgt/do_you_have_any_minor_customizationsmappings_that/cya0x04)
vnoremap . :norm.<CR>

" Use <Leader>y and <Leader>p to use the 0 register automatically (Avoid yanking replaced line)
vnoremap <Leader>y "0y
vnoremap <Leader>p "0p


nnoremap <C-t> :Files<CR>
nnoremap <C-z> :Buffers<CR>
