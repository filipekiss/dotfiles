fzf-down() {
  fzf --height 50% "$@"
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


# fshow - git commit browser
fshow() {
  git log --graph --color=always \
      --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
  fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
      --header "Press CTRL-S to toggle sort" \
      --preview "echo {} | grep -o '[a-f0-9]\{7\}' | head -1 |
                 xargs -I % sh -c 'git show --color=always % | head -200 '" \
      --bind "enter:execute:echo {} | grep -o '[a-f0-9]\{7\}' | head -1 |
              xargs -I % sh -c 'vim fugitive://\$(git rev-parse --show-toplevel)/.git//% < /dev/tty'"
}

# fco - checkout git branch/tag
fco() {
  local tags branches target
  tags=$(git tag | awk '{print "\x1b[31;1mtag\x1b[m\t" $1}') || return
  branches=$(
    git branch --all | grep -v HEAD             |
    sed "s/.* //"    | sed "s#remotes/[^/]*/##" |
    sort -u          | awk '{print "\x1b[34;1mbranch\x1b[m\t" $1}') || return
  target=$(
    (echo "$tags"; echo "$branches") | sed '/^$/d' |
    fzf-down --no-hscroll --reverse --ansi +m -d "\t" -n 2 -q "$*") || return
  git checkout $(echo "$target" | awk '{print $2}')
}
