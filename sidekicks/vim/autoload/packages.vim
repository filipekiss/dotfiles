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

    " Autocomplete ---------------------------------------- {{{
    Plug 'https://github.com/autozimu/LanguageClient-neovim',
                \ {
                \ 'branch': 'next',
                \ 'do': 'bash ./install.sh'
                \ }                                                           " Language Server Clien
    Plug 'https://github.com/othree/csscomplete.vim'                          " Better CSS completion
    if has('nvim')
        Plug 'https://github.com/filipekiss/nvim-completion-manager'          " Auto complete pop-up
        Plug 'https://github.com/roxma/nvim-cm-tern',
                    \ packages#If(!executable('flow'),
                    \ { 'do': 'yarn global add tern && yarn' })               " TernJS auto-completion
        Plug 'https://github.com/Shougo/neco-vim', { 'for': ['vim'] }         " Vimscript completion source
    endif
    " }}} ---------------------------------------- Autocomplete

    " System Plugins ---------------------------------------- {{{
    Plug 'https://github.com/christoomey/vim-tmux-navigator'                  " Transparent navigation between vim buffers and tmux panes
    Plug 'https://github.com/tpope/vim-eunuch'                                " Utilities for file manipulation
    Plug 'https://github.com/duggiefresh/vim-easydir'                         " Easily handling of dirs inside vim
    Plug 'https://github.com/jaawerth/nrun.vim'                               " Node modules aware run and which commands with fallback to PATH
    Plug 'https://github.com/andymass/matchup.vim'                            " Better brackets/tags matching
    Plug 'https://github.com/Konfekt/FastFold'                                " Better performance on code folds
    Plug 'https://github.com/ludovicchabant/vim-gutentags'                    " CTags management
    Plug 'https://github.com/tpope/vim-repeat'                                " Make more commands repeatable with .
    Plug 'https://github.com/mhinz/vim-startify'                              " Show a nice start screen when you open vim but no files
    Plug 'https://github.com/kana/vim-textobj-user'
                \ | Plug 'https://github.com/kana/vim-textobj-line'           " Add a `whole line` text-object
    Plug 'https://github.com/direnv/direnv.vim'                               " Direnv support
    Plug 'https://github.com/majutsushi/tagbar', { 'on': ['Tagbar'] }         " Symbols navigator
    " }}} ---------------------------------------- System Plugins

    " Syntax and Language-related Plugins ---------------------------------------- {{{
    Plug 'https://github.com/ap/vim-css-color',
                \ {
                \ 'for': [
                \   'css',
                \   'less',
                \   'sass',
                \   'scss',
                \   'stylus']
                \ }                                                           " Show color on color declarations in CSS files
    Plug 'https://github.com/sheerun/vim-polyglot'                            " Multiple languages syntax
    Plug 'https://github.com/stephenway/postcss.vim', { 'for': ['css'] }      " More modern CSS syntax, don't use the one in Polyglot
    Plug 'https://github.com/davidhalter/jedi', { 'for': ['python'] }         " Python autocompletion
    Plug 'https://github.com/tpope/vim-commentary'                            " Toggle commentaries in multiple languages
    Plug 'https://github.com/Valloric/MatchTagAlways'                         " Highlight matching tags.
    Plug 'https://github.com/junegunn/vim-easy-align',
                \ { 'on': ['<Plug>(EasyAlign)'] }                             " Aesthetically pleasing align made easy
    Plug 'https://github.com/junegunn/vader.Vim'                              " Test suit for VimScript
    Plug 'https://github.com/w0rp/ale',
                \ { 'do': 'yarn global add prettier eslint' }                 " Linting for various languages
    Plug 'https://github.com/tpope/vim-sleuth'                                " Set expandtab, shiftwidth and more based on current buffer
    Plug 'https://github.com/tweekmonster/django-plus.vim'                    " Better Django Support
    " }}} ---------------------------------------- Syntax and Language-related Plugins

    " General Productivity plugins ---------------------------------------- {{{
    Plug 'https://github.com/editorconfig/editorconfig-vim'                   " Support for .editorconfig files
    Plug 'https://github.com/airblade/vim-gitgutter'                          " Add git marks to gutter
    Plug 'https://github.com/SirVer/ultisnips'                                " Snippets plugin
    Plug 'https://github.com/junegunn/fzf',
                \ { 'dir': '~/.fzf', 'do': 'yes \| ./install --all' }
                \ | Plug 'junegunn/fzf.vim'                                   " FZF Plugin for vim
    Plug 'https://github.com/junegunn/vim-peekaboo'                           " Register panel when using \" and @
    Plug 'https://github.com/kshenoy/vim-signature'                           " Better marks
    Plug 'https://github.com/mattn/emmet-vim',
                \ {
                \ 'for': [
                \   'html',
                \   'htmldjango',
                \   'jinja',
                \   'jinja2',
                \   'twig',
                \   'javascript.jsx'
                \ ] }                                                         " Generate markup from CSS-like strings
    Plug 'https://github.com/mbbill/undotree', { 'on': ['UndotreeToggle'] }   " File history using undofile
    Plug 'https://github.com/mhinz/vim-sayonara', { 'on': 'Sayonara' }        " Better way to close buffers
    Plug 'https://github.com/wellle/targets.vim'                              " More vim text object targets
    Plug 'https://github.com/kepbod/quick-scope'                              " Highlight matches on the same line to easily navigate with fF/tT
    Plug 'https://github.com/google/vim-searchindex'                          " Shows current match and total matches on statusbar when searching a pattern
    Plug 'https://github.com/bronson/vim-visual-star-search'                  " Start a star search (*) from visually selected text
    Plug 'https://github.com/nathanaelkane/vim-indent-guides'                 " Show indentation guides
    Plug 'https://github.com/tpope/tpope-vim-abolish'                         " This is basically auto-correct that works
    Plug 'https://github.com/justinmk/vim-sneak'                              " Like f, but use two characters instead
    Plug 'https://github.com/blueyed/vim-diminactive'                         " Dim inactive panes
    Plug 'https://github.com/tpope/vim-fugitive'                              " Add a few git commands and git support
    Plug 'https://github.com/machakann/vim-sandwich'                          " Better vim.surround
    Plug 'https://github.com/mjbrownie/swapit'                                " Swap between words from a specific list
    Plug 'https://github.com/luochen1990/rainbow'                             " Multicolored parens
    Plug 'https://github.com/gerw/vim-HiLinkTrace'                            " Really useful plugin that shows what highlight groups are linked to the current synStack
    Plug 'https://github.com/lifepillar/vim-colortemplate'                    " Vim Colorscheme generator
    " }}} ---------------------------------------- General Productivity plugins

    " ColorSchemes and cool stuff ---------------------------------------- {{{
    Plug 'https://github.com/morhetz/gruvbox'                                 " Gruvbox colorscheme
    Plug 'https://github.com/nightsense/vimspectr', {
          \ 'do':
          \ 'ln -s ' .$VIMHOME. '/plugged/vimspectr/shell ~/.vimspectr-shell'
          \ }                                                                 " VimSpectr theme collection
    " }}} ---------------------------------------- ColorSchemes and cool stuff

    " Writing Plugins ---------------------------------------- {{{
    Plug 'https://github.com/junegunn/goyo.vim', { 'on': ['Goyo']}            " Distraction free writing
    Plug 'https://github.com/junegunn/limelight.vim', { 'on': ['Limelight'] } " Context highlight
    Plug 'https://github.com/mzlogin/vim-markdown-toc'                        " Generate TOC for Markdown files
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
