# ------------------------------------------------------------
# Source config and aliases and stuff
# ------------------------------------------------------------

DOTFILES_BIN=$(which dotfiles)
if [[ $DOTFILES_BIN ]]; then
  source $DOTFILES_BIN "source"
  for config ($DOTFILES/config/zsh/zshrc.d/config/*.zsh) source $config
  for func ($DOTFILES/config/zsh/zshrc.d/functions/*.zsh) source $func
fi

# ------------------------------------------------------------
# Source ZSH Plugins, modules and shell theme
# ------------------------------------------------------------
source "${ZMODULES}/filipekiss/pure/async.zsh"
source "${ZMODULES}/filipekiss/pure/pure.zsh"
source "${ZMODULES}/chriskempson/base16-shell/scripts/base16-${ZSH_BASE16_THEME:-gruvbox-dark-soft}.sh"
source "${ZMODULES}/zsh-users/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "${ZMODULES}/zdharma/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
source "${ZMODULES}/zsh-users/zsh-history-substring-search/zsh-history-substring-search.zsh"

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

# Ignore some commands and set history size
HISTORY_IGNORE='(ls|ls *|cd|cd -|-|clear|pwd|exit|date|* —help)'
HISTSIZE=1000000
SAVEHIST=$HISTSIZE


# ------------------------------------------------------------
# Tools
# ------------------------------------------------------------

# FZF - https://github.com/junegunn/fzf
export FZF_DEFAULT_OPTS='--min-height 30 --bind esc:cancel --height 50% --border --reverse --tabstop 2 --multi --margin 0,3,3,3 --preview-window wrap'
export FZF_DEFAULT_COMMAND='\rg --no-messages --files --hidden --follow --glob "!.git/*"'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'"
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview' --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort' --header 'Press CTRL-Y to copy command into clipboard' --border"
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

# Homebrew options
export HOMEBREW_INSTALL_BADGE="⚗️"
export HOMEBREW_NO_ANALYTICS=1

# Z (Autojumtp)
source "${ZMODULES}/filipekiss/z/z.sh"

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

[[ -f ${HOME}/.zshrc.local ]] && source $HOME/.zshrc.local
