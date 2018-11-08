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
" let g:gutentags_ctags_executable_typescript = 'tstags'

let g:gutentags_enabled_user_func = 'functions#enableGutentags'

