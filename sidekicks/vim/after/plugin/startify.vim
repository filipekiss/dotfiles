" vim: ft=vim :tw=0
scriptencoding utf-8

if !exists(':Startify')
    finish
endif


let g:startify_padding_left = 5
let g:startify_relative_path = 1
let g:startify_fortune_use_unicode = 1
let g:startify_change_to_vcs_root = 1
let g:startify_update_oldfiles = 1
let g:startify_use_env = 0

let g:startify_custom_header_quotes = startify#fortune#predefined_quotes() + [
            \ ['Simplicity is a great virtue but it requires hard work to achieve it', 'and education to appreciate it. And to make matters worse: complexity sells better.', '', '― Edsger W. Dijkstra'],
            \ ['A common fallacy is to assume authors of incomprehensible code will be able to express themselves clearly in comments.'],
            \ ['Your time is limited, so don’t waste it living someone else’s life. Don’t be trapped by dogma — which is living with the results of other people’s thinking. Don’t let the noise of others’ opinions drown out your own inner voice. And most important, have the courage to follow your heart and intuition. They somehow already know what you truly want to become. Everything else is secondary.', '', '— Steve Jobs, June 12, 2005'],
            \ ['My take: Animations are something you earn the right to include when the rest of the experience is fast and intuitive.', '', '— @jordwalke'],
            \ ['If a feature is sometimes dangerous, and there is a better option, then always use the better option.', '', '- Douglas Crockford'],
            \ ['The best way to make your dreams come true is to wake up.', '', '― Paul Valéry'],
            \ ['Fast is slow, but continuously, without interruptions', '', '– Japanese proverb'],
            \ ['A language that doesn’t affect the way you think about programming is not worth knowing.', '- Alan Perlis'],
            \ ['We build our computer (systems) the way we build our cities: over time, without a plan, on top of ruins', '', '- Ellen Ullman'],
            \ ['Every great developer you know got there by solving problems they were unqualified to solve until they actually did it', '', '- Patrick McKenzie'],
            \ ['Without requirements or design, programming is the art of adding bugs to an empty text file', '', '- Louis Srygley'],
            \ ]

let g:startify_custom_header = 'map(startify#fortune#boxed(), "repeat(\" \", 5).v:val")'

let g:startify_skiplist = [
            \ 'COMMIT_EDITMSG',
            \ '^/tmp',
            \ escape(fnamemodify(resolve($VIMRUNTIME), ':p'), '\') .'doc',
            \ 'bundle/.*/doc',
            \ 'plugged/.*/doc',
            \ ]


hi! link StartifyHeader Normal
hi! link StartifyFile Directory
hi! link StartifyPath LineNr
hi! link StartifySlash StartifyPath
hi! link StartifyBracket StartifyPath
hi! link StartifyNumber Title

augroup StartifyCustom
    autocmd User Startified setlocal cursorline
    if has('nvim')
        autocmd TabNewEntered * Startify
    else
        autocmd VimEnter * let t:startify_new_tab = 1
        autocmd BufEnter *
                    \ if !exists('t:startify_new_tab') && empty(expand('%')) |
                    \   let t:startify_new_tab = 1 |
                    \   Startify |
                    \ endif
    endif
augroup END
