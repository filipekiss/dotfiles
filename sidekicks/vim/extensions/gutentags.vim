" vim: ft=vim :tw=80 :sw=4

scriptencoding utf-8

if extensions#isInstalling()
    call extensions#loadExtension('https://github.com/ludovicchabant/vim-gutentags')
    finish
endif

if extensions#isMissing('vim-gutentags', 'gutentags.vim')
    finish
endif

let g:gutentags_exclude_project_root = ['/usr/local', $HOME, $HOME.'/Desktop']
let g:gutentags_file_list_command = {
	    \ 'markers': {
	    \ '.git': 'git ls-files',
	    \ },
	    \ }
let g:gutentags_resolve_symlinks = 1
let g:gutentags_generate_on_missing = 1
let g:gutentags_generate_on_new = 1
let g:gutentags_generate_on_write = 1
