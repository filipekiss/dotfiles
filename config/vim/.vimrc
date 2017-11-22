" vim: ft=vim
"
"
" Vim-Plug

" Automatic installation
" https://github.com/junegunn/vim-plug/wiki/faq#automatic-installation

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" General
if has('nvim')
    Plug 'roxma/nvim-completion-manager'
    Plug 'roxma/ncm-flow', { 'for': ['javascript', 'javascript.jsx'] }
endif
Plug 'davidhalter/jedi', { 'for': ['python'] }
Plug 'Shougo/neco-vim', { 'for': ['vim'] }
Plug 'jiangmiao/auto-pairs'
Plug 'SirVer/ultisnips'
Plug 'duggiefresh/vim-easydir'
Plug 'jaawerth/nrun.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes \| ./install --all' } | Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-easy-align', { 'on': ['<Plug>(EasyAlign)'] }
Plug 'junegunn/vim-peekaboo'
Plug 'kshenoy/vim-signature'
Plug 'ludovicchabant/vim-gutentags'
Plug 'mattn/emmet-vim', { 'for': ['html', 'htmldjango', 'jinja', 'jinja2', 'twig', 'javascript.jsx'] }
Plug 'mbbill/undotree', { 'on': ['UndotreeToggle'] }
Plug 'mhinz/vim-grepper', { 'on': ['Grepper'] }
Plug 'mhinz/vim-sayonara', { 'on': 'Sayonara' }
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'wellle/targets.vim'
Plug 'wincent/terminus'
Plug 'mhinz/vim-startify'
Plug 'kepbod/quick-scope'
Plug 'google/vim-searchindex'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'tpope/tpope-vim-abolish'
Plug 'bronson/vim-visual-star-search'
Plug 'justinmk/vim-sneak'
Plug 'tpope/vim-eunuch'
Plug 'junegunn/vader.Vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'blueyed/vim-diminactive'
Plug 'tpope/vim-fugitive'
Plug 'mjbrownie/swapit'

let g:diminactive_use_syntax = 0
let g:diminactive_enable_focus = 1

" Syntax
Plug 'moll/vim-node', { 'for': ['javascript', 'javascript.jsx'] }
Plug 'ap/vim-css-color', { 'for': ['css', 'less', 'sass', 'scss', 'stylus'] }
Plug 'sheerun/vim-polyglot'
let g:polyglot_disabled = ['css']
Plug 'stephenway/postcss.vim', { 'for': ['css'] }
Plug 'lepture/vim-jinja', { 'for': ['jinja2', 'jinja', 'htmldjango', 'twig'] }
Plug 'Konfekt/FastFold'
Plug 'andymass/matchup.vim'
Plug 'Valloric/MatchTagAlways'
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

" Linters & Code quality
Plug 'editorconfig/editorconfig-vim'
Plug 'sbdchd/neoformat', { 'on': 'Neoformat', 'do': 'yarn global add prettier stylefmt' }
Plug 'AndrewRadev/splitjoin.Vim'

" Git
Plug 'airblade/vim-gitgutter'

" Colors and stuff
Plug 'arcticicestudio/nord-vim'
Plug 'morhetz/gruvbox'
Plug 'wakatime/vim-wakatime'

" Writing
Plug 'junegunn/goyo.vim', { 'on': ['Goyo']}
Plug 'junegunn/limelight.vim', { 'on': ['Limelight'] }

call plug#end()

" Plugins settings
"================================================================================
" this needs to be here ¯\_(ツ)_/¯
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

let g:cm_complete_delay = 30
let g:cm_sources_override = {
      \ 'cm-tags': {'enable':0}
      \ }


" NCM + UltiSnips
if has('nvim')
    let g:UltiSnipsExpandTrigger = "<Plug>(ultisnips_expand)"
    inoremap <silent> <c-u> <c-r>=cm#sources#ultisnips#trigger_or_popup("\<Plug>(ultisnips_expand)")<cr>
    inoremap <expr> <c-j> pumvisible() ? "\<C-n>" : "\<c-j>"
    inoremap <expr> <c-k> pumvisible() ? "\<C-p>" : "\<c-k>"
    xmap <c-u> <Plug>(ultisnips_expand)
    smap <c-u> <Plug>(ultisnips_expand)
endif



" Always have $HOME/.dotfiles on Vim path. No need for subfolders
set path+=$HOME/.dotfiles/
" Add current folder to path (and subfolders also)
set path+=**

" Overrrides
"================================================================================
let s:vimrc_local = $HOME . '/.vimrc.local'
if filereadable(s:vimrc_local)
  execute 'source ' . s:vimrc_local
endif

" Project specific override
"================================================================================
let s:vimrc_project = $PWD . '/.local.vim'
if filereadable(s:vimrc_project)
  execute 'source ' . s:vimrc_project
endif

let g:user_emmet_leader_key=','

" Other Files {
" config/vim/.vim/after/plugin/UltiSnips.vim
" config/vim/.vim/after/plugin/abolish.vim
" config/vim/.vim/after/plugin/commentray.vim
" config/vim/.vim/after/plugin/easy_align.vim
" config/vim/.vim/after/plugin/editorconfig.vim
" config/vim/.vim/after/plugin/fzf.vim
" config/vim/.vim/after/plugin/gista.vim
" config/vim/.vim/after/plugin/gitgutter.vim
" config/vim/.vim/after/plugin/grepper.vim
" config/vim/.vim/after/plugin/guttentags.vim
" config/vim/.vim/after/plugin/startify.vim
" config/vim/.vim/after/plugin/sneak.vim
" config/vim/.vim/autoload/.gitignore
" config/vim/.vim/autoload/functions.vim
" config/vim/.vim/autoload/plug.vim
" config/vim/.vim/autoload/statusline.vim
" config/vim/.vim/filetype.vim
" config/vim/.vim/ftplugin/fzf.vim
" config/vim/.vim/ftplugin/gitcommit.vim
" config/vim/.vim/ftplugin/markdown.vim
" config/vim/.vim/ftplugin/php.vim
" config/vim/.vim/plugin/README.md
" config/vim/.vim/plugin/autocmnds.vim
" config/vim/.vim/plugin/color.vim
" config/vim/.vim/plugin/commands.vim
" config/vim/.vim/plugin/indent-line.vim
" config/vim/.vim/plugin/mappings.vim
" config/vim/.vim/plugin/settings.vim
" config/vim/.vim/plugin/statusline.vim
" config/vim/.vim/ultisnips/php.snippets
" config/vim/.vim/ultisnips/snippets.snippets
" config/vim/.vim/ultisnips/jinja.snippets
" }
