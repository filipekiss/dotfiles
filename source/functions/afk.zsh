# simple afk command to invoke screensaver from CLI. MacOS only for now

is_macos || return 0


function afk() {
  local sierra_screensaver_location
  sierra_screensaver_location="/System/Library/Frameworks/ScreenSaver.framework/Versions/A/Resources/ScreenSaverEngine.app"
  local app_name
  app_name="ScreenSaverEngine.app"
  # On macOS Sierra, the screensaver has to be acessed directly. On other versions, just try to open
  # the app by name
  if [[ -f $sierra_screensaver_location ]]; then
    /usr/bin/open /System/Library/Frameworks/ScreenSaver.framework/Versions/A/Resources/ScreenSaverEngine.app
  else
    /usr/bin/open -a $app_name
  fi
}
