setl conceallevel=2

" Highlight JSDocs style comments
let g:javascript_plugin_jsdoc = 1
" Flow syntax support
let g:javascript_plugin_flow = 1

" # Conceal characters
let g:javascript_conceal_function             = 'ƒ'
let g:javascript_conceal_null                 = 'ø'
let g:javascript_conceal_this                 = '@'
let g:javascript_conceal_return               = '⇚'
let g:javascript_conceal_undefined            = '¿'
let g:javascript_conceal_NaN                  = 'ℕ'

" Set appropriate makeprg
let s:package_lock = findfile('package-lock.json', expand('%:p').';')

if filereadable(s:package_lock)
    setlocal makeprg=npm
else
    setlocal makeprg=yarn
endif
