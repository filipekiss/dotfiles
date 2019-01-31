" vim: ft=vim :tw=80 :sw=4

let s:VIM_PLUG_FOLDER = $VIMHOME . '/plugged'
let s:VIM_EXTENSIONS_FOLDER_NAME = 'extensions'

function! extensions#after() abort
    for file in split(glob($VIMHOME . '/' . s:VIM_EXTENSIONS_FOLDER_NAME . '/*.vim'), '\n')
        let s:after_function_name = fnamemodify(file, ':t:r') . "#after"
        if exists("*" . s:after_function_name)
            call call(s:after_function_name, [])
        endif
    endfor
endfunction

function! extensions#begin(extension_install_path) abort
    call plug#begin(a:extension_install_path)
    let g:fck_extensions_installing=1
endfunction

function! extensions#configure() abort
    for file in split(glob($VIMHOME . '/' . s:VIM_EXTENSIONS_FOLDER_NAME . '/*.vim'), '\n')
        exe 'source' fnameescape(file)
    endfor
endfunction

function! extensions#end() abort
    unlet g:fck_extensions_installing
    call plug#end()
    if (exists('g:fck_queued_installation'))
        unlet g:fck_queued_installation
        augroup MyVimPlug
            autocmd!
            autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
        augroup END
    endif
endfunction

function! extensions#folderExists(extension, ...) abort
    let s:repo_name = fnamemodify(a:extension, ':t')
    let s:plugged_path = s:VIM_PLUG_FOLDER . '/' . s:repo_name
    let s:options = get(a:, 1, {})
    let s:extension_path = get(s:options, 'dir', s:plugged_path)
    return !empty(glob(s:extension_path))
endfunction

function! extensions#If(cond, ...) abort
    let l:opts = get(a:000, 0, {})
    return a:cond ? l:opts : extend(l:opts, { 'on': [], 'for': [] })
endfunction

function! extensions#install() abort
    call extensions#installPlug()
    " Each extension is managed on it's own file. See extensions/README.md for more
    " information
    call extensions#begin(s:VIM_PLUG_FOLDER)
    call extensions#installFrom($VIMHOME . '/' . s:VIM_EXTENSIONS_FOLDER_NAME . '/*.vim')
    call extensions#installFrom($VIMHOME . '/' . s:VIM_EXTENSIONS_FOLDER_NAME . '/local/*.vim')
    call extensions#end()
endfunction

function! extensions#installFrom(extensions_path) abort
    for file in split(glob(a:extensions_path), '\n')
        exe 'source' fnameescape(file)
    endfor
endfunction

function! extensions#installPlug() abort
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

function! extensions#isLoaded(extension_name) abort
    return &rtp =~ a:extension_name
endfunction

" How to use this function:
" Suppose you want to check for 'vim-startify'. Assume $PLUGGED is the root where all extensions are installed.
" vim-startify is located at $PLUGGED/vim-startify/plugin/startify.vim
" Here are the three ways to call this functions and their results:
"
" Function Call: extensions#isInstalled('vim-startify')
" Description: This will look for $PLUGGED/vim-startify/plugin/vim-startify.vim
" Return: false
"
" Function Call: extensions#isInstalled('vim-startify', 'startify.vim')
" Description: This will look for $PLUGGED/vim-startify/plugin/startify.vim
" Return: true
"
" Function Call: extensions#isInstalled('vim-startify', 'startify.vim', 'autoload')
" Description: This will look for $PLUGGED/vim-startify/autoload/startify.vim
" Return: true (startify does have a `startify.vim` file in the `autoload` folder)
function! extensions#isInstalled(extension, ...) abort
    let s:extension_file = get(a:, 1, a:extension . '.vim')
    let s:extension_load_folder = get(a:, 2, 'plugin')
    let s:extension_path = s:VIM_PLUG_FOLDER . '/' . a:extension . '/' . s:extension_load_folder . '/' . s:extension_file
    let s:extension_exists = !empty(glob(s:extension_path))
    return s:extension_exists
endfunction


function! extensions#isInstalling() abort
    return exists('g:fck_extensions_installing')
endfunction

function! extensions#isMissing(...) abort
    let s:isMissing = !call("extensions#isInstalled", a:000)
    return s:isMissing
endfunction

function! extensions#loadExtension(extension, ...) abort
    let s:options = get(a:, 1, {})
    call plug#(a:extension, s:options)
    if !extensions#folderExists(a:extension, s:options)
        let g:fck_queued_installation = 1
    endif
endfunction
