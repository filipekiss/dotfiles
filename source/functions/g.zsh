# Alias git to g

# Exit if git is not installed
(( $+commands[git] )) || return 0

unalias g 2>/dev/null

function g() {
    if [[ $# -eq 0 ]]; then
        git status
    else
        git "$@"
    fi
}

# Ensure g is completed like git
compdef g=git
