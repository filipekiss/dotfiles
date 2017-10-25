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
Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTreeFind'] }
  \| Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': ['NERDTreeToggle', 'NERDTreeFind'] }
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

" Syntax
Plug 'moll/vim-node', { 'for': ['javascript', 'javascript.jsx'] }
Plug 'ap/vim-css-color', { 'for': ['css', 'less', 'sass', 'scss', 'stylus'] }
Plug 'sheerun/vim-polyglot'
let g:polyglot_disabled = ['css']
Plug 'stephenway/postcss.vim', { 'for': ['css'] }
Plug 'lepture/vim-jinja', { 'for': ['jinja2', 'jinja', 'htmldjango', 'twig'] }
Plug 'Konfekt/FastFold'

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

" Some crazy magic to make nvim-completion-manager & UltiSnips work nicely together using `<Tab>`
" It doesn't work when added to plugin/after/ultisnips.vim so for now it's here
" https://github.com/roxma/nvim-completion-manager/issues/12#issuecomment-284196219
let g:UltiSnipsExpandTrigger = '<Plug>(ultisnips_expand)'
let g:UltiSnipsJumpForwardTrigger = '<Plug>(ultisnips_expand)'
let g:UltiSnipsJumpBackwardTrigger = '<Plug>(ultisnips_backward)'
let g:UltiSnipsListSnippets = '<Plug>(ultisnips_list)'
let g:UltiSnipsRemoveSelectModeMappings = 0

vnoremap <expr> <Plug>(ultisnip_expand_or_jump_result) g:ulti_expand_or_jump_res?'':"\<Tab>"
inoremap <expr> <Plug>(ultisnip_expand_or_jump_result) g:ulti_expand_or_jump_res?'':"\<Tab>"
imap <silent> <expr> <Tab> (pumvisible() ? "\<C-n>" : "\<C-r>=UltiSnips#ExpandSnippetOrJump()\<cr>\<Plug>(ultisnip_expand_or_jump_result)")
xmap <Tab> <Plug>(ultisnips_expand)
smap <Tab> <Plug>(ultisnips_expand)

vnoremap <expr> <Plug>(ultisnips_backwards_result) g:ulti_jump_backwards_res?'':"\<S-Tab>"
inoremap <expr> <Plug>(ultisnips_backwards_result) g:ulti_jump_backwards_res?'':"\<S-Tab>"
imap <silent> <expr> <S-Tab> (pumvisible() ? "\<C-p>" : "\<C-r>=UltiSnips#JumpBackwards()\<cr>\<Plug>(ultisnips_backwards_result)")
xmap <S-Tab> <Plug>(ultisnips_backward)
smap <S-Tab> <Plug>(ultisnips_backward)

" optional
inoremap <silent> <c-u> <c-r>=cm#sources#ultisnips#trigger_or_popup("\<Plug>(ultisnips_expand)")<cr>

" Add current folder to path (and subfolders also)
set path+=$PWD/**

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
" config/vim/.vim/after/plugin/NERDTree.vim
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
" }
