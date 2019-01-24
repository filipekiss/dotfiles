# Alias git to g

# Exit if git is not installed
(( $+commands[git] )) || return 0

unalias g 2>/dev/null

function g() {
    if [[ $# -eq 0 ]]; then
        last_commit_info
        git status --short --branch 2>/dev/null || e_header "Not a git repository"
    else
        git "$@"
    fi
}

last_commit_info() {
    local GIT_INFO_AUTHOR GIT_INFO_COMMIT GIT_INFO_MESSAGE
    GIT_INFO_MESSAGE=$(git log --color=always -n 1 --pretty=format:'%C(yellow)%h %C(green)%s %C(cyan)(%an %ad)' --date=relative 2>/dev/null)

    [[ -n $GIT_INFO_MESSAGE ]] && \
    e_header "Last Commit Info" "$GIT_INFO_MESSAGE" && \
    return 0
    return 1
}

# Ensure g is completed like git
compdef g=git