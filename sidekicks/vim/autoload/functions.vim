function! functions#trim(txt)
    return substitute(a:txt, '^\n*\s*\(.\{-}\)\n*\s*$', '\1', '')
endfunction

function! Strip(input_string)
    return substitute(a:input_string, '^\s*\(.\{-}\)\s*$', '\1', '')
endfunction

" This functions adds a line separator below current line.
" It will always add it as a comment and will use &commentstring to do so
function! functions#TextHR(...) range
    let l:commentFormat = &commentstring
    let l:commentStringStart = Strip(substitute(l:commentFormat, '%s.*', '', ''))
    let l:commentStringEnd = substitute(l:commentFormat, l:commentStringStart . '.*%s[ ]*', '', '')
    if len(l:commentStringEnd) == 0
        let l:sep = get(a:, 1, l:commentStringStart)
    else
        let l:sep = get(a:, 1, '-')
    endif
    let l:startLine = a:firstline
    let l:endLineBefore = a:lastline
    let l:totalLines = l:endLineBefore - l:startLine
    let l:endLineAfter = l:endLineBefore + l:totalLines
    let l:skipLine = 0
    for l:lineN in range(l:startLine, l:endLineAfter)
        if l:skipLine == 1
            exec 'normal! j'
            let l:skipLine = 0
            continue
        endif
        let l:lineSize = len(Strip(getline(l:lineN)))
        let l:hrString = repeat(l:sep, l:lineSize)
        let l:spacer = ' '
        if l:commentStringStart ==? l:sep && len(l:commentStringEnd) == 0
            let l:spacer = ''
        endif
        let l:prefix = l:commentStringStart . l:spacer
        let l:suffix = l:spacer . l:commentStringEnd
        let l:maxLineSize = l:lineSize
        if len(l:commentStringEnd) > 0
            let l:maxLineSize -= len(l:spacer . l:commentStringEnd)
        endif
        let l:separator = strpart(l:prefix . l:hrString, 0, l:maxLineSize) . l:suffix
        let l:macroText = '"0yy"0pC' . l:separator
        exec 'normal! ' . l:macroText
        let l:skipLine = 1
    endfor
endfunction

function! functions#ZoomToggle() abort
    if exists('t:zoomed') && t:zoomed
        exec t:zoom_winrestcmd
        let t:zoomed = 0
    else
        let t:zoom_winrestcmd = winrestcmd()
        resize
        vertical resize
        let t:zoomed = 1
    endif
endfunction

" Show highlighting groups for current word
" https://twitter.com/kylegferg/status/697546733602136065
function! functions#SynStack()
    if !exists('*synstack')
        return
    endif
    echo map(synstack(line('.'), col('.')), "synIDattr(v:val, 'name')")
endfunc

" strips trailing whitespace at the end of files. this
" is called on buffer write. See config/vim/plugin/autocmnds.vim:25
function! functions#Preserve(command)
    " Preparation: save last search, and cursor position.
    let l:pos=getcurpos()
    let l:search=@/
    " Do the business:
    keepjumps execute a:command
    " Clean up: restore previous search history, and cursor position
    let @/=l:search
    nohlsearch
    call setpos('.', l:pos)
endfunction

" via: http://vim.wikia.com/wiki/HTML_entities
function! functions#HtmlEscape()
    silent s/&/\&amp;/eg
    silent s/</\&lt;/eg
    silent s/>/\&gt;/eg
endfunction

function! functions#HtmlUnEscape()
    silent s/&lt;/</eg
    silent s/&gt;/>/eg
    silent s/&amp;/\&/eg
endfunction

function! functions#OpenFileFolder()
    silent call system('open '.expand('%:p:h:~'))
endfunction

" Loosely based on: http://vim.wikia.com/wiki/Make_views_automatic
" from https://github.com/wincent/wincent/blob/c87f3e1e127784bb011b0352c9e239f9fde9854f/roles/dotfiles/files/.vim/autoload/autocmds.vim#L20-L37
let g:fckViewBlackList = ['diff', 'hgcommit', 'gitcommit']
function! functions#should_mkview() abort
    return
                \ &buftype ==# '' &&
                \ index(g:fckViewBlackList, &filetype) == -1 &&
                \ !exists('$SUDO_USER') " Don't create root-owned files.
endfunction

function! functions#mkview() abort
    if exists('*haslocaldir') && haslocaldir()
        " We never want to save an :lcd command, so hack around it...
        cd -
        mkview
        lcd -
    else
        mkview
    endif
endfunction

function! functions#hasFileType(list)
    return index(a:list, &filetype) != -1
endfunction

let g:fckQuitBlackList = ['preview', 'qf', 'fzf', 'netrw', 'help']
function! functions#should_quit_on_q()
    return functions#hasFileType(g:fckQuitBlackList)
endfunction

let g:fckNoColorColumn = ['qf', 'fzf', 'netrw', 'help', 'markdown', 'startify', 'GrepperSide', 'txt', 'gitconfig', 'gitrebase', 'html', 'htmldjango']
function! functions#should_turn_off_colorcolumn()
    return &textwidth == 0 || functions#hasFileType(g:fckNoColorColumn)
endfunction

let g:fckKeepWhiteSpace = ['markdown']
function! functions#should_strip_whitespace()
    return functions#hasFileType(g:fckKeepWhiteSpace)
endfunction


fun! functions#ProfileStart(...)
    if a:0 && a:1 != 1
        let l:profile_file = a:1
    else
        let l:profile_file = '/tmp/vim.'.getpid().'.'.reltimestr(reltime())[-4:].'profile.txt'
        echom 'Profiling into' l:profile_file
        let @* = l:profile_file
    endif
    exec 'profile start '.l:profile_file
    profile! file **
    profile  func *
endfun


function! functions#NeatFoldText()
    let l:foldchar = matchstr(&fillchars, 'fold:\zs.')
    let l:lines=(v:foldend - v:foldstart + 1) . ' lines'
    let l:first=substitute(getline(v:foldstart), '\v *', '', '')
    let l:dashes=substitute(v:folddashes, '-', l:foldchar, 'g')
    return l:dashes . l:foldchar . l:foldchar . ' ' . l:lines . ': ' . l:first . ' '
endfunction

function! functions#SetupNCM()
    if has('nvim')
        let g:UltiSnipsExpandTrigger		= '<Plug>(ultisnips_expand)'
        let g:UltiSnipsJumpForwardTrigger	= '<C-j>'
        let g:UltiSnipsJumpBackwardTrigger	= '<C-k>'
        let g:UltiSnipsRemoveSelectModeMappings = 0
        inoremap <silent> <c-u> <c-r>=ncm2_ultisnips#expand_or("\<Plug>(ultisnips_expand)")<cr>
        inoremap <expr> <c-j> pumvisible() ? "\<C-n>" : "\<c-j>"
        inoremap <expr> <c-k> pumvisible() ? "\<C-p>" : "\<c-k>"
        xmap <c-u> <Plug>(ultisnips_expand)
        smap <c-u> <Plug>(ultisnips_expand)
        imap <C-Space> <Plug>(ncm2_manual_trigger)
        let g:ncm2#popup_delay = 20

        " This is here to prevent functionality breaking due to NCM and
        " AutoPairs conflicts.
        " See https://github.com/jiangmiao/auto-pairs/issues/91#issuecomment-241692588
        " for more information
        if exists('g:AutoPairsLoaded')
            let g:AutoPairsMapCR = 0
        endif
        imap <expr> <CR> pumvisible() && empty(v:completed_item) ? "\<C-y>\<CR>" : exists('g:AutoPairsLoaded') ? "\<CR>\<Plug>AutoPairsReturn" : "\<CR>"
    endif
endfunction

function! functions#SetProjectDir(...)
    " Get current file dir
    let s:currentDir= (a:0 > 0 ? a:1 : expand('%:p:h'))
    let s:projectFolder = functions#GetProjectDir(s:currentDir)
    " If we have a folder set and the folder is not the current folder, change to it
    if (!empty(s:projectFolder))
        lcd `=s:projectFolder`
        " let b:ale_javascript_xo_options='--cwd=' . s:projectFolder . ' ' . g:ale_javascript_xo_options
        silent echom 'Changed project folder to ' . s:projectFolder
    endif
endfunction

function! functions#GetProjectDir(currentDir)
    " If the directory doesn't exists, don't bother trying to guess stuff and also return an empty
    " string
    if !isdirectory(a:currentDir)
        return ''
    endif
    " Try to get a git top-level directory (this will return $HOME if not inside a git repo)
    let s:gitDir = FindFileIn('.git', a:currentDir)
    " Look for a package.json file
    let s:jsProjectDir = FindFileIn('package.json', a:currentDir, s:gitDir)
    let s:jsProjectDirWeight = len(s:jsProjectDir)
    " +IDEA: Maybe leave this up to something like projectionist.vim?
    " Look for a .local.vim
    let s:vimProjectDir = FindFileIn('.local.vim', a:currentDir, s:gitDir)
    let s:vimProjectDirWeight = len(s:vimProjectDir)
    " Check what is more specific between the git root project, the foler where we found either
    " package.json or .local.vim (basically the longest path wins, because that means it's more
    " specific)
    let s:projectFolder = s:jsProjectDir
    if (s:vimProjectDirWeight > s:jsProjectDirWeight)
        let s:projectFolder = s:vimProjectDir
    endif
    return s:projectFolder
endfunction

function! FindFileIn(filename, startingPath, ...)
    let s:searchUntil = get(a:, 1, $HOME)
    " If s:searchUntil is empty by now, means no $HOME is defined. We have no business here
    if (empty(s:searchUntil) || len(a:startingPath) < len(s:searchUntil))
        return ''
    endif
    if (a:filename ==? '.git')
        return GetGitDir(a:startingPath)
    endif
    " If we are in the path already, just return it
    if (a:startingPath == s:searchUntil)
        return s:searchUntil
    endif
    " If found <filename>, return the current folder
    if filereadable(a:startingPath . '/' . a:filename)
        silent echom 'Found '.a:filename.' in ' . a:startingPath
        return a:startingPath
    endif
    " Recursively run this until a:startingPath is equal s:searchUntil
    return FindFileIn(a:filename, fnamemodify(a:startingPath, ':h'), s:searchUntil)
endfunction

function! GetGitDir(path)
    " Set 'gitdir' to be the folder containing .git or an empty string
    let s:gitdir=system('cd '.a:path.' && git rev-parse --show-toplevel 2> /dev/null || echo ""')
    " Clear new-line from system call
    let s:gitdir=substitute(s:gitdir, '.$', '', '')
    if (empty(s:gitdir))
        let s:gitdir = $HOME
    endif
    return s:gitdir
endfunction

function! functions#fckALEToggle(...)
    let s:fckALEStatus = {}
    let s:fckALEStatus['global'] = get(g:, 'ale_fix_on_save', 0)
    let s:fckALEStatus['buffer'] = get(b:, 'ale_fix_on_save', s:fckALEStatus['global'])
    let s:fckCurrentScope = get(a:, 1, 'global')
    if (s:fckALEStatus[s:fckCurrentScope] == 1)
        let s:fckALEStatus[s:fckCurrentScope]=0
    else
        let s:fckALEStatus[s:fckCurrentScope]=1
    endif
    let g:ale_fix_on_save=s:fckALEStatus['global']
    let b:ale_fix_on_save=s:fckALEStatus['buffer']
endfunction

function! functions#prettierSettings(...)
    let s:prettierDefaultOptions = {
                \ 'tab-width': '4',
                \ 'single-quote': 1,
                \ 'use-tabs': 0,
                \ 'trailing-comma': 'es5',
                \ 'arrow-parens': 'always',
                \ 'no-bracket-spacing': 1,
                \ 'prose-wrap': 'always',
                \ 'no-editorconfig': 1,
                \ 'config-precedence': 'prefer-file',
                \ 'print-width': &textwidth
                \ }
    let a:newOptions = get(a:, 1, {})
    let s:prettierFinalOptions = extend(s:prettierDefaultOptions, a:newOptions)
    let s:cliOptions=[]
    for s:pKey in keys(s:prettierDefaultOptions)
        let s:optionValue=s:prettierDefaultOptions[s:pKey]
        if s:optionValue ==# '0'
            continue
        endif
        call add(s:cliOptions, '--'.s:pKey)
        if s:optionValue !=# '1'
            call add(s:cliOptions,  s:optionValue)
        endif
        let s:optionValue = ''
    endfor
    let g:ale_javascript_prettier_options = join(s:cliOptions, ' ')
endfunction

function! AppendModeline()
    let l:modeline = printf(" %s: set ts=%d sw=%d tw=%d %set :",
                \  "vim", &tabstop, &shiftwidth, &textwidth, &expandtab ? '' : 'no')
    let l:modeline = substitute(&commentstring, "%s", l:modeline, "")
    call append(0, l:modeline)
endfunction

function! functions#setOverLength()
    if  get(b:, 'overlengthManualDisable', 0) > 0 || functions#should_turn_off_colorcolumn()
        match NONE
    else
        " Stolen from https://github.com/whatyouhide/vim-lengthmatters/blob/74e248378544ac97fb139803b39583001c83d4ef/plugin/lengthmatters.vim#L17-L33
        let s:overlengthCmd = 'highlight OverLength'
        for md in ['cterm', 'term', 'gui']
            let bg = synIDattr(hlID('Comment'), 'fg', md)
            let fg = synIDattr(hlID('Normal'), 'bg', md)

            if has('gui_running') && md !=# 'gui'
                continue
            endif

            if !empty(bg) | let s:overlengthCmd .= ' ' . md . 'bg=' . bg | endif
            if !empty(fg) | let s:overlengthCmd .= ' ' . md . 'fg=' . fg | endif
        endfor
        exec s:overlengthCmd
        " Use tw + 1 so invisble characters are not marked
        let s:overlengthSize = &textwidth + 1
        execute 'match OverLength /\%>'. s:overlengthSize .'v.*/'
    endif
endfunction

function! functions#fckOverlengthToggle(...)
    let s:disableOverlength = get(a:, 1, 2)
    if s:disableOverlength > 1
        if get(b:, 'overlengthManualDisable', 1) > 0
            let s:disableOverlength = 'on'
        else
            let s:disableOverlength = 'off'
        endif
    endif
    if s:disableOverlength ==# "on"
        let b:overlengthManualDisable = 0
    endif
    if s:disableOverlength ==# "off"
        let b:overlengthManualDisable = 1
    endif
    if &textwidth > 0
        call functions#setOverLength()
    else
        echohl WarningMsg
        echo "-> textwidth is set to 0! no OverLength applied"
        echohl None
    endif
endfunction

function! functions#SetupVimwiki()
    let s:default_options = {
                \ 'auto_toc': 1,
                \ 'nested_syntaxes' : {
                \ 'bash': 'sh',
                \ 'html': 'html',
                \ 'javascript': 'javascript.jsx',
                \ 'python': 'python',
                \ 'react': 'javascript.jsx',
                \ 'sh': 'sh',
                \ 'zsh': 'zsh',
                \ },
                \ }

    let s:personal_wiki = extend({
                \ 'path': '~/vimwiki'
                \ }, s:default_options)

    let s:work_wiki = extend({
                \ 'path': '~/code/stoodi/notes'
                \ }, s:default_options)

    let g:vimwiki_list = [s:personal_wiki, s:work_wiki]

    let g:vimwiki_hl_cb_checked = 1

    let g:vimwiki_listsyms = ' ○◐●✓'

    let g:vimwiki_listsym_rejected = '⊘'

    let g:vimwiki_folding = 'expr:quick'

    let g:vimwiki_dir_link = 'index'

    let g:vimwiki_html_header_numbering_sym = '. '

    let g:vimwiki_autowriteall = 1

    let g:vimwiki_auto_chdir = 1
endfunction
