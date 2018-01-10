function groot() {
    repoRoot=$(git rev-parse --show-toplevel)
    builtin cd $repoRoot
}
