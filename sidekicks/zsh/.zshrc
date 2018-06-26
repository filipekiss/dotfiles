# ------------------------------------------
# ZPLUGIN https://github.com/zdharma/zplugin
# ------------------------------------------
ZPLUGIN_PATH="$HOME/.zplugin"
if [[ ! -f ${ZPLUGIN_PATH}/bin/zplugin.zsh ]]; then
  if (( $+commands[git] )); then
    git clone https://github.com/zdharma/zplugin.git ${ZPLUGIN_PATH}/bin
  else
    echo 'git not found' >&2
    exit 1
  fi
fi

source ${ZPLUGIN_PATH}/bin/zplugin.zsh

zplugin ice compile"(pure|async).zsh" src"pure.zsh" pick"async.zsh"
zplugin light "filipekiss/pure"

zplugin ice "filipekiss/z" pick"z.sh"
zplugin light "filipekiss/z"

zplugin light "zsh-users/zsh-history-substring-search"

# https://github.com/zdharma/zplugin#turbo-mode-zsh--53
zplugin ice wait"1" lucid atload"_zsh_autosuggest_start"
zplugin light "zsh-users/zsh-autosuggestions"

zplugin ice wait"0" lucid blockf
zplugin light "zsh-users/zsh-completions"

zplugin ice wait"0" lucid atinit"zpcompinit; zpcdreplay"
zplugin light "zdharma/fast-syntax-highlighting"


zplugin ice lucid blockf wait'[[ -n ${ZLAST_COMMANDS[(r)dock*]} ]]'
zplugin light "docker/cli"

zplugin ice lucid blockf wait'[[ -n ${ZLAST_COMMANDS[(r)docker-*]} ]]'
zplugin light "docker/compose"

zplugin ice wait"0" lucid as"program" mv"zemojify -> emojify" pick"zemojify" atload"export PAGER='emojify |  $PAGER'"
zplugin light "filipekiss/zemojify"

zplugin ice lucid wait'[[ -n ${ZLAST_COMMANDS[(r)zshe*]} ]]'
zplugin light "filipekiss/zshero"

# ------------------------------------------------------------
# Source config and aliases and stuff
# ------------------------------------------------------------

DOTFILES_BIN=$(which dotfiles)
if [[ $DOTFILES_BIN ]]; then
  source $DOTFILES_BIN "source"
  for func (${ZDOTDIR}/rc.d/functions/*.zsh) source $func
fi

# ------------------------------------------------------------
# Bind keys to substring search
# See https://git.io/vAFpR
# ------------------------------------------------------------
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
# Ensure j/k working in vim mode
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# ------------------------------------------------------------
# ZSH Settings
# ------------------------------------------------------------

ZSH_AUTOSUGGEST_USE_ASYNC=true

# ------------------------------------------------------------
# Tools
# ------------------------------------------------------------

# FZF - https://github.com/junegunn/fzf
FZF_CMD='fd --hidden --follow --no-ignore-vcs --exclude ".git/*" --exclude "node_modules/*"'
export FZF_DEFAULT_OPTS='--min-height 30 --bind esc:cancel --height 50% --border --reverse --tabstop 2 --multi --margin 0,3,3,3 --preview-window wrap'
export FZF_DEFAULT_COMMAND="$FZF_CMD --type f"
export FZF_CTRL_T_COMMAND="$FZF_CMD"
export FZF_CTRL_T_OPTS="--preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'"
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview' --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort' --header 'Press CTRL-Y to copy command into clipboard' --border"
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"
export FZF_ALT_C_CMD="$FZF_CMD --type d ."

# Homebrew options
export HOMEBREW_INSTALL_BADGE="⚗️"
export HOMEBREW_NO_ANALYTICS=1

# Direnv
if [ $(command -v direnv) ]; then
    export NODE_VERSIONS="${HOME}/.node-versions"
    export NODE_VERSION_PREFIX=""
    eval "$(direnv hook zsh)"
fi

# ------------------------------------------------------------
# Random prompt symbol
# ------------------------------------------------------------

SYMBOLS=(
    "❯"
    "→"
    "»"
    "৸"
)

ERROR_SYMBOLS=(
    "⎋"
    "⊘"
    "⊗"
    "×"
)

export PURE_PROMPT_SYMBOL="${SYMBOLS[$RANDOM % ${#SYMBOLS[@]}]}"
export PURE_PROMPT_SYMBOL_ERROR="${ERROR_SYMBOLS[$RANDOM % ${#ERROR_SYMBOLS[@]}]}"

# ------------------------------------------------------------
# Load custom configs
# ------------------------------------------------------------

[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh
[[ -f ${HOME}/.zshrc.local ]] && source $HOME/.zshrc.local
[[ -z "${HOMEBREW_GITHUB_API_TOKEN}" ]] && echo "⚠ HOMEBREW_GITHUB_API_TOKEN not set. Set it on ~/.zshrc.local"
[[ -z "${GITHUB_TOKEN}" ]] && echo "⚠ GITHUB_TOKEN not set. Set it on ~/.zshrc.local"
[[ -z "${GITHUB_USER}" ]] && echo "⚠ GITHUB_USER not set. Set it on ~/.zshrc.local"
