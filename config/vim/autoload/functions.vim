function! functions#trim(txt)
  return substitute(a:txt, '^\n*\s*\(.\{-}\)\n*\s*$', '\1', '')
endfunction

function! functions#IsComment(...)
    let hg = join(map(synstack(line('.'), col('$') - 1), 'synIDattr(v:val, "name")'))
    return hg =~? 'comment' ? 1 : 0
endfunction


" This functions adds a line separator below current line.
function! functions#TextHR(...) range
    let l:sep = "-"
    if a:0
        let l:sep = a:1
    endif
    let l:startLine = a:firstline
    let l:endLineBefore = a:lastline
    let l:totalLines = l:endLineBefore - l:startLine
    let l:endLineAfter = l:endLineBefore + l:totalLines
    let l:skipLine = 0
    for lineN in range(l:startLine, l:endLineAfter)
        if l:skipLine == 1
            let l:skipLine = 0
            continue
        endif
        if functions#IsComment() == 1
            let l:macroText = '"ayy"apwv$hr'.l:sep.'j'
        else
            let l:macroText = '"ayy"apv$hr'.l:sep.'j'
        endif
        exec "normal! " . l:macroText
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

let g:fckNoColorColumn = ['qf', 'fzf', 'netrw', 'help', 'markdown', 'startify', 'GrepperSide', 'txt']
function! functions#should_turn_off_colorcolumn()
  return functions#hasFileType(g:fckNoColorColumn)
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
  let l:line = ' ' . substitute(getline(v:foldstart), '^\s*"\?\s*\|\s*"\?\s*{{' . '{\d*\s*', '', 'g') . ' '
  let l:lines_count = v:foldend - v:foldstart + 1
  let l:lines_count_text = '| ' . printf('%10s', l:lines_count . ' lines') . ' |'
  let l:foldchar = matchstr(&fillchars, 'fold:\zs.')
  let l:foldtextstart = strpart('+' . repeat(l:foldchar, v:foldlevel*2) . l:line, 0, (winwidth(0)*2)/3)
  let l:foldtextend = l:lines_count_text . repeat(l:foldchar, 8)
  let l:foldtextlength = strlen(substitute(l:foldtextstart . l:foldtextend, '.', 'x', 'g')) + &foldcolumn
  return l:foldtextstart . repeat(l:foldchar, winwidth(0)-l:foldtextlength) . l:foldtextend
endfunction


function! functions#SetupNCM()
    if has('nvim')
        let g:UltiSnipsExpandTrigger		= '<Plug>(ultisnips_expand)'
        let g:UltiSnipsJumpForwardTrigger	= '<c-j>'
        let g:UltiSnipsJumpBackwardTrigger	= '<c-k>'
        let g:UltiSnipsRemoveSelectModeMappings = 0
        inoremap <silent> <c-u> <c-r>=cm#sources#ultisnips#trigger_or_popup("\<Plug>(ultisnips_expand)")<cr>
        inoremap <expr> <c-j> pumvisible() ? "\<C-n>" : "\<c-j>"
        inoremap <expr> <c-k> pumvisible() ? "\<C-p>" : "\<c-k>"
        xmap <c-u> <Plug>(ultisnips_expand)
        smap <c-u> <Plug>(ultisnips_expand)
        imap <C-Space> <Plug>(cm_force_refresh)
    endif
endfunction

function! functions#SetProjectDir(...)
    " Get current file dir
    let s:currentDir= (a:0 > 0 ? a:1 : expand('%:p:h'))
    let s:projectFolder = functions#GetProjectDir(s:currentDir)
    " If we have a folder set and the folder is not the current folder, change to it
    if (!empty(s:projectFolder))
        lcd `=s:projectFolder`
        silent echom 'Changed project folder to ' . s:projectFolder
        let b:ale_javascript_xo_options="--cwd=" . s:projectFolder . " " . g:ale_javascript_xo_options
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
    if (a:filename == '.git')
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
    let s:gitdir=substitute(s:gitdir, ".$", "", "")
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
