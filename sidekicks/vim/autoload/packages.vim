" vim: set ts=8 sw=2 tw=80 et ft=vim fdm=markers
function! packages#If(cond, ...) abort
  let l:opts = get(a:000, 0, {})
  return a:cond ? l:opts : extend(l:opts, { 'on': [], 'for': [] })
endfunction

function! packages#init() abort
    call packages#installPlug()

    let s:VIM_PLUG_FOLDER = $VIMHOME . '/plugged'
    " Plugins to Install ---------------------------------------- {{{

    call plug#begin(s:VIM_PLUG_FOLDER)

    " Nvim Specific Plugins ---------------------------------------- {{{
    if has('nvim')
        Plug 'filipekiss/nvim-completion-manager'                   " Auto complete pop-up
        Plug 'roxma/nvim-cm-tern',
                    \ packages#If(!executable('flow'),
                    \ { 'do': 'yarn global add tern && yarn' })     " TernJS auto-completion
        Plug 'Shougo/neco-vim', { 'for': ['vim'] }                  " Vimscript completion source
    endif
    " }}} ---------------------------------------- Nvim Specific Plugins

    " System Plugins ---------------------------------------- {{{
    Plug 'christoomey/vim-tmux-navigator'                           " Transparent navigation between vim buffers and tmux panes
    Plug 'tpope/vim-eunuch'                                         " Utilities for file manipulation
    Plug 'duggiefresh/vim-easydir'                                  " Easily handling of dirs inside vim
    Plug 'jaawerth/nrun.vim'                                        " Node modules aware run and which commands with fallback to PATH
    Plug 'andymass/matchup.vim'                                     " Better brackets/tags matching
    Plug 'Konfekt/FastFold'                                         " Better performance on code folds
    Plug 'ludovicchabant/vim-gutentags'                             " CTags management
    Plug 'tpope/vim-repeat'                                         " Make more commands repeatable with .
    Plug 'mhinz/vim-startify'                                       " Show a nice start screen when you open vim but no files
    Plug 'kana/vim-textobj-user'
                \ | Plug 'kana/vim-textobj-line'                    " Add a `whole line` text-object
    Plug 'direnv/direnv.vim'                                        " Direnv support
    Plug 'majutsushi/tagbar', { 'on': ['Tagbar'] }                  " Symbols navigator
    " }}} ---------------------------------------- System Plugins

    " Syntax and Language-related Plugins ---------------------------------------- {{{
    Plug 'ap/vim-css-color',
                \ {
                \ 'for': [
                \   'css',
                \   'less',
                \   'sass',
                \   'scss',
                \   'stylus']
                \ }                                                 " Show color on color declarations in CSS files
    Plug 'sheerun/vim-polyglot'                                     " Multiple languages syntax
    Plug 'stephenway/postcss.vim', { 'for': ['css'] }               " More modern CSS syntax, don't use the one in Polyglot
    Plug 'davidhalter/jedi', { 'for': ['python'] }                  " Python autocompletion
    Plug 'tpope/vim-commentary'                                     " Toggle commentaries in multiple languages
    Plug 'Valloric/MatchTagAlways'                                  " Highlight matching tags.
    Plug 'junegunn/vim-easy-align', { 'on': ['<Plug>(EasyAlign)'] } " Aesthetically pleasing align made easy
    Plug 'junegunn/vader.Vim'                                       " Test suit for VimScript
    Plug 'w0rp/ale', { 'do': 'yarn global add prettier xo' }        " Linting for various languages
    Plug 'tpope/vim-sleuth'                                         " Set expandtab, shiftwidth and more based on current buffer
    " }}} ---------------------------------------- Syntax and Language-related Plugins

    " General Productivity plugins ---------------------------------------- {{{
    Plug 'editorconfig/editorconfig-vim'                            " Support for .editorconfig files
    Plug 'airblade/vim-gitgutter'                                   " Add git marks to gutter
    Plug 'SirVer/ultisnips'                                         " Snippets plugin
    Plug 'junegunn/fzf',
                \ { 'dir': '~/.fzf', 'do': 'yes \| ./install --all' }
                \ | Plug 'junegunn/fzf.vim'                         " FZF Plugin for vim
    Plug 'junegunn/vim-peekaboo'                                    " Register panel when using \" and @
    Plug 'kshenoy/vim-signature'                                    " Better marks
    Plug 'mattn/emmet-vim',
                \ {
                \ 'for': [
                \   'html',
                \   'htmldjango',
                \   'jinja',
                \   'jinja2',
                \   'twig',
                \   'javascript.jsx'
                \ ] }                                               " Generate markup from CSS-like strings
    Plug 'mbbill/undotree', { 'on': ['UndotreeToggle'] }            " File history using undofile
    Plug 'mhinz/vim-sayonara', { 'on': 'Sayonara' }                 " Better way to close buffers
    Plug 'wellle/targets.vim'                                       " More vim text object targets
    Plug 'kepbod/quick-scope'                                       " Highlight matches on the same line to easily navigate with fF/tT
    Plug 'google/vim-searchindex'                                   " Shows current match and total matches on statusbar when searching a pattern
    Plug 'bronson/vim-visual-star-search'                           " Start a star search (*) from visually selected text
    Plug 'nathanaelkane/vim-indent-guides'                          " Show indentation guides
    Plug 'tpope/tpope-vim-abolish'                                  " This is basically auto-correct that works
    Plug 'justinmk/vim-sneak'                                       " Like f, but use two characters instead
    Plug 'blueyed/vim-diminactive'                                  " Dim inactive panes
    Plug 'tpope/vim-fugitive'                                       " Add a few git commands and git support
    Plug 'machakann/vim-sandwich'                                   " Better vim.surround
    Plug 'mjbrownie/swapit'                                         " Swap between words from a specific list
    Plug 'luochen1990/rainbow'                                      " Multicolored parens
    let g:rainbow_active = 1                                        " Enable rainbow parens by default
    Plug 'gerw/vim-HiLinkTrace'                                     " Really useful plugin that shows what highlight groups are linked to the current synStack
    Plug 'lifepillar/vim-colortemplate'                             " Vim Colorscheme generator
    " }}} ---------------------------------------- General Productivity plugins

    " ColorSchemes and cool stuff ---------------------------------------- {{{
    Plug 'morhetz/gruvbox'                                          " Gruvbox colorscheme
    Plug 'dracula/vim', { 'as': 'dracula' }                         " Dracula colorscheme
    " }}} ---------------------------------------- ColorSchemes and cool stuff

    " Writing Plugins ---------------------------------------- {{{
    Plug 'junegunn/goyo.vim', { 'on': ['Goyo']}                     " Distraction free writing
    Plug 'junegunn/limelight.vim', { 'on': ['Limelight'] }          " Context highlight
    Plug 'mzlogin/vim-markdown-toc'                                 " Generate TOC for Markdown files
    " }}} ---------------------------------------- Writing Plugins

    call plug#end()

    " }}} ---------------------------------------- Plugins to Install
endfunction

function! packages#installPlug() abort
    " Automatic installation of vim-plug
    " https://github.com/junegunn/vim-plug/wiki/faq#automatic-installation
    let s:VIM_PLUG_PATH=expand($VIMHOME . '/autoload/plug.vim')
    if empty(glob(s:VIM_PLUG_PATH))
        execute 'silent !curl -fLo '.s:VIM_PLUG_PATH.' --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
        augroup MyVimPlug
            autocmd!
            autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
        augroup END
    endif
endfunction
