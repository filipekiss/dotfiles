#  vim: set ts=4 sw=4 tw=80 ft=zsh et :
#
# http://junegunn.kr/2016/07/fzf-git/
#

# GIT heart FZF
# -------------

function is_in_git_repo() {
  git rev-parse HEAD > /dev/null 2>&1
}
# Show git modified files
function fzf_gg() {
  is_in_git_repo || return
  git -c color.status=always status --short |
  fzf-down -m --ansi --select-1 --exit-0 --nth 2..,.. \
    --preview-window up:50%:wrap \
    --preview '(git diff --color=always -- {-1} | sed 1,4d; cat {-1}) | head -500' |
  cut -c4- | sed 's/.* -> //'
}
# Show git conflicted files
function fzf_gu() {
  is_in_git_repo || return
  git ls-files -u | awk '{print $4}' | sort -u |
  fzf-down -m --ansi --select-1 --exit-0 --nth 2..,.. \
    --preview-window up:50%:wrap \
    --preview '(git diff --color=always -- {-1} | sed 1,4d; cat {-1}) | head -500' |
   sed 's/.* -> //'
}
# Git local branches, ordered by last activity
function fzf_gb() {
  is_in_git_repo || return
  branches=$(git for-each-ref --sort=committerdate refs/heads --format='%(refname:short) (last activity: %(color:green)%(committerdate:relative)%(color:reset))')
  echo $branches |
  fzf-down --ansi --multi --tac --preview-window right:60% \
    --preview-window up:50%:wrap \
    --preview 'git log --color=always --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" $(echo {} | cut -d" " -f1)' |
  cut -d' ' -f1
}
# Git remote branches, ordered by last activity
function fzf_gf() {
  is_in_git_repo || return
  branches=$(git for-each-ref --sort=committerdate refs/remotes --format='%(refname:short) (last activity: %(color:green)%(committerdate:relative)%(color:reset))')
  echo $branches |
  fzf-down --ansi --multi --tac --preview-window right:60% \
    --preview-window up:50%:wrap \
    --preview 'git log --color=always --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" $(echo {} | cut -d" " -f1)' |
  cut -d' ' -f1
}
# Git tags
function fzf_gt() {
  is_in_git_repo || return
  git tag --sort -version:refname |
  fzf-down --multi --preview-window right:70% \
    --preview-window up:50%:wrap \
    --preview 'git show --color=always {} | head -200'
}
# Git commit hashes
function fzf_gh() {
  is_in_git_repo || return
  local currentBranch=$(git rev-parse --abbrev-ref HEAD)
  git log --date=short --format="%C(green)%C(bold)%cd %C(auto)%h%d %s (%an)" --color=always "${currentBranch}" |
  fzf-down --ansi --no-sort --reverse --multi --bind 'ctrl-s:toggle-sort' \
    --header 'Press CTRL-S to toggle sort' \
    --preview-window up:50%:wrap \
    --preview 'grep -o "[a-f0-9]\{7,\}" <<< {} | xargs git show --color=always | head -200' |
  grep -o "[a-f0-9]\{7,\}"
}
# Git remotes
function fzf_gr() {
  is_in_git_repo || return
  git remote -v | awk '{print $1 "\t" $2}' | uniq |
  fzf-down --tac \
    --preview 'git log --oneline --graph --color=always --date=short --pretty="format:%C(auto)%cd %h%d %s" {1} | head -200' |
  cut -d$'\t' -f1
}

# Git stash
function fzf-gs-widget() {
  is_in_git_repo || return
  emulate -L sh
  local out q k sha
  while out=$(
    git stash list --pretty="%C(yellow)%gd %C(yellow)%h %>(14)%Cgreen%cr %C(blue)%gs" |
    fzf-down --ansi --no-sort --query="$q" --print-query \
        --preview-window up:50%:wrap \
        --header "Ctrl-a: apply stash | Ctrl-d: diff | Ctrl-b: create branch | Ctrl-s: drop | Ctrl-p: Pop" \
        --preview "echo {} | grep -o '[a-f0-9]\{7\}' | head -1 | xargs -I % sh -c 'git stash show --color=always % | head -200 '" \
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
  zle reset-prompt
}

function join-lines() {
  local item
  while read item; do
    echo -n "${(q)item} "
  done
}

function bind-git-helper() {
  local char
  for c in $@; do
    eval "function fzf-g$c-widget() { local result=\$(fzf_g$c | join-lines); zle reset-prompt; LBUFFER+=\$result }"
    eval "zle -N fzf-g$c-widget"
    eval "bindkey '^g^$c' fzf-g$c-widget"
  done
}

bind-git-helper g b t r h f u
unset -f bind-git-helper
# Stash helper works kinda different, so he needs it's own binding rule
zle -N fzf-gs-widget
bindkey '^g^s' fzf-gs-widget
