#
# Executes commands at login pre-zshrc.

##############################################################
# Set Interactive shell options
##############################################################

setopt autoparamslash  # tab completing directory appends a slash
setopt noflowcontrol   # disable start (C-s) and stop (C-q) characters
setopt interactivecomments  # allow comments, even in interactive shells
setopt printexitvalue       # for non-zero exit status
setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history.
setopt CORRECT

# Better spell checking & auto correction prompt
export SPROMPT="zsh: correct %F{red}'%R'%f to %F{blue}'%r'%f [%B%Uy%u%bes, %B%Un%u%bo, %B%Ue%u%bdit, %B%Ua%u%bbort]? "

#
# Editors
# Set nvim as editor or use vim if nvim is not available
(( $+commands[nvim] )) && export EDITOR=$commands[nvim] || export EDITOR=vim
export VISUAL=$EDITOR
export GIT_EDITOR=$EDITOR
# Set less or more as the default pager.
if (( ${+commands[emojify]} )); then
    export PAGER="emojify | less"
elif (( ${+commands[less]} )); then
    export PAGER=less
else
    export PAGER=more
fi


# Git options
export GIT_MERGE_AUTOEDIT=no

#
# Language
#

export LANG='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'

##############################################################
# PATH.
##############################################################
fpath=(
  "${HOME}/.dotfiles/completion"
  "${ZMODULES}/docker/cli/contrib/completion/zsh"
  "${ZMODULES}/docker/compose/contrib/completion/zsh"
  "${ZMODULES}/zsh-users/zsh-completions/src"
  '/usr/local/share/zsh/site-functions'
  $fpath
)

HOMEBREW_ROOT="/usr/local"

# GNU Coreutils
export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
(( $+commands[nvim] )) && export MANPAGER="nvim -c 'set ft=man' -"

# Ensure path arrays do not contain duplicates.
typeset -gU cdpath fpath mailpath path

# Set the list of directories that Zsh searches for programs.
# +TODO: Fix path settings
path=(
    ./node_modules/.bin
    ${HOME}/.dotfiles/bin
    ${HOMEBREW_ROOT:-/usr/local}/opt/gnu-sed/libexec/gnubin
    ${HOMEBREW_ROOT:-/usr/local}/opt/findutils/libexec/gnubin
    ${HOMEBREW_ROOT:-/usr/local}/opt/coreutils/libexec/gnubin
    ${HOMEBREW_ROOT:-/usr/local}/opt/python/libexec/bin
    ${HOMEBREW_ROOT:-/usr/local}/{bin,sbin}
    ${HOMEBREW_ROOT:-/usr/local}/opt/curl/bin
    ${HOMEBREW_ROOT:-/usr/local}/Cellar/git
    ${HOME}/.go/bin
    $path
)

# Add yarn bin to path
if (( $+commands[yarn] )); then
    path+=($HOME/.config/yarn/global/node_modules/.bin)
fi

# Add python binaries to path
if (( $+commands[python2] )); then
    path+=($(python2 -m site --user-base)/bin)
fi

if (( $+commands[python] )); then
    path+=($(python -m site --user-base)/bin)
fi

if (( $+commands[go] )); then
    export GOPATH="${HOME}/.go"
fi

#
# Less
#

# Set the default Less options.
# Mouse-wheel scrolling has been disabled by -X (disable screen clearing).
# Remove -X and -F (exit if the content fits on one screen) to enable it.
export LESS='-F -g -i -M -R -S -w -X -z-4'

# Set the Less input preprocessor.
# Try both `lesspipe` and `lesspipe.sh` as either might exist on a system.
if (( $#commands[(i)lesspipe(|.sh)] )); then
  export LESSOPEN="| /usr/bin/env $commands[(i)lesspipe(|.sh)] %s 2>&-"
  (( $+commands[pygmentize] )) && export LESSCOLORIZER=pygmentize
fi

#
# Temporary Files
#

if [[ ! -d "$TMPDIR" ]]; then
  export TMPDIR="/tmp/$LOGNAME"
  mkdir -p -m 700 "$TMPDIR"
fi

TMPPREFIX="${TMPDIR%/}/zsh"

#
# Custom env variables
#

export PROJECTS="${HOME}/code"
[[ ! -d "$PROJECTS" ]] && mkdir -p ${PROJECTS}

[[ -f ~/.zsh_base16_theme ]] && . ~/.zsh_base16_theme
