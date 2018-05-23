#
# User configuration sourced by login shells
#

# Compile zshrc and completions for faster startup
# https://github.com/ahmedelgabri/dotfiles/blob/master/zsh/zshrc.d/.zlogin
(
  local dir file
  setopt LOCAL_OPTIONS EXTENDED_GLOB
  autoload -U zrecompile

  # zcompile the completion cache; siginificant speedup
  zrecompile -pq ${ZDOTDIR:-${HOME}}/${zcompdump_file:-.zcompdump} &> /dev/null

  # zcompile .zshrc
  zrecompile -pq ${ZDOTDIR:-${HOME}}/.zshrc &> /dev/null
) &!
