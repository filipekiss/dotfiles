scriptencoding utf-8

" ┏━━━━━━━━┓
" ┃ Leader ┃
" ┗━━━━━━━━┛
let g:mapleader="\<Space>"

" ┌━━━━━━━━━━━━━━━━━━━━━━┐
" │ Cursor/Text Movement │
" └━━━━━━━━━━━━━━━━━━━━━━┘

" Disable arrow keys (hardcore)
nmap  <up>    <nop>
nmap  <down>  <nop>
nmap  <left>  <nop>
nmap  <right> <nop>

" Make arrowkey do something usefull, resize the viewports accordingly
nnoremap <Left> :vertical resize +2<CR>
nnoremap <Right> :vertical resize -2<CR>
nnoremap <Up> :resize +2<CR>
nnoremap <Down> :resize -2<CR>

" Treat overflowing lines as having line breaks.
map <expr> j v:count ? 'j' : 'gj'
map <expr> k v:count ? 'k' : 'gk'

" Quickly move current line up/down, also accepts counts 2<leader>j
nnoremap <leader>j :<c-u>execute 'move +'. v:count1<cr>
nnoremap <leader>k :<c-u>execute 'move -1-'. v:count1<cr>

" Make `Y` behave like `C` and `D` (to the end of line)
nnoremap Y y$

" keep search matches in the middle of the window.
nmap n nzz
nmap N Nzz

" https://github.com/mhinz/vim-galore#dont-lose-selection-when-shifting-sidewards
xnoremap <  <gv
xnoremap >  >gv

" Don't move cursor when yanking stuff!
" See http://ddrscott.github.io/blog/2016/yank-without-jank/
vnoremap <expr>y "my\"" . v:register . "y`y"

" Add line to the beggining/end of the file. Add a mark o/O to make it easy to get back to where you
" were
nnoremap <Leader>O mOggO
nnoremap <Leader>o moGGo

" Easily move to beggining and end of the line
" https://github.com/shelldandy/dotfiles/blob/master/config/nvim/keys.vim#L114
nnoremap H ^
nnoremap L $

" ┌━━━━━━━━━━━━━━━━━━━━━━┐
" │ Insert mode mappings │
" └━━━━━━━━━━━━━━━━━━━━━━┘

" Make better undo chunks when writing long texts (prose) without exiting insert mode.
" :h i_CTRL-G_u
" https://twitter.com/vimgifs/status/913390282242232320
inoremap . .<c-g>u
inoremap ? ?<c-g>u
inoremap ! !<c-g>u
inoremap , ,<c-g>u

" Quickly return to normal mode
inoremap jj <ESC>
inoremap kk <ESC>

" Pressing up/down exits insert mode
inoremap <silent> <Up> <ESC>
inoremap <silent> <Down> <ESC>
" ┌━━━━━━━━━━━━━━━━━━━━━━━━┐
" │ Window/Buffer Mappings │
" └━━━━━━━━━━━━━━━━━━━━━━━━┘

" Use CTRL+[HJKL] to navigate between panes, instead of CTRL+W CTRL+[HJKL]
nnoremap <C-h> <C-w><C-h>
nnoremap <C-j> <C-w><C-j>
nnoremap <C-k> <C-w><C-k>
nnoremap <C-l> <C-w><C-l>

" Use | and _ to split windows (while preserving original behaviour of [count]bar and [count]_).
nnoremap <expr><silent> <Bar> v:count == 0 ? "<C-W>v<C-W><Right>" : ":<C-U>normal! 0".v:count."<Bar><CR>"
nnoremap <expr><silent> _     v:count == 0 ? "<C-W>s<C-W><Down>"  : ":<C-U>normal! ".v:count."_<CR>"

" Tab and Shift + Tab Circular buffer navigation
nnoremap <tab>   :bnext<CR>
nnoremap <S-tab> :bprevious<CR>

" ┌━━━━━━━━━━━━━━━━━━┐
" │ Utility Mappings │
" └━━━━━━━━━━━━━━━━━━┘

" If vim is in diff mode, close all buffers. Otherwhise, :quit
nnoremap <expr><silent> <leader>q &diff ? ":windo bd<CR>" : ":quit<CR>"

" https://github.com/mhinz/vim-galore#quickly-edit-your-macros
nnoremap <leader>m  :<c-u><c-r>='let @'. v:register .' = '. string(getreg(v:register))<cr><c-f><left>

" set text wrapping toggles
nnoremap <silent> <leader>tw :set invwrap<CR>:set wrap?<CR>

" Resolve possible vimrc symlinks
let $MYVIMRC = resolve(expand($MYVIMRC))
" easy way to edit $MYVIMRC
nnoremap <leader>ev :e $MYVIMRC<CR>

" open latest closed file
nnoremap <Leader>p :e#<CR>

" new file in current directory
nnoremap <Leader>n :e <C-R>=expand("%:p:h") . "/" <CR>

" make Q repeat the last macro
nnoremap Q @@

" For neovim terminal :term
if has('nvim')
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
endif

" Removes trailing spaces
nnoremap <leader>$ :call functions#Preserve("%s/\\s\\+$//e")<CR>
" Reindent File
nnoremap <leader>= :call functions#Preserve("normal gg=G")<CR>
" Join multiple empty lines leaving just one
nnoremap <leader><CR> :call functions#Preserve("g/^$/,/./-j")<CR>

" Allows you to visually select a section and then hit @ to run a macro on all lines
" https://medium.com/@schtoeffel/you-don-t-need-more-than-one-cursor-in-vim-2c44117d51db#.3dcn9prw6
xnoremap @ :<C-u>call functions#ExecuteMacroOverVisualRange()<CR>

" Make the dot command work as expected in visual mode (via
" https://www.reddit.com/r/vim/comments/3y2mgt/do_you_have_any_minor_customizationsmappings_that/cya0x04)
vnoremap . :norm.<CR>

" Don't overwrite register on paste
xnoremap p "_dP

" Save and Reload current file
nnoremap <Leader>R :w<CR> :source % \| echom "Reloaded " . expand("%") <CR>

" Make zC fold recursively
nnoremap zC :foldc! \| .,+1foldc!<CR>

" I use this to make a nice boxed header:
"
" Tranform this:
"
"    A Code Comment
"
" Into this:
"
"   ┌━━━━━━━━━━━━━━┐
"   │ Code Comment │
"   └━━━━━━━━━━━━━━┘
"
" Added <Plug> mapping so I can make this repeatable with repeat.vim
nnoremap <silent> <Plug>WrapInBox :normal! 0Wi│ A │"lyy"lp0wr└lv$r━$r┘^"lyyk"lPWr┌l$r┐<cr> :silent! call repeat#set("\<Plug>WrapInBox")<CR>
nmap <silent> <leader>box <Plug>WrapInBox
" of course, we can also unbox the comment
nnoremap <silent> <Plug>UnwrapFromBox :normal! 0W2x$xxjddkkdd<cr> :silent! call repeat#set("\<Plug>UnwrapFromBox")<CR>
nmap <silent> <leader>unbox <Plug>UnwrapFromBox
" and a rebox so I can edit the text inside (and I'm lazy)
nmap <silent> <leader>rebox <Plug>UnwrapFromBox<Plug>WrapInBox
