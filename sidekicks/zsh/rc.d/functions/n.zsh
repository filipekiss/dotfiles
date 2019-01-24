# Alias npm to n

# Exit if npm is not installed
(( $+commands[npm] )) || return 0

unalias n 2>/dev/null

function n() {
    if [[ $# -eq 0 ]]; then
        npm install --link
    else
        npm "$@"
    fi
}

# Ensure n is completed like npm
compdef n=npm