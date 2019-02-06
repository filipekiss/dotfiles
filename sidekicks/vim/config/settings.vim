" ┏━━━━━━━━━━━━━━━━━━━━━━━┓
" ┃ Vim Specific Settings ┃
" ┠━━━━━━━━━━━━━━━━━━━━━━━┸━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
" ┃ These are some sensible settings for VIM. The reason I don't run them when ┃
" ┃ using NeoVim (which is what I use 99.99% of the time) it's because NeoVim  ┃
" ┃ set these automatically, so there's no need to do it manually              ┃
" ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
if !has('nvim')
    set nocompatible                                                      " https://superuser.com/questions/543317/what-is-compatible-mode-in-vim
    set autoindent                                                        " maintain indent of current line
    set backspace=indent,start,eol                                        " allow unrestricted backspacing in insert mode
    set display+=lastline                                                 " Display as much as possibe of a window's last line.
    set laststatus=2                                                      " Show status in all windows
    set ttyfast                                                           " Ensure fast terminal is reported
                                                                          " Ensure true-color works inside TMUX
    if &term =~# '^tmux'
        let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
        let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    endif
endif

" ┏━━━━━━━━━━━━━━━━━┓
" ┃ File Operations ┃
" ┗━━━━━━━━━━━━━━━━━┛
set updatecount=80                                                        " update swapfiles every 80 typed chars
if empty(glob($VIMHOME.'/tmp'))
    call system('mkdir -p '.$VIMHOME.'/tmp/{view,backup,swap,undo,info}') " Create $VIMHOME/tmp folders (undo, swap, etc)
endif
if exists('$SUDO_USER')
                                                                          " Don't create root owned files for…
    set nobackup nowritebackup backupcopy=no                              " …backup
    set noswapfile                                                        " …swap
    if has('persistent_undo')
        set noundofile                                                    " undo
    endif
    if has('nvim')
        set shada=                                                        " shada file (:h shada)
    else
        set viminfo=                                                      " viminfo file
    endif
else
    if has('nvim')
                                                                          " Configure where to write the ShaDa file
        execute "set shada=!,'100,<500,:10000,/10000,s10,h,n".$VIMHOME.'/tmp/main.shada'
        autocmd CursorHold,FocusGained,FocusLost * rshada|wshada          " read and write shada files
    else
                                                                          " Configure where to write viminfo file
        execute "set viminfo=!,'100,<500,:10000,/10000,s10,h,n".$VIMHOME.'/tmp/viminfo'
    endif
    let &backupdir=$VIMHOME.'/tmp/backup/'                                " keep backup files out of the way
    set backupdir+=.
    set backupcopy=yes
    let &directory=$VIMHOME.'/tmp/swap/'                                  " keep swap files out of the way
    set directory+=.
    if has('persistent_undo')
        let &undodir=$VIMHOME.'/tmp/undo'                                 " keep undo files out of the way
        set undodir+=.
        set undofile                                                      " actually use undo files
    endif
endif

" ┏━━━━┓
" ┃ UI ┃
" ┗━━━━┛
set number                                                                " Show line numbers by default
set lazyredraw                                                            " don't bother updating screen during macro playback
set showmatch                                                             " show matching bracket
set title                                                                 " show filename at the title of the window
set nocursorcolumn                                                        " do not highlight column
set cursorline                                                            " highlight current line

" ┏━━━━━━━━━━━━━━━━━━━━━┓
" ┃ Completion Settings ┃
" ┗━━━━━━━━━━━━━━━━━━━━━┛
set completeopt+=menuone                                                  " Show the popup if only one completion
set completeopt+=noinsert                                                 " Don't insert text for a match unless selected
set completeopt+=noselect                                                 " Don't auto-select the first match
set completeopt-=preview                                                  " Don't show extra info about the current completion

" ┏━━━━━━━━━━━┓
" ┃ Behaviors ┃
" ┗━━━━━━━━━━━┛
syntax sync minlines=256                                                  " start highlighting from 256 lines backwards
set synmaxcol=300                                                         " do not highlight very long lines
set encoding=utf-8                                                        " set enconding to utf-8 by default
set hidden                                                                " Allow bufs to be sent to background
set tildeop                                                               " Make tilde command behave like an operator.
set shortmess+=A                                                          " ignore annoying swapfile messages
set shortmess+=I                                                          " no splash screen
set shortmess+=O                                                          " file-read message overwrites previous
set shortmess+=T                                                          " truncate non-file messages in middle
set shortmess+=W                                                          " don't echo '[w]'/'[written]' when writing
set shortmess+=a                                                          " use abbreviations in messages eg. `[RO]` instead of `[readonly]`
set shortmess+=o                                                          " overwrite file-written messages
set shortmess+=t                                                          " truncate file messages at start
set shortmess+=c                                                          " hide annoying completion messages
if has('showcmd')
    set showcmd                                                           " extra info at end of command line
endif
set noshowmode                                                            " Don't Display the mode you're in. since it's already shown on the statusline
set diffopt+=vertical                                                     " Split diffs vertically
if has('nvim')
    set inccommand=nosplit                                                " incremental command live feedback
endif
if exists('&belloff')
    set belloff=all                                                       " never ring the bell for any reason
endif
set visualbell                                                            " No beeping.
set noerrorbells                                                          " No flashing.
set clipboard=unnamed                                                     " yank and paste with the system clipboard
set autoread                                                              " reload files when changed on disk, i.e. via `git checkout`
set scrolloff=5                                                           " Start scrolling slightly before the cursor reaches an edge
set sidescrolloff=5
set sidescroll=3                                                          " Scroll sideways a character at a time, rather than a screen at a time
" Shamelessly taken from https://github.com/jessfraz/.vim/blob/master/vimrc#L84
" Timeout on keystrokes but not mappings
set notimeout
set ttimeout
set ttimeoutlen=10
" More natural splitting
set splitbelow
set splitright
if has('virtualedit')
    set virtualedit=block                                                 " allow cursor to move where there is no text in visual block mode
endif
set whichwrap=b,h,l,s,<,>,[,],~                                           " allow <BS>/h/l/<Left>/<Right>/<Space>, ~ to cross line boundaries
set nostartofline                                                         " don't move the cursos after some commands. (:h 'startofline')

" ┏━━━━━━━━━━━━━┓
" ┃ Spell Check ┃
" ┗━━━━━━━━━━━━━┛
" https://robots.thoughtbot.com/opt-in-project-specific-vim-spell-checking-and-word-completion
set spelllang=en_us,pt_br                                                 " set en_US as primary language, pt_BR as secondary
" Set both spellfiles
execute 'set spellfile='.$VIMHOME.'/spell/en.utf-8.add'.','.$VIMHOME.'/spell/pt.utf-8.add'
set complete+=kspell                                                      " Use spell suggestions for completion
if has('syntax')
    set spellcapcheck=                                                    " don't check for capital letters at start of sentence
endif

" ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
" ┃ Selection Menu (when editing files, for example) ┃
" ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
set wildmenu                                                              " Enhanced mode command line completion
set wildmode=longest:full,list,full                                       " show a navigable menu for tab completion
" ────────────────────────────────────────────────────⇥  Ignore files that are…
set wildignore+=.hg,.git,.svn                                             " …from Version control
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg                            " …binary images
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest                          " …compiled object files
set wildignore+=*.spl                                                     " …compiled spelling word lists
set wildignore+=*.sw?                                                     " …Vim swap files
set wildignore+=*.DS_Store                                                " …OSX bullshit
set wildignore+=migrations                                                " …Laravel migrations
set wildignore+=*.pyc                                                     " …Python byte code
set wildignore+=*.orig                                                    " …merge resolution files
set wildignore+=*.rbc,*.rbo,*.gem                                         " …compiled stuff from Ruby
set wildignore+=*/vendor/*,*/.bundle/*,*/.sass-cache/*                    " …vendor files
set wildignore+=*/node_modules/*                                          " …JavaScript modules

" ┏━━━━━━━━━━━━━┓
" ┃ Text Format ┃
" ┗━━━━━━━━━━━━━┛
set expandtab                                                             " always use spaces instead of tabs
set tabstop=4                                                             " units per tab
set softtabstop=4                                                         " spaces per tab
set shiftround                                                            " always indent by multiple of shiftwidth
set shiftwidth=4                                                          " spaces per tab (when shifting)
set nowrap                                                                " no wrap
set textwidth=80                                                          " maximum text width
set smartindent                                                           " keep indentation when pressing <Enter> to add a new line
if has('folding')
    set foldtext=functions#NeatFoldText()                                 " Use custom folding function
    set foldmethod=indent                                                 " not as cool as syntax, but faster
    set foldlevelstart=99                                                 " start unfolded
endif
if !has('nvim') && (v:version > 703 || v:version == 703 && has('patch541'))
    set formatoptions+=j                                                  " remove comment leader when joining comment lines
endif
                                                                          " Formating options…
set formatoptions+=n                                                      " …smart auto-indenting inside numbered lists
set formatoptions+=r                                                      " …insert current comment leader when entering new-line in insert mode
set formatoptions+=1                                                      " …try to break lines before one letter words instead of after

" ┏━━━━━━━━━━━┓
" ┃ Searching ┃
" ┗━━━━━━━━━━━┛
set ignorecase smartcase                                                  " Ignore case in search.
set incsearch                                                             " Incremental search
set hlsearch                                                              " Highlight search matches

" ┏━━━━━━━━┓
" ┃ Visual ┃
" ┗━━━━━━━━┛
set list                                                                  " show trailing whitespace
set listchars=nbsp:░                                                      " Show non-breaking space - LIGHT SHADE (U+2591)
set listchars+=eol:¬                                                      " Show End of Line - NOT SIGN (U+00AC)
set listchars+=trail:·                                                    " Show trailing space - MID DOT (U+00B7)
set listchars=tab:▸\ ,                                                    " Show Tab characters - BLACK RIGH SMALL POINTING TRIANGLE (U+25B8)
set listchars+=precedes:«                                                 " Show Line extending indicator to the left - RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK (U+00AB)
set listchars+=extends:»                                                  " Show Line extending indicator to the right - LEFT-POINTING DOUBLE ANGLE QUOTATION MARK (U+00BB)
set nojoinspaces                                                          " don't autoinsert two spaces after '.', '?', '!' for join command
set concealcursor=n                                                       " Keep it concealed in normal mode, unconceal otherwise
set conceallevel=2                                                        " Conceal everything that is concealable

if has('windows')
    set fillchars=diff:⣿                                                  " deleted lines in diffs - BRAILLE PATTERN (U+28FF)
    set fillchars+=vert:┃                                                 " vertical splits - BOX DRAWINGS HEAVY VERTICAL (U+2503)
    set fillchars+=fold:─                                                 " filling for foldtext - BOX DRAWINGS LIGHT HORIZONTAL (U+2500)
endif

if has('linebreak')
    set linebreak                                                         " smart line wrapping (:h linebreak and :h breakat)
    let &showbreak='↳ '                                                   " DOWNWARDS ARROW WITH TIP RIGHTWARDS (U+21B3)
    set breakindent                                                       " indent wrapped lines to match start
    if exists('&breakindentopt')
        set breakindentopt=shift:2                                        " emphasize broken lines by indenting them
    endif
endif

" ┏━━━━━━━┓
" ┃ Mouse ┃
" ┗━━━━━━━┛
if has('mouse')
    set mouse=a                                                           " Enable mouse support
endif
