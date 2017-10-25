# simple afk command to invoke screensaver from CLI.



function _macos_afk() {
  local app_name
  app_name="ScreenSaverEngine.app"
  local sierra_screensaver_location
  sierra_screensaver_location="/System/Library/Frameworks/ScreenSaver.framework/Versions/A/Resources/${app_name}"
  # On macOS Sierra, the screensaver has to be acessed directly. On other versions, just try to open
  # the app by name
  if [[ -f $sierra_screensaver_location ]]; then
    /usr/bin/open ${sierra_screensaver_location}
  else
    /usr/bin/open -a $app_name
  fi
}

function _linux_afk() {
    if (( $+commands[xdg-screensaver] )); then
        $commands[xdg-screensaver] lock
    else
        echo "This distro is not supported yet. :("
    fi
}
function afk() {
    if is_macos; then; _macos_afk; fi;
    if is_linux; then; _linux_afk; fi;
}
