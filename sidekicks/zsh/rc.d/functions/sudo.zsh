# Make sure my aliases and functions work when sudoing

unalias sudo 2>/dev/null

function sudo() {
    # If no arguments, just call sudo and return from the function
    if [[ $# -lt 1 ]]; ; then
        $commands[sudo]
        return
    fi
    # If I ever need to bypass the alias, just call sudo sudo [options] [arguments]
    # This is here as a fallback, but it should rarely be needed
    if [[ "$1" == "sudo" ]] ; then
        shift
        $commands[sudo] "$@"
    fi
    # Ensure functions work
    if (( $+functions[$1] )); then
        $commands[sudo] -E zsh -c "$functions[$1]" "$@"
    # Expand aliases
    elif (( $+aliases[$1] )); then
        local aliased=$aliases[$1]
        shift;
        $commands[sudo] ${=aliased} $@
    # Invoke sudo as normal
    else
        $commands[sudo] $@
    fi
}

compdef sudo=sudo
