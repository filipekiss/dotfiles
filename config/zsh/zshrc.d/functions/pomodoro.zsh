HAS_POMODORO_BIN=$commands[pomodoro]
CACHED_VARS_FILE=$HOME/.dot_var_cache
[[ -f $CACHED_VARS_FILE ]] && source $CACHED_VARS_FILE
[[ -z $HAS_FOCUS_APP ]] && HAS_FOCUS_APP=$(find /Applications/Setapp /Applications -maxdepth 1 -iname Focus.app -print -quit -maxdepth 1 2>/dev/null) && echo "export HAS_FOCUS_APP=\"$HAS_FOCUS_APP\""| tee -a $CACHED_VARS_FILE > /dev/null

[[ -z $HAS_FOCUS_APP && -z $HAS_POMODORO_BIN ]] && exit 0

unalias pomo 2>/dev/null

function pomo() {
    POMO_TIMER='25m'
    [[ $HAS_FOCUS_APP ]] && open 'focus://focus?minutes='$POMO_TIMER && return
    [[ $HAS_POMODORO_BIN ]] && pomodoro $POMO_TIMER
}
