##############################################################
# PATH.
# (N-/): do not register if the directory does not exists
#  N   : NULL_GLOB option (ignore path if the path does not match the glob)
#  n   : Sort the output
#  [-1]: Select the last item in the array
#  -   : follow the symbol links
#  /   : ignore files
##############################################################

# Ensure no duplicates in paths
typeset -gU cdpath fpath manpath path

fpath=(
    ${ZDOTDIR:-${HOME}/.dotfiles/sidekicks/zsh}/rc.d/functions(N-/)
    ${ZDOTDIR:-${HOME}/.dotfiles/sidekicks/zsh}/rc.d/completion(N-/)
    /usr/local/share/zsh/site-functions(N-/)
    $fpath
)

autoload -Uz ${ZDOTDIR:-${HOME}/.dotfiles/sidekicks/zsh}/rc.d/functions/**/*(N:t)

# Get the original manpath, then modify it.
(( $+commands[manpath] )) && MANPATH="`manpath`"
manpath=(
    ${HOMEBREW_ROOT:-/usr/local}/opt/*/libexec/gnuman(N-/)
    "$manpath[@]"
)

cdpath=(
    $cdpath
)

# Set the list of directories that Zsh searches for programs.
path=(
    ${DOTFILES}/bin(N-/)
    ./bin(N-/)
    ./node_modules/.bin
    ${HOMEBREW_ROOT:-/usr/local}/opt/python/libexec/bin(N-/)
    ${HOME}/.local/bin/(Nn[-1]-/)
    /usr/local/{bin,sbin}
    ${HOMEBREW_ROOT:-/usr/local}/opt/coreutils/libexec/gnubin(N-/)
    ${HOMEBREW_ROOT:-/usr/local}/opt/findutils/libexec/gnubin(N-/)
    ${XDG_CONFIG_HOME}/yarn/global/node_modules/.bin(N-/)
    ${GOPATH}/bin(N-/)
    ${HOME}/Library/Python/3.*/bin(Nn[-1]-/)
    ${HOME}/Library/Python/2.*/bin(Nn[-1]-/)
    $path
)

for config (${ZDOTDIR}/rc.d/config/*.zsh) source $config
