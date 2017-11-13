fzf-down() {
  fzf --height 50% "$@" --border
}

# # https://github.com/junegunn/fzf/wiki/Examples#z
# fuzzy z
unalias z 2> /dev/null
z() {
  if [[ -z "$*" ]]; then
    cd "$(_z_cmd -l 2>&1 | fzf +s --tac | sed 's/^[0-9,.]* *//')"
  else
    _last_z_args="$@"
    _z_cmd "$@"
  fi
}

zz() {
  cd "$(_z_cmd -l 2>&1 | sed 's/^[0-9,.]* *//' | fzf -q ${_last_z_args:-''})"
}


# fstash - easier way to deal with stashes
# type fstash to get a list of your stashes
# ctrl-a applies the selected stash
# ctrl-d shows a diff of the stash against your current HEAD
# ctrl-b checks the stash out as a branch, for easier merging
# ctrl-s drops the current stash
#
# Options available
# FSTASH_BRANCH_PREFIX      The prefix used to created the branch from stash. Default is `stash-`
# FSTASH_APPLY   If equals "DROP" will 'git stash pop' the commit for dropping after adding.
# Otherwise will just apply the stash
fstash() {
  emulate -L sh
  local out q k sha
  while out=$(
    git stash list --pretty="%C(yellow)%gd %C(yellow)%h %>(14)%Cgreen%cr %C(blue)%gs" |
    fzf --ansi --no-sort --query="$q" --print-query \
        --header "Ctrl-a: apply stash | Ctrl-d: diff | Ctrl-b: create branch | Ctrl-s: drop | Ctrl-p: Pop" \
      --preview "echo {} | grep -o '[a-f0-9]\{7\}' | head -1 |
                 xargs -I % sh -c 'git stash show --color=always % | head -200 '" \
        --expect=ctrl-d,ctrl-b,ctrl-s,ctrl-a,ctrl-p);
  do
    out=( "${(@f)out}")
    q="${out[0]}"
    k="${out[1]}"
    stashLine="${out[-1]}"
    stashIdx="${stashLine%% *}"
    sha="${stashLine#${stashIdx} }"
    sha="${sha%% *}"
    [[ -z "$sha" ]] && continue
    if [[ "$k" == 'ctrl-d' ]]; then
      git diff $sha
    elif [[ "$k" == 'ctrl-b' ]]; then
      git stash branch "${FSTASH_BRANCH_PREFIX:-stash-}$sha" $sha
      break;
    elif [[ "$k" == 'ctrl-s' ]]; then
      git stash drop $stashIdx
    elif [[ "$k" == 'ctrl-a' ]]; then
      git stash apply $sha
      break;
    elif [[ "$k" == 'ctrl-p' ]]; then
      git stash pop $stashIdx
      break;
    fi
  done
}


