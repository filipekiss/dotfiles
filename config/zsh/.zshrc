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
zplug "knu/z", use:"z.sh", depth:1, defer:1
zplug "b4b4r07/emoji-cli"
zplug "docker/cli", use:contrib/completion/zsh
zplug "docker/compose", use:contrib/completion/zsh

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

# FZF - https://github.com/junegunn/fzf
export FZF_DEFAULT_OPTS='--min-height 30 --bind esc:cancel --height 50% --border --reverse --tabstop 2 --multi --margin 0,3,3,3'
export FZF_DEFAULT_COMMAND='rg --no-messages --files --hidden --follow --glob "!.git/*"'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'"
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview' --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort' --header 'Press CTRL-Y to copy command into clipboard' --border"
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Homebrew options. See https://github.com/Homebrew/brew/blob/master/docs/Tips-N%27-Tricks.md#hiding-the-beer-mug-emoji-when-finishing-a-build
export HOMEBREW_INSTALL_BADGE="⚗️"
export HOMEBREW_NO_ANALYTICS=1


#####################################
# Source config and aliases and stuff
#####################################
DOTFILES_BIN=$(which dotfiles)
if [[ $DOTFILES_BIN ]]; then
  source $DOTFILES_BIN "source"
  for config ($DOTFILES/source/config/*.zsh) source $config
  for func ($DOTFILES/source/functions/*.zsh) source $func
fi

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
