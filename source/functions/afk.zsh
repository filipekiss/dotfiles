# simple afk command to invoke screensaver from CLI. MacOS only for now

is_macos || return 0


function afk() {
  /usr/bin/open /System/Library/Frameworks/ScreenSaver.framework/Versions/A/Resources/ScreenSaverEngine.app
}
