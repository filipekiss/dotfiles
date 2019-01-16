# This will read the location of this file, that should be right next
# to rc.d folder
# This will always point to the source file and not the symlink location
export DOTFILES="${HOME}/.dotfiles"
export ZDOTDIR="${${(%):-%N}:A:h}"
export XDG_CONFIG_HOME="${HOME}/.config"
export GOPATH="${HOME}/.go"

[[ -x /usr/local/bin/brew ]] && export HOMEBREW_ROOT=$(/usr/local/bin/brew --prefix)

# Ensure that a non-login, non-interactive shell has a defined environment.
# (Only once) if it was not sourced before, becuase .zshenv is always sourced
if [[ ( "$SHLVL" -eq 1 && ! -o LOGIN ) && -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprofile"
fi
