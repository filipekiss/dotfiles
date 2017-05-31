#
# Executes commands at login pre-zshrc.
#

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
#

# Set Atom as editor or use vim if atom is not available
(( $+commands[atom] )) && export EDITOR="$commands[atom] --wait" || export EDITOR=vim
export VISUAL=$EDITOR
export GIT_EDITOR=$EDITOR
export PAGER='less'

#
# Language
#

if [[ -z "$LANG" ]]; then
  export LANG='en_US.UTF-8'
  export LC_ALL='en_US.UTF-8'
fi

##############################################################
# PATH.
##############################################################
fpath=(
  '/usr/local/share/zsh/site-functions'
  $fpath
)

# GNU Coreutils
export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"

# Ensure path arrays do not contain duplicates.
typeset -gU cdpath fpath mailpath path

# Set the list of directories that Zsh searches for programs.
path=(
  /usr/local/{bin,sbin}
  /usr/local/opt/coreutils/libexec/gnubin
  /usr/local/Cellar/git
  ${HOME}/.dotfiles/bin
  $path
)

# Add yarn bin to path
if (( $+commands[yarn] )); then
  path+=($(yarn global bin))
fi

export PYTHONPATH=/usr/local/lib/python2.7/site-packages:$PYTHONPATH

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
export ATOM_PACKAGES_FILE=$HOME/.dotfiles/config/atom/.atom/my-packages
