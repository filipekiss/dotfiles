scriptencoding utf-8


" https://stackoverflow.com/a/18776976/708359
function! statusline#getColor(higroup, ...)
    let l:fgOrBg = get(a:, 1, 'fg')
    let l:displayAs = get(a:, 2, l:fgOrBg)
    let l:colorCodeGui = synIDattr(synIDtrans(hlID(a:higroup)), l:fgOrBg, 'gui')
    let l:colorCodeCterm = synIDattr(synIDtrans(hlID(a:higroup)), l:fgOrBg, 'cterm')
    return 'gui' . l:displayAs . '=' . l:colorCodeGui . ' cterm' . l:displayAs . '=' . l:colorCodeCterm
endfunction

function! statusline#left_pad(string, padSize, ...) abort
    let l:padWith=get(a:, 1, ' ')

    let l:padSize = a:padSize - len(a:string)

    if (l:padSize < 1)
        return a:string
    endif

    return repeat(l:padWith, l:padSize) . a:string

endfunction

function! statusline#rhs() abort
    let l:rhs=' '
    if winwidth(0) > 80

        let l:column=virtcol('.')
        let l:width=virtcol('$')
        let l:line=line('.')
        let l:height=line('$')
        let l:longestLineLen=len(max(map(getline(1,'$'), 'len(v:val)')))

        let l:rhs.='␤ '
        let l:rhs.=statusline#left_pad(l:line, len(l:height), '0')
        let l:rhs.='/'
        let l:rhs.=l:height
        let l:rhs.=' ¶ '
        let l:rhs.=statusline#left_pad(l:column, l:longestLineLen, '0')
        let l:rhs.='/'
        let l:rhs.=statusline#left_pad(l:width, l:longestLineLen, '0')

    endif
    return l:rhs
endfunction

function! statusline#fileSize()
    let l:bytes = getfsize(expand('%:p'))
    if (l:bytes >= 1024)
        let l:kbytes = l:bytes / 1024
    endif
    if (exists('kbytes') && l:kbytes >= 1000)
        let l:mbytes = l:kbytes / 1000
    endif

    if l:bytes <= 0
        return '[empty file]'
    endif

    if (exists('mbytes'))
        return l:mbytes . 'MB'
    elseif (exists('kbytes'))
        return l:kbytes . 'KB'
    else
        return l:bytes . 'B'
    endif
endfunction


function! statusline#readOnly()
    if !&modifiable && &readonly
        return ' ɴᴍ/ʀᴏ'
    elseif &modifiable && &readonly
        return ' ʀᴏ'
    elseif !&modifiable && !&readonly
        return ' ɴᴍ'
    else
        return ''
    endif
endfunction

function! statusline#modified()
    if &modified
        return '‼'
    else
        return ''
    endif
endfunction

" DEFINE MODE DICTIONARY
let s:dictmode= {'n': ['N', '4'],
            \ 'no': ['N-Operator Pending', '4'],
            \ 'v': ['V', '6'],
            \ 'V': ['V·Line', '6'],
            \ '': ['V·Block', '6'],
            \ 's': ['Select', '3'],
            \ 'S': ['S·Line', '3'],
            \ '^S': ['S·Block', '3'],
            \ 'i': ['I', '5'],
            \ 'R': ['R', '1'],
            \ 'Rv': ['V·Replace', '1'],
            \ 'c': ['Command', '2'],
            \ 'cv': ['Vim Ex', '7'],
            \ 'ce': ['Ex', '7'],
            \ 'r': ['Propmt', '7'],
            \ 'rm': ['More', '7'],
            \ 'r?': ['Confirm', '7'],
            \ '!': ['Shell', '2'],
            \ 't': ['Terminal', '2']}

" DEFINE COLORS FOR STATUSBAR
let s:dictstatuscolor={
            \ '1': 'hi! link User1 fcksMode',
            \ '2': 'hi! link User1 IncSearch',
            \ '3': 'hi! User1 guibg=#ebdab4 guifg=NONE',
            \ '4': 'hi! link User1 StatusLine',
            \ '5': 'hi! link User1 DiffAdd',
            \ '6': 'hi! link User1 DiffDelete',
            \ '7': 'hi! User1 guibg=#d45d20 guifg=NONE'
            \}


" GET CURRENT MODE FROM DICTIONARY AND RETURN IT
" IF MODE IS NOT IN DICTIONARY RETURN THE ABBREVIATION
" GetMode() GETS THE MODE FROM THE ARRAY THEN RETURNS THE NAME
let s:statusline_last_mode = mode()
function! statusline#getMode(mode)
    let l:modelist = get(s:dictmode, a:mode, [a:mode, 'red'])
    let l:modecolor = l:modelist[1]
    let l:modename = l:modelist[0]
    if a:mode != s:statusline_last_mode
        let l:modeexe = get(s:dictstatuscolor, l:modecolor, 'red')
        let s:statusline_last_mode = a:mode
        exec l:modeexe
        redrawstatus!
    endif
    return l:modename
endfunction

function! statusline#fileprefix()
    let l:basename=expand('%:h')
    let l:pathPrefix=get(b:, 'fckBufPrefix', '')
    if l:basename ==? ''
        return ''
    elseif  l:basename ==? '.'
        return l:pathPrefix
    else
        " Make sure we show $HOME as ~.
        return l:pathPrefix . substitute(l:basename . '/', '\C^' . $HOME, '~', '')
    endif
endfunction

" Show ALE on statusline
" See https://github.com/w0rp/ale#faq-statusline
function! statusline#LinterStatus() abort
    if !exists(':ALEInfo')
        return ''
    endif
    let l:error_symbol = '⨉'
    let l:style_symbol = '●'
    let l:counts = ale#statusline#Count(bufnr(''))
    let l:ale_linter_status = []

    if l:counts.total == 0
        return printf('%%#fcksSuccess#%s', l:style_symbol)
    endif

    if l:counts.error
        call add(l:ale_linter_status , printf('%%#fcksError#%d %s', l:counts.error, l:error_symbol))
    endif
    if l:counts.warning
        call add(l:ale_linter_status , printf('%%#fcksWarning#%d %s', l:counts.warning, l:error_symbol))
    endif
    if l:counts.style_error
        call add(l:ale_linter_status , printf('%%#fcksError#%d %s', l:counts.style_error, l:style_symbol))
    endif
    if l:counts.style_warning
        call add(l:ale_linter_status , printf('%%#fcksWarning#%d %s', l:counts.style_warning, l:style_symbol))
    endif

    return join(l:ale_linter_status)
endfunction

function! statusline#updateColors() abort
    let s:statusLineBgColor = ' ' . statusline#getColor('CursorLineNr', 'bg')
    execute 'hi! fcksMode ' . statusline#getColor('Comment') . s:statusLineBgColor
    execute 'hi! fcksDim ' .  statusline#getColor('LineNr')  . s:statusLineBgColor
    execute 'hi! fcksHighlight ' . statusline#getColor('Constant') . s:statusLineBgColor
    execute 'hi! fcksSuccess ' . statusline#getColor('DiffAdd') . s:statusLineBgColor
    execute 'hi! fcksWarning ' . statusline#getColor('DiffText') . s:statusLineBgColor
    execute 'hi! fcksError ' . statusline#getColor('DiffDelete') . s:statusLineBgColor
endfunction
