fzf-down() {
  fzf-tmux --height 50% "$@" --border
}

# # https://github.com/junegunn/fzf/wiki/Examples#z
# fuzzy z
unalias z 2> /dev/null
z() {
  if [[ -z "$*" ]]; then
    cd "$(_z_cmd -l 2>&1 | fzf-tmux +s --tac | sed 's/^[0-9,.]* *//')"
  else
    _last_z_args="$@"
    _z_cmd "$@"
  fi
}

zz() {
  cd "$(_z_cmd -l 2>&1 | sed 's/^[0-9,.]* *//' | fzf-tmux -q ${_last_z_args:-''})"
}


# fshow - git commit browser
fshow() {
  git log --graph --color=always \
      --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
  fzf-tmux --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
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
# fbr - checkout git branch
# fbr() {
#   local branches target
#   branches=$(
#     git branch --all | grep -v HEAD             |
#     sed "s/.* //"    | sed "s#remotes/[^/]*/##" |
#     sort -u          | awk '{print "\x1b[34;1mbranch\x1b[m\t" $1}') || return
#   target=$(
#     (echo "$branches") | sed '/^$/d' |
#     fzf-down --no-hscroll --reverse --ansi +m -d "\t" -n 2 -q "$*") || return
#   git checkout $(echo "$target" | awk '{print $2}')
# }

fbr() {
  local branches branch
  branches=$(git for-each-ref --count=30 --sort=-committerdate refs/heads/ --format="%(refname:short)") &&
  branch=$(echo "$branches" |
           fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}
# ftag - checkout git tag
ftag() {
  local tags target
  tags=$(git tag | awk '{print "\x1b[31;1mtag\x1b[m\t" $1}') || return
  target=$(
    (echo "$tags") | sed '/^$/d' |
    fzf-down --no-hscroll --reverse --ansi +m -d "\t" -n 2 -q "$*") || return
  git checkout $(echo "$target" | awk '{print $2}')
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
    fzf-tmux --ansi --no-sort --query="$q" --print-query \
        --header "Ctrl-a to apply stash | Ctrl-d to diff against current HEAD | Ctrl-b to create branch | Ctrl-s to drop selected stash" \
      --preview "echo {} | grep -o '[a-f0-9]\{7\}' | head -1 |
                 xargs -I % sh -c 'git stash show --color=always % | head -200 '" \
        --expect=ctrl-d,ctrl-b,ctrl-s,ctrl-a);
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
      break;
    elif [[ "$k" == 'ctrl-a' ]]; then
      if [[ ${FSTASH_APPLY:-apply} == "DROP" ]]; then
        git stash pop $stashIdx
        break;
      else
        git stash apply $sha
        break;
      fi
    fi
  done
}


# fgr - grep with preview and fzf
# USAGE: fgr <pattern> <files>
fgr() {
    # emulate -L sh
    local grepper pattern files target
    [[ -z "$1" || -z "$2" ]] && echo "USAGE: fgr <pattern> <files>" && return
    pattern="$1"
    shift
    files="$@"
    grepper=$commands[grep]
    # Use ripgrep if available
    [[ $+commands[rg] ]] && grepper=$commands[rg]
    IFS=$'\n' target=($(
    ${grepper} -lirn "${pattern}" ${files} |
    fzf --ansi --no-sort --multi --exit-0\
        --preview="${grepper} -C 3 --pretty -in  \"${pattern}\" {}" \
        --header "Enter to send filename to CLI"))
    [[ -n $target ]] && echo -n "$target"
}


# select fzf session
# if you're inside a tmux session already, will switch-client. If not, will attach to session
fs() {
  local session
  HAS_TMUX_SESSION=false
  # Get the TMUX session list as an array
  local session_list=($(tmux list-sessions -F "#{session_name}" 2>/dev/null))
  [[ -n $session_list ]] && HAS_TMUX_SESSION=true
  if [[ $HAS_TMUX_SESSION == false ]]; then
      tm "$1" "TMUXP - No TMUX session found. Pick one"
      return
  fi
  # By default, use attach session
  change="attach-session"
  # If currently inside a TMUX session, remove that session from the list and use switch-client
  # instead of attach-session
  if [[ -n "$TMUX" ]]; then
    change="switch-client"
    local current_session=$(tmux display-message -p '#S')
    # remove current session from session list. see https://stackoverflow.com/a/25172688/708359
    session_list[$session_list[(i)$current_session]]=()
  fi
  # If only one session is open, invokes tm() to open a new session
  if [[ -z $session_list || -z "$TMUX" && ${#session_list} == 1 ]]; then
      tm "$1" "TMUXP - Sessions with a * next to their name are already loaded"
      return
  fi
  session=$(echo ${(F)session_list} | \
    fzf --query="$1" --header="TMUX - Open sessions" --exit-0 --select-1) &&
  tmux $change -t "$session"
}

tm() {
    [[ $+commands[tmuxp] ]] || return
    local HEADER_MESSAGE="TMUXP - Select a tmux session to load/attach to"
    local LOADED_SESSIONS=($(tmux list-sessions -F "#{session_name}" 2>/dev/null))
    [[ -n $2 ]] && HEADER_MESSAGE="$2"
    # Find our tmuxp sessions
    TMUXP_SESSIONS=($(find ${HOME}/.tmuxp -not -type d))
    # :t will remove leading path (like basename) and :r will remove file extension
    TMUXP_SESSIONS=(${TMUXP_SESSIONS:t:r})
    # Do some magic if we have TMUX sessions already loaded
    if [[ -n $LOADED_SESSIONS ]]; then
        # Create an array with elements that are in both TMUXP_SESSIONS and LOADED_SESSIONS array
        ACTIVE_TMUXP_SESSIONS=(${TMUXP_SESSIONS:*LOADED_SESSIONS})
        # Create an array with sessions that are in TMUXP_SESSIONS but not in LOADED_SESSIONS
        INACTIVE_TMUXP_SESSIONS=(${TMUXP_SESSIONS:|LOADED_SESSIONS})
        # Reset TMUXP_SESSIONS array
        TMUXP_SESSIONS=()
        # Remove sessions that are available on TMUXP from the loaded sessions - will add those in
        # the next step
        TMUXP_SESSIONS+=(${LOADED_SESSIONS:|ACTIVE_TMUXP_SESSIONS})
        # Add the sessions from TMUXP that are active and add an asterisk next to their name
        TMUXP_SESSIONS+=(${^ACTIVE_TMUXP_SESSIONS}"*")
        # Add the sessions from TMUXP that are not open
        TMUXP_SESSIONS+=(${INACTIVE_TMUXP_SESSIONS})
        # Sort sessions array
        TMUXP_SESSIONS=(${(i)TMUXP_SESSIONS})
        # Only overwrite the header message if no header message was passed as argument
        [[ -z $2 ]] && HEADER_MESSAGE="TMUXP - Sessions with a * next to their name are already loaded"
    fi
    tmux_session_name=$(echo ${(iF)TMUXP_SESSIONS} | \
        fzf --query="$1" --header="$HEADER_MESSAGE" --exit-0 --select-1 | cut -d '*' -f1)
    [[ -n $tmux_session_name ]] && tmuxp load "$tmux_session_name"
}

