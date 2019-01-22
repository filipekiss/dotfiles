# simple afk command to invoke screensaver from CLI.



function _macos_afk() {
  local app_name
  app_name="ScreenSaverEngine.app"
  local sierra_screensaver_location
  sierra_screensaver_location="/System/Library/Frameworks/ScreenSaver.framework/Versions/A/Resources/${app_name}"
  # On macOS Sierra, the screensaver has to be acessed directly. On other versions, just try to open
  # the app by name
  if [[ -f $sierra_screensaver_location ]]; then
    /usr/bin/open -W ${sierra_screensaver_location} && _welcome_back
  else
    /usr/bin/open -W -a $app_name && _welcome_back
  fi
}

function _linux_afk() {
    if (( $+commands[xdg-screensaver] )); then
        $commands[xdg-screensaver] lock && _welcome_back
    else
        echo "This distro is not supported yet. :("
    fi
}

function _welcome_back() {
    integer _elapsed
    local human
    (( _elapsed = $EPOCHSECONDS - ${_afk_start_time:-$EPOCHSECONDS} ))
	local days=$(( _elapsed / 60 / 60 / 24 ))
	local hours=$(( _elapsed / 60 / 60 % 24 ))
	local minutes=$(( _elapsed / 60 % 60 ))
	local seconds=$(( _elapsed % 60 ))
	(( days > 0 )) && human+="${days}d "
	(( hours > 0 )) && human+="${hours}h "
	(( minutes > 0 )) && human+="${minutes}m "
	human+="${seconds}s"

    if [[ $_elapsed -gt 60 ]]; then
        echo "Welcome back. You've been away for ${human}"
    else
        if [[ $_elapsed == 0 ]]; then
            echo "Welcome back."
        else
            echo "Welcome back. That was quick! I missed you all the ${_elapsed} seconds you were gone."
        fi
    fi
}

function afk() {
    _afk_start_time=$EPOCHSECONDS
    if is_macos; then; _macos_afk; fi;
    if is_linux; then; _linux_afk; fi;
}
