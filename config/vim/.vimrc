" vim: ft=vim

" Vim Plug Auto Install ---------------------------------------- {{{

    " Automatic installation
    " https://github.com/junegunn/vim-plug/wiki/faq#automatic-installation

    if empty(glob('~/.vim/autoload/plug.vim'))
        silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
                    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    endif

" }}} ---------------------------------------- Vim Plug Auto Install

" Plugins to Install ---------------------------------------- {{{

    call plug#begin('~/.vim/plugged')

" General Plugins ---------------------------------------- {{{
    " Autocomplete ---------------------------------------- {{{
    if has('nvim')
        Plug 'roxma/nvim-completion-manager'
        Plug 'roxma/nvim-cm-tern', { 'do': 'yarn' }
        Plug 'Shougo/neco-vim', { 'for': ['vim'] }
    endif
    " }}} ---------------------------------------- Autocomplete

    Plug 'davidhalter/jedi', { 'for': ['python'] }
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
    Plug 'machakann/vim-sandwich'
    Plug 'kana/vim-textobj-user' | Plug 'kana/vim-textobj-line'

" }}} ---------------------------------------- General Plugins

" Syntax Plugins ---------------------------------------- {{{
    Plug 'moll/vim-node', { 'for': ['javascript', 'javascript.jsx'] }
    Plug 'ap/vim-css-color', { 'for': ['css', 'less', 'sass', 'scss', 'stylus'] }
    Plug 'sheerun/vim-polyglot'
    Plug 'stephenway/postcss.vim', { 'for': ['css'] }
    Plug 'lepture/vim-jinja', { 'for': ['jinja2', 'jinja', 'htmldjango', 'twig'] }
    Plug 'Konfekt/FastFold'
    Plug 'andymass/matchup.vim'
    Plug 'Valloric/MatchTagAlways'
    Plug 'adamclerk/vim-razor', { 'for': ['razor'] }
    Plug 'mustache/vim-mustache-handlebars', { 'for': ['html.handlebars', 'html.mustache'] }
" }}} ---------------------------------------- Syntax Plugins

" Linters and Code Quality Plugins ---------------------------------------- {{{
    Plug 'editorconfig/editorconfig-vim'
    Plug 'sbdchd/neoformat', { 'on': 'Neoformat', 'do': 'yarn global add prettier stylefmt' }
    Plug 'AndrewRadev/splitjoin.Vim'
" }}} ---------------------------------------- Linters and Code Quality Plugins

" Git Plugins ---------------------------------------- {{{

    Plug 'airblade/vim-gitgutter'

" }}} ---------------------------------------- Git Plugins

" ColorSchemes and cool stuff ---------------------------------------- {{{
    Plug 'arcticicestudio/nord-vim'
    Plug 'morhetz/gruvbox'
    Plug 'wakatime/vim-wakatime'
" }}} ---------------------------------------- ColorSchemes and cool stuff

" Writing Plugins ---------------------------------------- {{{

    Plug 'junegunn/goyo.vim', { 'on': ['Goyo']}
    Plug 'junegunn/limelight.vim', { 'on': ['Limelight'] }

" }}} ---------------------------------------- Writing Plugins

    call plug#end()

" }}} ---------------------------------------- Plugins to Install

" Plugin Settings ---------------------------------------- {{{

    " this needs to be here ¯\_(ツ)_/¯
    let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

    let g:user_emmet_leader_key=','

    let g:diminactive_use_syntax = 0
    let g:diminactive_enable_focus = 1

    let g:polyglot_disabled = ['css']

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

    " config/vim/.vim/after/plugin/UltiSnips.vim
    " config/vim/.vim/after/plugin/UndoTree.vim
    " config/vim/.vim/after/plugin/abolish.vim
    " config/vim/.vim/after/plugin/commentray.vim
    " config/vim/.vim/after/plugin/cm.vim
    " config/vim/.vim/after/plugin/easy_align.vim
    " config/vim/.vim/after/plugin/editorconfig.vim
    " config/vim/.vim/after/plugin/fzf.vim
    " config/vim/.vim/after/plugin/gista.vim
    " config/vim/.vim/after/plugin/gitgutter.vim
    " config/vim/.vim/after/plugin/grepper.vim
    " config/vim/.vim/after/plugin/guttentags.vim
    " config/vim/.vim/after/plugin/markdown.vim
    " config/vim/.vim/after/plugin/sneak.vim
    " config/vim/.vim/after/plugin/startify.vim
    " config/vim/.vim/autoload/.gitignore
    " config/vim/.vim/autoload/functions.vim
    " config/vim/.vim/autoload/plug.vim
    " config/vim/.vim/autoload/statusline.vim
    " config/vim/.vim/filetype.vim
    " config/vim/.vim/ftplugin/fzf.vim
    " config/vim/.vim/ftplugin/gitcommit.vim
    " config/vim/.vim/ftplugin/gitrebase.vim
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
    " config/vim/.vim/spell/pt.utg-8.add.spl
    " config/vim/.vim/ultisnips/all.snippets
    " config/vim/.vim/ultisnips/jinja2.snippets
    " config/vim/.vim/ultisnips/php.snippets
    " config/vim/.vim/ultisnips/snippets.snippets

" }}} ---------------------------------------- Other Files
