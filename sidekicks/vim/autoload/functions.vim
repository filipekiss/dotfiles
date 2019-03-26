" strips trailing whitespace at the end of files. this
" is called on buffer write.
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

function! functions#hasFileType(list)
    return index(a:list, &filetype) != -1
endfunction

let g:fckQuitBlackList = ['preview', 'qf', 'fzf', 'netrw', 'help', 'tagbar']
function! functions#should_quit_on_q()
    return functions#hasFileType(g:fckQuitBlackList)
endfunction

let g:fckKeepWhiteSpace = ['markdown']
function! functions#should_strip_whitespace()
    return functions#hasFileType(g:fckKeepWhiteSpace)
endfunction

let g:fckNoLineNumbers = ['tagbar', 'gitcommit', 'fzf', 'startify']
function! functions#displayLineNumbers(mode) abort
    if functions#hasFileType(g:fckNoLineNumbers)
        set nonumber
        set norelativenumber
    else
        if (a:mode == 'i')
            set number
            set norelativenumber
        else
            set number
            set relativenumber
        endif
    endif
endfunction

function! functions#NeatFoldText()
    let l:foldchar = matchstr(&fillchars, 'fold:\zs.')
    let l:lines=(v:foldend - v:foldstart + 1) . ' lines'
    let l:first=substitute(getline(v:foldstart), '\v *', '', '')
    let l:dashes=substitute(v:folddashes, '-', l:foldchar, 'g')
    return l:dashes . l:foldchar . l:foldchar . ' ' . l:lines . ': ' . l:first . ' '
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

function! AppendModeline()
    let l:modeline = printf(' %s: set ts=%d sw=%d tw=%d ft=%s %set :',
                \  'vim', &tabstop, &shiftwidth, &textwidth, &filetype, &expandtab ? '' : 'no')
    let l:modeline = substitute(&commentstring, "%s", l:modeline, "")
    call append(0, l:modeline)
endfunction

function! functions#isGit() abort
    silent call system('git rev-parse')
    return v:shell_error == 0
endfunction

function! functions#ExecuteMacroOverVisualRange()
    echo '@'.getcmdline()
    execute ":'<,'>normal @".nr2char(getchar())
endfunction

function! functions#EditSnippets(bang, ...)

    let s:type = get(a:, 1, &filetype)

    if (s:type ==# '')
        let s:type = &filetype
    endif

    if (s:type ==# '')
        echom 'No filetype passed or detected'
        return
    endif

    let s:file = expand($HOME) . '/.dotfiles/sidekicks/vim/ultisnips/' . s:type . '.snippets'

    let s:mode = 'vs'
    if winwidth(0) <= 2 * (&tw ? &tw : 80)
        let s:mode = 'sp'
    endif

    execute ':'.s:mode.' '.escape(s:file, ' ')
endfunction
