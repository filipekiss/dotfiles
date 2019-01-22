# Alias yarn to y

# Exit if yarn is not installed
(( $+commands[yarn] )) || return 0

unalias y 2>/dev/null

function y() {
    if [[ $# -eq 0 ]]; then
        yarn --link-duplicates
    else
        yarn "$@"
    fi
}

# Ensure y is completed like yarn
compdef y=yarn
