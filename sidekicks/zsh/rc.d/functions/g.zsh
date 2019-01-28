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
    local GIT_INFO_MESSAGE GIT_INFO_HASH GIT_INFO_TIME COLS
    COLS=$(tput cols)
    if [[ $COLS -gt 80 ]]; then
        COLS=72
    else
        COLS=$(($COLS-8))
    fi
    GIT_LAST_COMMIT_INFO=$(git log --color=always -n 1 --pretty=format:"%C(yellow)%h%C(reset)|%C(green)%<($COLS,trunc)%s%C(reset)|%C(cyan)%an - %ad%C(reset) " --date=relative 2>/dev/null)

    GIT_INFO_HASH=$(echo $GIT_LAST_COMMIT_INFO | cut -d '|' -f1)
    GIT_INFO_MESSAGE=$(echo $GIT_LAST_COMMIT_INFO | cut -d '|' -f2)
    GIT_INFO_TIME=$(echo $GIT_LAST_COMMIT_INFO | cut -d '|' -f3)
    [[ -n $GIT_INFO_MESSAGE ]] && \
        e_header "Last Commit Info ${GIT_INFO_HASH}" "${GIT_INFO_MESSAGE}" "${GIT_INFO_TIME}" && \
    return 0
    return 1
}

# Ensure g is completed like git
compdef g=git
