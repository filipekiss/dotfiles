" vim: ft=vim

" Vim Plug Auto Install ---------------------------------------- {{{

" Automatic installation of vim-plug
" https://github.com/junegunn/vim-plug/wiki/faq#automatic-installation

if empty(glob(g:VIM_CONFIG_FOLDER.'/autoload/plug.vim'))
    silent !curl -fLo g:VIM_CONFIG_FOLDER.'/autoload/plug.vim' --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" }}} ---------------------------------------- Vim Plug Auto Install

" Plugins to Install ---------------------------------------- {{{

let s:VIM_PLUG_FOLDER = g:VIM_CONFIG_FOLDER . '/plugged'

call plug#begin(s:VIM_PLUG_FOLDER)

" Nvim Specific Plugins ---------------------------------------- {{{
if has('nvim')
    Plug 'roxma/nvim-completion-manager'        " Auto complete pop-up
    Plug 'roxma/nvim-cm-tern', { 'do': 'yarn' } " JavaScript and Node autocompletion source using Tern.js
    Plug 'Shougo/neco-vim', { 'for': ['vim'] }  " Vimscript completion source
endif
" }}} ---------------------------------------- Nvim Specific Plugins

" System Plugins ---------------------------------------- {{{
Plug 'christoomey/vim-tmux-navigator'        " Transparent navigation between vim buffers and tmux panes
Plug 'tpope/vim-eunuch'                      " Utilities for file manipulation
Plug 'duggiefresh/vim-easydir'               " Easily handling of dirs inside vim
Plug 'jaawerth/nrun.vim'                     " Node modules aware run and which commands with fallback to PATH
Plug 'andymass/matchup.vim'                  " Better brackets/tags matching
Plug 'Konfekt/FastFold'                      " Better performance on code folds
Plug 'ludovicchabant/vim-gutentags'          " CTags management
Plug 'tpope/vim-repeat'                      " Make more commands repeatable with .
Plug 'mhinz/vim-startify'                    " Show a nice start screen when you open vim but no files
Plug 'bronson/vim-visual-star-search'        " Start a star search (*) from visually selected text
Plug 'kana/vim-textobj-user'
            \ | Plug 'kana/vim-textobj-line' " Allows custom text objects \| Add a `whole line` text-object
" }}} ---------------------------------------- System Plugins

" Syntax and Language-related Plugins ---------------------------------------- {{{
Plug 'moll/vim-node', { 'for': ['javascript', 'javascript.jsx'] }                         " JS and Node productivity
Plug 'ap/vim-css-color', { 'for': ['css', 'less', 'sass', 'scss', 'stylus'] }             " Show color on color declarations in CSS files
Plug 'sheerun/vim-polyglot'                                                               " Multiple languages syntax
Plug 'stephenway/postcss.vim', { 'for': ['css'] }                                         " More modern CSS syntax, don't use the one in Polyglot
Plug 'davidhalter/jedi', { 'for': ['python'] }                                            " Python autocompletion
Plug 'tpope/vim-commentary'                                                               " Toggle commentaries in multiple languages
Plug 'Valloric/MatchTagAlways'                                                            " Highlight matching tags.
Plug 'junegunn/vim-easy-align', { 'on': ['<Plug>(EasyAlign)'] }                           " Aesthetically pleasing align made easy
Plug 'junegunn/vader.Vim'                                                                 " Test suit for VimScript
Plug 'sbdchd/neoformat', { 'on': 'Neoformat', 'do': 'yarn global add prettier stylefmt' } " Code formatter
" }}} ---------------------------------------- Syntax and Language-related Plugins

" General Productivity plugins ---------------------------------------- {{{
Plug 'editorconfig/editorconfig-vim'                                   " Support for .editorconfig files
Plug 'AndrewRadev/splitjoin.Vim'                                       " use gS and gJ to split/join syntax aware code lines
Plug 'airblade/vim-gitgutter'                                          " Add git marks to gutter
Plug 'SirVer/ultisnips'                                                " Snippets plugin
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes \| ./install --all' }
            \ | Plug 'junegunn/fzf.vim'                                " FZF Plugin for vim
Plug 'junegunn/vim-peekaboo'                                           " Register panel when using \" and @
Plug 'kshenoy/vim-signature'                                           " Better marks
Plug 'mattn/emmet-vim', {
            \ 'for': [
            \ 'html',
            \ 'htmldjango',
            \ 'jinja',
            \ 'jinja2',
            \ 'twig',
            \ 'javascript.jsx'
            \ ] }                                                      " Generate markup from CSS-like strings
Plug 'mbbill/undotree', { 'on': ['UndotreeToggle'] }                   " File history using undofile
Plug 'mhinz/vim-sayonara', { 'on': 'Sayonara' }                        " Better way to close buffers
Plug 'wellle/targets.vim'                                              " More vim text object targets
Plug 'kepbod/quick-scope'                                              " Highlight matches on the same line to easily navigate with fF/tT
Plug 'google/vim-searchindex'                                          " Shows current match and total matches on statusbar when searching a pattern
Plug 'nathanaelkane/vim-indent-guides'                                 " Show indentation guides
Plug 'tpope/tpope-vim-abolish'                                         " This is basically auto-correct that works
Plug 'justinmk/vim-sneak'                                              " Like f, but use two characters instead
Plug 'blueyed/vim-diminactive'                                         " Dim inactive panes
Plug 'tpope/vim-fugitive'                                              " Add a few git commands and git support
Plug 'machakann/vim-sandwich'                                          " Better vim.surround
Plug 'mjbrownie/swapit'                                                " Swap between words from a specific list
" }}} ---------------------------------------- General Productivity plugins

" ColorSchemes and cool stuff ---------------------------------------- {{{
Plug 'morhetz/gruvbox'       " Gruvbox colorscheme
Plug 'wakatime/vim-wakatime' " Time tracker
Plug 'dracula/vim'           " Dracula colorscheme
" }}} ---------------------------------------- ColorSchemes and cool stuff

" Writing Plugins ---------------------------------------- {{{
Plug 'junegunn/goyo.vim', { 'on': ['Goyo']}            " Distraction free writing
Plug 'junegunn/limelight.vim', { 'on': ['Limelight'] } " Context highlight
" }}} ---------------------------------------- Writing Plugins


call plug#end()

" }}} ---------------------------------------- Plugins to Install

" Plugin Settings ---------------------------------------- {{{
" Enable highlight only when search for something
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

" Use ,, to expand emmet abbreviation
let g:user_emmet_leader_key=','

" Use tmux reported events
let g:diminactive_enable_focus = 1

" Disable CSS from polyglot, we'll use the post-css syntax
let g:polyglot_disabled = ['css']

"
let g:mta_filetypes = {
            \ 'html' : 1,
            \ 'xhtml' : 1,
            \ 'xml' : 1,
            \ 'jinja' : 1,
            \ 'jinja2' : 1,
            \ 'twig' : 1,
            \ 'javascript' : 1,
            \ 'javascript.jsx' : 1,
            \}
" }}} ---------------------------------------- Plugin Settings

" NCM + UltiSnips ---------------------------------------- {{{

if has('nvim')
    let g:UltiSnipsExpandTrigger		= "<Plug>(ultisnips_expand)"
    let g:UltiSnipsJumpForwardTrigger	= "<c-j>"
    let g:UltiSnipsJumpBackwardTrigger	= "<c-k>"
    let g:UltiSnipsRemoveSelectModeMappings = 0
    inoremap <silent> <c-u> <c-r>=cm#sources#ultisnips#trigger_or_popup("\<Plug>(ultisnips_expand)")<cr>
    inoremap <expr> <c-j> pumvisible() ? "\<C-n>" : "\<c-j>"
    inoremap <expr> <c-k> pumvisible() ? "\<C-p>" : "\<c-k>"
    xmap <c-u> <Plug>(ultisnips_expand)
    smap <c-u> <Plug>(ultisnips_expand)
endif

" }}} ---------------------------------------- NCM + UltiSnips

" Path settings ---------------------------------------- {{{

" Always have $HOME/.dotfiles on Vim path. No need for subfolders
set path+=$HOME/.dotfiles/
" Add current folder to path (and subfolders also)
set path+=**
set path+=.**

" }}} ---------------------------------------- Path settings

" Overrides ---------------------------------------- {{{

" Local overrides
let s:vimrc_local = $HOME . '/.vimrc.local'
if filereadable(s:vimrc_local)
    execute 'source ' . s:vimrc_local
endif

" Project specific override
let s:vimrc_project = $PWD . '/.local.vim'
if filereadable(s:vimrc_project)
    execute 'source ' . s:vimrc_project
endif

" }}} ---------------------------------------- Overrides

" Other Files ---------------------------------------- {{{
" config/vim/.vim/after/ftplugin/javascript_swapit.vim
" config/vim/.vim/after/ftplugin/sh_swapit.vim
" config/vim/.vim/after/plugin/UltiSnips.vim
" config/vim/.vim/after/plugin/UndoTree.vim
" config/vim/.vim/after/plugin/abolish.vim
" config/vim/.vim/after/plugin/auto-pairs.vim
" config/vim/.vim/after/plugin/cm.vim
" config/vim/.vim/after/plugin/commentray.vim
" config/vim/.vim/after/plugin/easy_align.vim
" config/vim/.vim/after/plugin/editorconfig.vim
" config/vim/.vim/after/plugin/fzf.vim
" config/vim/.vim/after/plugin/gista.vim
" config/vim/.vim/after/plugin/gitgutter.vim
" config/vim/.vim/after/plugin/grepper.vim
" config/vim/.vim/after/plugin/guttentags.vim
" config/vim/.vim/after/plugin/markdown.vim
" config/vim/.vim/after/plugin/matchup.vim
" config/vim/.vim/after/plugin/startify.vim
" config/vim/.vim/autoload/.gitignore
" config/vim/.vim/autoload/functions.vim
" config/vim/.vim/autoload/plug.vim
" config/vim/.vim/autoload/statusline.vim
" config/vim/.vim/ftdetect/json.vim
" config/vim/.vim/ftdetect/markdown.vim
" config/vim/.vim/ftdetect/ruby.vim
" config/vim/.vim/ftdetect/tags.vim
" config/vim/.vim/ftdetect/zsh.vim
" config/vim/.vim/ftplugin/fzf.vim
" config/vim/.vim/ftplugin/gitcommit.vim
" config/vim/.vim/ftplugin/gitrebase.vim
" config/vim/.vim/ftplugin/handlebars.vim
" config/vim/.vim/ftplugin/markdown.vim
" config/vim/.vim/ftplugin/php.vim
" config/vim/.vim/ftplugin/vim.vim
" config/vim/.vim/plugin/README.md
" config/vim/.vim/plugin/autocmnds.vim
" config/vim/.vim/plugin/color.vim
" config/vim/.vim/plugin/commands.vim
" config/vim/.vim/plugin/indent-line.vim
" config/vim/.vim/plugin/mappings.vim
" config/vim/.vim/plugin/settings.vim
" config/vim/.vim/plugin/statusline.vim
" config/vim/.vim/spell/en.utf-8.add
" config/vim/.vim/spell/en.utf-8.add.spl
" config/vim/.vim/spell/en.utf-8.spl
" config/vim/.vim/spell/en.utf-8.sug
" config/vim/.vim/spell/pt.utf-8.spl
" config/vim/.vim/ultisnips/all.snippets
" config/vim/.vim/ultisnips/javascript.snippets
" config/vim/.vim/ultisnips/jinja2.snippets
" config/vim/.vim/ultisnips/php.snippets
" config/vim/.vim/ultisnips/snippets.snippets
" }}} ---------------------------------------- /Other Files
