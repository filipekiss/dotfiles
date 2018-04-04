setlocal commentstring={#\ \ %s\ #}

if exists('b:match_words')
    let b:twigMatchWords = [
                \ ['block', 'endblock'],
                \ ['for', 'endfor'],
                \ ['macro', 'endmacro'],
                \ ['if', 'elseif', 'else', 'endif'],
                \ ['set', 'endset']
                \]
    for element in b:twigMatchWords
        let pattern = ''
        for tag in element[:-2]
            if pattern != ''
                let pattern .= ':'
            endif
            " This pattern is a little weird but it's vim's own pattern. See below for what every
            " piece does
            let pattern .= '{%\s*\<' . tag . '\>\s*\%(.*=\)\@![^}]\{-}%}'
            "               ││ │  │            │ │  │         │    │
            "               ││ │  │            │ │  │         │    └──── \{-}       - match as many as needed until next char
            "               ││ │  │            │ │  │         └───────── [^}]       - match until a close bracket is found, excluding
            "               ││ │  │            │ │  └─────────────────── \%(.*=\)\@! - Negative lookahead (% means non-capturing) - Don't try to match if there's an equal sign at the opening tag
            "               ││ │  │            │ └────────────────────── \s*        - match zero or more whitespaces
            "               ││ │  │            └──────────────────────── \>         - vim's word delimiter end
            "               ││ │  └───────────────────────────────────── \>         - vim's word delimiter start
            "               ││ └──────────────────────────────────────── \s*        - match zero or more whitespaces
            "               │└────────────────────────────────────────── %          - match a literal %
            "               └─────────────────────────────────────────── {          - match a literal {
            "
        endfor
        let pattern .= ':{%\s*\<' . element[-1:][0] . '\>\s*.\{-}%}'
        let b:match_words .= ',' . pattern
    endfor
endif
