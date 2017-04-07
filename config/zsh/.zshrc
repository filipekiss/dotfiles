###############################
# zPlug
###############################

if [[ ! -f ~/.zplug/init.zsh ]]; then
  if (( $+commands[git] )); then
    git clone https://github.com/zplug/zplug ~/.zplug
  else
    echo 'git not found' >&2
    exit 1
  fi
fi

source ~/.zplug/init.zsh

###############################
# zPlug modules
###############################

zplug "zplug/zplug", hook-build:"zplug --self-manage"
zplug "zimframework/zim", depth:1, use:"init.zsh", hook-build:"ln -sf $ZPLUG_ROOT/repos/zimframework/zim ~/.zim"

###############################
# Zim Modules
###############################

zmodules=(
  directory
  environment
  history
  meta
  input
  utility
  spectrum
  syntax-highlighting
  history-substring-search
  prompt
  completion
)

zprompt_theme='steeef'
ztermtitle="%n@%m:%~"
zdouble_dot_expand="true"
zhighlighters=(main brackets pattern cursor root)

###############################
# Install missing modules
###############################

if ! zplug check --verbose; then
  printf "Install? [y/N]: "
  if read -q; then
    echo; zplug install
  fi
fi

zplug load

# Ignore some commands and set history size
HISTIGNORE="ls:ls *:cd:cd -:pwd;exit:date:* --help"
HISTSIZE=100000
SAVEHIST=$HISTSIZE


#####################################
# Source config and aliases and stuff
#####################################
DOTFILES_BIN=$(which dotfiles)
if [[ $DOTFILES_BIN ]]; then
  source $DOTFILES_BIN "source"
  for config ($DOTFILES/config/zsh/config/*.zsh) source $config
  for func ($CONFIG/config/zsh/config/functions/*.zsh) source $func
fi
