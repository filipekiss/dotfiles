# tm() function does a lot of things (kinda)
#
# It will allow you to switch between open tmux sessions easil. If you have tmuxp, it will also show
# you a list of tmuxp sessions for you to choose and load

tm() {
    # Will do nothing if there's no TMUXP binary
    (( $+commands[tmuxp] )) || return
    local HEADER_MESSAGE="TMUXP - Select a tmux session to load"
    local LOADED_SESSIONS=($(tmux list-sessions -F "#{session_name}" 2>/dev/null))
    [[ -n $2 ]] && HEADER_MESSAGE="$2"
    # Find our tmuxp sessions
    TMUXP_SESSIONS=($(find ${HOME}/.tmuxp/ -not -type d))
    # :t will remove leading path (like basename) and :r will remove file extension
    TMUXP_SESSIONS=(${TMUXP_SESSIONS:t:r})
    # Keep this list unaltered. Will use it later
    TMUXP_LIST=($TMUXP_SESSIONS)
    # Do some magic if we have TMUX sessions already loaded
    if [[ -n $LOADED_SESSIONS ]]; then
        if [[ -n "$TMUX" ]]; then
            local current_session=$(tmux display-message -p '#S')
            # remove current session from session list. see https://stackoverflow.com/a/25172688/708359
            TMUXP_SESSIONS[$TMUXP_SESSIONS[(i)$current_session]]=()
        fi
        # Create an array with elements that are in both TMUXP_SESSIONS and LOADED_SESSIONS array
        ACTIVE_TMUXP_SESSIONS=(${TMUXP_SESSIONS:*LOADED_SESSIONS})
        # Create an array with sessions that are in TMUXP_SESSIONS but not in LOADED_SESSIONS
        INACTIVE_TMUXP_SESSIONS=(${TMUXP_SESSIONS:|LOADED_SESSIONS})
        # If inside tmux session, remove current session from list
        if [[ -n "$TMUX" ]]; then
            local current_session=$(tmux display-message -p '#S')
            # remove current session from session list. see https://stackoverflow.com/a/25172688/708359
            LOADED_SESSIONS[$LOADED_SESSIONS[(i)$current_session]]=()
        fi
        # Reset TMUXP_SESSIONS array
        TMUXP_SESSIONS=()
        # Remove sessions that are available on TMUXP from the loaded sessions - will add those in
        # the next step. Also add a double asterisk to indicaded loaded session that's not on TMUXP
        TMUXP_SESSIONS+=(${^LOADED_SESSIONS:|ACTIVE_TMUXP_SESSIONS}"*")
        # Add the sessions from TMUXP that are active and add an asterisk next to their name
        TMUXP_SESSIONS+=(${^ACTIVE_TMUXP_SESSIONS}"*")
        # Add the sessions from TMUXP that are not open
        TMUXP_SESSIONS+=(${INACTIVE_TMUXP_SESSIONS})
        # Sort sessions array
        TMUXP_SESSIONS=(${(i)TMUXP_SESSIONS})
        # Only overwrite the header message if no header message was passed as argument
        [[ -z $2 ]] && HEADER_MESSAGE="TMUXP - Sessions with a * next to their name are already loaded"
    fi
    # If the TMUXP Sessions is empty, there's only one session in tmux and we're already in it
    # Feedback and return
    if [[ -z $TMUXP_SESSIONS ]]; then
        [[ -n $current_session ]] && echo "You're alredy in ${current_session}. I'm done here"
        return
    fi
    tmux_session_name=$(echo ${(iF)TMUXP_SESSIONS} | \
        fzf --query="$1" --header="$HEADER_MESSAGE" --exit-0 --select-1 | cut -d '*' -f1)
    # If session is already loaded, use fs to change to it if we have more than one session
    [[ ${#TMUXP_SESSIONS} > 1 && -n $tmux_session_name && $LOADED_SESSIONS[(r)$tmux_session_name] = $tmux_session_name ]] && fs "$tmux_session_name" && return
    # Otherwise, load session from TMUXP
    [[ -n $tmux_session_name ]] && tmuxp load "$tmux_session_name"  && return
}

# Use fs() to fast-switch between open tmux sessions
# If only one session is currently running, invokes tm() so user can choose a TMUXP session to load
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
    fzf --query="$1" --header="TMUX - Open sessions" --exit-0 --select-1)
  [[ -n $session ]] && tmux $change -t "$session"
}
