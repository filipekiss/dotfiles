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
zplug "Eriner/zim", depth:1, use:"init.zsh", hook-build:"ln -sf $ZPLUG_REPOS/Eriner/zim ~/.zim"
zplug "noveumdois/nine12", as:theme

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
# Tools
#####################################

# Homebrew options
export HOMEBREW_INSTALL_BADGE="🍕"
export HOMEBREW_NO_ANALYTICS=1


#####################################
# Source config and aliases and stuff
#####################################
DOTFILES_BIN=$(which dotfiles)
if [[ $DOTFILES_BIN ]]; then
  source $DOTFILES_BIN "source"
  for config ($DOTFILES/source/config/*.zsh) source $config
  for func ($DOTFILES/source/functions/*.zsh) source $func
  e_success "${RESET}Dotfiles sourced!"
fi
