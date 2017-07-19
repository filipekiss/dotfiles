# Alias git to g
if (( $+commands[git] )); then
    unalias g 2>/dev/null

    function g() {
        if [[ $# -eq 0 ]]; then
            git status
        else
            git "$@"
        fi
    }
fi

# Ensure g is completed like git
compdef g=git
