# diff-so-fancy no index wrapper
#
(( $+commands[diff-so-fancy] )) || return 0

unalias diff 2> /dev/null

function diff() {
  if [[ $# -eq 0 ]]; then
      echo "USAGE: diff file1 file2"
  else
      if [[ $+commands[git] ]]; then
          git diff --no-index $@
      else
          diff -u $@
      fi
  fi
}

# Autocomplete as if typing `brew cask`
compdef '_files' diff

