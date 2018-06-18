" vim: set ts=4 sw=4 tw=0 et :
scriptencoding utf-8
set encoding=utf-8
set fileencoding=utf-8

if !has('nvim')
    set nocompatible
    set autoindent                 " maintain indent of current line
    set backspace=indent,start,eol " allow unrestricted backspacing in insert mode
    set display+=lastline          " Display as much as possibe of a window's last line.
    set laststatus=2
    set ttyfast
    if &term =~# '^tmux'
        let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
        let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    endif
endif

" Testing vim-sleuth.
" set expandtab    " always use spaces instead of tabs
" set tabstop=3    " spaces per tab
" set softtabstop=2
" set shiftround   " always indent by multiple of shiftwidth
" set shiftwidth=1 " spaces per tab (when shifting)
" set nowrap       " no wrap

set textwidth=80

augroup MyLongLinesHighlight
  autocmd! BufWinEnter,BufEnter ?* call functions#setOverLength()
  autocmd! OptionSet textwidth call functions#setOverLength()
augroup END

syntax sync minlines=256 " start highlighting from 256 lines backwards
set synmaxcol=300        " do not highlith very long lines

if has('showcmd')
    set showcmd          " extra info at end of command line
endif

set noshowmode           " Don't Display the mode you're in. since it's already shown on the statusline

set wildmenu
" show a navigable menu for tab completion
set wildmode=longest:full,list,full
" Ignore files that are…
set wildignore+=.hg,.git,.svn                                                " …from Version control
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg                               " …binary images
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest                             " …compiled object files
set wildignore+=*.spl                                                        " …compiled spelling word lists
set wildignore+=*.sw?                                                        " …Vim swap files
set wildignore+=*.DS_Store                                                   " …OSX bullshit
set wildignore+=migrations                                                   " …Laravel migrations
set wildignore+=*.pyc                                                        " …Python byte code
set wildignore+=*.orig                                                       " …Merge resolution files
set wildignore+=*.rbc,*.rbo,*.gem                                            " …compiled stuff from Ruby
set wildignore+=*/vendor/gems/*,*/vendor/cache/*,*/.bundle/*,*/.sass-cache/* " …vendor files
set wildignore+=*/node_modules/*                                             " JavaScript modules

" Diff Options
set diffopt+=vertical

" https://robots.thoughtbot.com/opt-in-project-specific-vim-spell-checking-and-word-completion
set spelllang=en_us,pt_br
execute 'set spellfile='.$VIMHOME.'/spell/en.utf-8.add'.','.$VIMHOME.'/spell/pt.utf-8.add'
if has('syntax')
    set spellcapcheck=                  " don't check for capital letters at start of sentence
endif

set complete+=kspell

" Disable unsafe commands.
" Only run autocommands owned by me
" http://andrew.stwrt.ca/posts/project-specific-vimrc/
set secure
" set exrc   " Enable use of directory-specific .vimrc

if has('virtualedit')
    set virtualedit=block               " allow cursor to move where there is no text in visual block mode
endif
set whichwrap=b,h,l,s,<,>,[,],~       " allow <BS>/h/l/<Left>/<Right>/<Space>, ~ to cross line boundaries

set completeopt+=menuone
set completeopt-=preview

" highlight current line in insert mode, don't bother otherwise
set nocursorcolumn       " do not highlight column
set cursorline

" Show line numbers by default
set number

set lazyredraw                        " don't bother updating screen during macro playback

" highlight matching [{()}]
set showmatch
set title

" More natural splitting
set splitbelow
set splitright

" Ignore case in search.
set ignorecase smartcase


" Shamelessly taken from https://github.com/jessfraz/.vim/blob/master/vimrc#L84
" Timeout on keystrokes but not mappings
set notimeout
set ttimeout
set ttimeoutlen=10

" Enable mouse support
if has('mouse')
    set mouse=a
endif

if !has('nvim') && (v:version > 703 || v:version == 703 && has('patch541'))
    set formatoptions+=j                " remove comment leader when joining comment lines
endif
set formatoptions+=n                  " smart auto-indenting inside numbered lists
set formatoptions+=r1

" No beeping.
set visualbell

" No flashing.
set noerrorbells

" reload files when changed on disk, i.e. via `git checkout`
set autoread

augroup MyAutoRead
    " Triger `autoread` when files changes on disk
    " https://unix.stackexchange.com/questions/149209/refresh-changed-content-of-file-opened-in-vim/383044#383044
    " https://vi.stackexchange.com/questions/13692/prevent-focusgained-autocmd-running-in-command-line-editing-mode
    autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != 'c' | checktime | endif
    " Notification after file change
    " https://vi.stackexchange.com/questions/13091/autocmd-event-for-autoread
    autocmd FileChangedShellPost *
                \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None
augroup END

" Start scrolling slightly before the cursor reaches an edge
set scrolloff=5
set sidescrolloff=5

" Scroll sideways a character at a time, rather than a screen at a time
set sidescroll=3

" yank and paste with the system clipboard
set clipboard=unnamed

" show trailing whitespace
set list
set listchars=nbsp:░
set listchars+=eol:¬
set listchars+=trail:·
if &expandtab
    set listchars+=tab:··
else
    set listchars+=tab:\ \ ,
endif

set listchars+=extends:»
set listchars+=precedes:«
set nojoinspaces    " don't autoinsert two spaces after '.', '?', '!' for join command
set concealcursor=n " Keep it concealed in normal mode, unconceal otherwise
set conceallevel=2  " Conceal everything that is concealable


if has('windows')
    set fillchars=diff:⣿,vert:┃              " BOX DRAWINGS HEAVY VERTICAL (U+2503, UTF-8: E2 94 83)
endif

if has('linebreak')
    set linebreak
    let &showbreak='↳ '                 " DOWNWARDS ARROW WITH TIP RIGHTWARDS (U+21B3, UTF-8: E2 86 B3)
    set breakindent                     " indent wrapped lines to match start
    if exists('&breakindentopt')
        set breakindentopt=shift:2        " emphasize broken lines by indenting them
    endif
endif


if exists('&belloff')
    set belloff=all                     " never ring the bell for any reason
endif

" show where you are
set ruler

set smartindent

set hidden

" Make tilde command behave like an operator.
set tildeop

set  shortmess+=A " ignore annoying swapfile messages
set  shortmess+=I " no splash screen
set  shortmess+=O " file-read message overwrites previous
set  shortmess+=T " truncate non-file messages in middle
set  shortmess+=W " don't echo "[w]"/"[written]" when writing
set  shortmess+=a " use abbreviations in messages eg. `[RO]` instead of `[readonly]`
set  shortmess+=o " overwrite file-written messages
set  shortmess+=t " truncate file messages at start
set  shortmess+=c " hide annoying completion messages

" Configure fold status text
if has('folding')
    highlight Folded ctermbg=254

    set foldtext=functions#NeatFoldText()
    set foldmethod=indent               " not as cool as syntax, but faster
    set foldlevelstart=99               " start unfolded
endif

if empty(glob($VIMHOME.'/tmp'))
    call system('mkdir -p '.$VIMHOME.'/tmp/{view,backup,swap,undo,info}')
endif

if has('mksession')
    let &viewdir=$VIMHOME.'/tmp/view'       " override ~/.vim/view default
    set viewoptions=cursor,folds        " save/restore just these (with `:{mk,load}view`)
endif

if exists('$SUDO_USER')
    set nobackup                        " don't create root-owned files
    set nowritebackup                   " don't create root-owned files
    set backupcopy=no
    set noswapfile
else
    let &backupdir=$VIMHOME.'/tmp/backup/'    " keep backup files out of the way
    set backupdir+=.
    set backupcopy=yes
    let &directory=$VIMHOME.'/tmp/swap/'    " keep swap files out of the way
    set directory+=.
endif

set updatecount=80                    " update swapfiles every 80 typed chars

if has('persistent_undo')
    if exists('$SUDO_USER')
        set noundofile                    " don't create root-owned files
    else
        let &undodir=$VIMHOME.'/tmp/undo'       " keep undo files out of the way
        set undodir+=.
        set undofile                      " actually use undo files
    endif
endif

if exists('$SUDO_USER')               " don't create root-owned files
    if has('nvim')
        set shada=
    else
        set viminfo=
    endif
else
    if has('nvim')
        execute "set shada=!,'100,<500,:10000,/10000,s10,h,n".$VIMHOME.'/tmp/main.shada'
        autocmd CursorHold,FocusGained,FocusLost * rshada|wshada
    else
        execute "set viminfo=!,'100,<500,:10000,/10000,s10,h,n".$VIMHOME.'/tmp/viminfo'
    endif
endif

if has('nvim')
    set inccommand=nosplit                " incremental command live feedback"
endif
