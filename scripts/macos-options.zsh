# based on ~/.macos — https://mths.be/macos
# macOS-only stuff. Abort if not macOS.
(( ! $+functions[has_dotfiles_function] )) && [[ -e $HOME/.dotfiles/bin/dotfiles ]] && source $HOME/.dotfiles/bin/dotfiles "source"
(( ! $+functions[has_dotfiles_function] )) && echo "Something went wrong. Try again" && exit 1
is_macos || return 1


e_info 'Close any open System Preferences panes, to prevent them from overriding'
e_info 'settings we’re about to change'
osascript -e 'tell application "System Preferences" to quit'

e_info 'Ask for the administrator password upfront'
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

###############################################################################
# General UI/UX                                                               #
###############################################################################
e_header "General UI/UX"

# Set computer name (as done via System Preferences → Sharing)
#
e_info "Type in the machine name"
vared -p '  Machine Name:' -c machine_name
sudo scutil --set ComputerName "${machine_name}"
(( ! $+functions[regexp-replace] )) && autoload -U regexp-replace
regexp-replace machine_name '[^a-zA-Z0-9.-]' '-'
sudo scutil --set HostName "${machine_name:l}"
sudo scutil --set LocalHostName "${machine_name:l}"
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "${machine_name:l}"

e_info 'Set standby delay to 24 hours (default is 1 hour)'
sudo pmset -a standbydelay 86400

# Disable the sound effects on boot
# sudo nvram SystemAudioVolume=" "

e_info 'Disable transparency in the menu bar and elsewhere'
defaults write com.apple.universalaccess reduceTransparency -bool true

e_info 'Hide your desktop'
defaults write com.apple.finder CreateDesktop -bool false

e_info 'Hide the menubar unless you hover'
defaults write NSGlobalDomain _HIHideMenuBar -bool true

e_info 'Menu bar: hide the Time Machine icons'
# To view what you can hide and show just run `ls -la /System/Library/CoreServices/Menu\ Extras`
defaults -currentHost write dontAutoLoad -array \
	"/System/Library/CoreServices/Menu Extras/TimeMachine.menu" \
# Which items to show
defaults write com.apple.systemuiserver menuExtras -array \
	"/System/Library/CoreServices/Menu Extras/Bluetooth.menu" \
	"/System/Library/CoreServices/Menu Extras/AirPort.menu" \
	"/System/Library/CoreServices/Menu Extras/Battery.menu" \
	"/System/Library/CoreServices/Menu Extras/Clock.menu"

e_info 'Set highlight color to yellow'
defaults write NSGlobalDomain AppleHighlightColor -string "1.000000 0.937255 0.690196"

e_info 'Set sidebar icon size to medium'
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2

e_info 'Always show scrollbars'
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"
# Possible values: `WhenScrolling`, `Automatic` and `Always`

e_info 'Disable the over-the-top focus ring animation'
defaults write NSGlobalDomain NSUseAnimatedFocusRing -bool false

# Disable smooth scrolling
# (Uncomment if you’re on an older Mac that messes up the animation)
#defaults write NSGlobalDomain NSScrollAnimationEnabled -bool false

e_info 'Increase window resize speed for Cocoa applications'
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

e_info 'Expand save panel by default'
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

e_info 'Expand print panel by default'
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

e_info 'Save to disk (not to iCloud) by default'
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

e_info 'Automatically quit printer app once the print jobs complete'
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

e_info 'Disable the “Are you sure you want to open this application?” dialog'
defaults write com.apple.LaunchServices LSQuarantine -bool false

e_info 'Remove duplicates in the “Open With” menu (also see `lscleanup` alias)'
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user

e_info 'Display ASCII control characters using caret notation in standard text views'
e_info 'Try e.g. `cd /tmp; unidecode "\x{0000}" > cc.txt; open -e cc.txt`'
defaults write NSGlobalDomain NSTextShowsControlCharacters -bool true

e_info 'Disable Resume system-wide'
defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false

e_info 'Disable automatic termination of inactive apps'
defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true

# Disable the crash reporter
#defaults write com.apple.CrashReporter DialogType -string "none"

e_info 'Set Help Viewer windows to non-floating mode'
defaults write com.apple.helpviewer DevMode -bool true

# Fix for the ancient UTF-8 bug in QuickLook (https://mths.be/bbo)
# Commented out, as this is known to cause problems in various Adobe apps :(
# See https://github.com/mathiasbynens/dotfiles/issues/237
#echo "0x08000100:0" > ~/.CFUserTextEncoding

e_info 'Reveal IP address, hostname, OS version, etc. when clicking the clock'
e_info 'in the login window'
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

e_info 'Restart automatically if the computer freezes'
sudo systemsetup -setrestartfreeze on

e_info 'Never go into computer sleep mode'
sudo systemsetup -setcomputersleep Off > /dev/null

# Disable Notification Center and remove the menu bar icon
# launchctl unload -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist 2> /dev/null

e_info 'Disable automatic capitalization as it’s annoying when typing code'
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

e_info 'Disable smart dashes as they’re annoying when typing code'
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

e_info 'Disable automatic period substitution as it’s annoying when typing code'
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

e_info 'Disable smart quotes as they’re annoying when typing code'
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

e_info 'Disable auto-correct'
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Set a custom wallpaper image. `DefaultDesktop.jpg` is already a symlink, and
# all wallpapers are in `/Library/Desktop Pictures/`. The default is `Wave.jpg`.
#rm -rf ~/Library/Application Support/Dock/desktoppicture.db
#sudo rm -rf /System/Library/CoreServices/DefaultDesktop.jpg
#sudo ln -s /path/to/your/image /System/Library/CoreServices/DefaultDesktop.jpg

###############################################################################
# SSD-specific tweaks                                                         #
###############################################################################

# Disable hibernation (speeds up entering sleep mode)
# sudo pmset -a hibernatemode 0

# Remove the sleep image file to save disk space
# sudo rm /private/var/vm/sleepimage
# Create a zero-byte file instead…
# sudo touch /private/var/vm/sleepimage
# …and make sure it can’t be rewritten
# sudo chflags uchg /private/var/vm/sleepimage

###############################################################################
# Trackpad, mouse, keyboard, Bluetooth accessories, and input                 #
###############################################################################
e_header "Trackpad, mouse, keyboard, Bluetooth accessories, and input"

e_info 'Trackpad: enable tap to click for this user and for the login screen'
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

e_info 'Trackpad: map bottom right corner to right-click'
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
defaults -currentHost write NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 1
defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true

# Disable “natural” (Lion-style) scrolling
# defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

e_info 'Increase sound quality for Bluetooth headphones/headsets'
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

e_info 'Enable full keyboard access for all controls'
e_info '(e.g. enable Tab in modal dialogs)'
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

e_info 'Use scroll gesture with the Ctrl (^) modifier key to zoom'
defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true
defaults write com.apple.universalaccess HIDScrollZoomModifierMask -int 262144
e_info 'Follow the keyboard focus while zoomed in'
defaults write com.apple.universalaccess closeViewZoomFollowsFocus -bool true

e_info 'Disable press-and-hold for keys in favor of key repeat'
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

e_info 'Set a keyboard repeat rate'
defaults write NSGlobalDomain KeyRepeat -int 5
defaults write NSGlobalDomain InitialKeyRepeat -int 25

e_info 'Set language and text formats'
e_info 'You can set this on your mac via pref pane and use defaults read NSGlobalDomain AppleLanguages -array to read the values'
defaults write NSGlobalDomain AppleLanguages -array "en-BR" "pt-BR"
defaults write NSGlobalDomain AppleLocale -string "en_BR@currency=BRL"
defaults write NSGlobalDomain AppleMeasurementUnits -string "Centimeters"
defaults write NSGlobalDomain AppleMetricUnits -bool true

e_info 'Show language menu in the top right corner of the boot screen'
sudo defaults write /Library/Preferences/com.apple.loginwindow showInputMenu -bool true

e_info 'Set the timezone; see `sudo systemsetup -listtimezones` for other values'
sudo systemsetup -settimezone "America/Sao_Paulo" > /dev/null

# Stop iTunes from responding to the keyboard media keys
#launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist 2> /dev/null

###############################################################################
# Screen                                                                      #
###############################################################################
e_header "Screen"

e_info 'Require password immediately after sleep or screen saver begins'
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 30

e_info 'Save screenshots to the desktop'
defaults write com.apple.screencapture location -string "${HOME}/Desktop"

e_info 'Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)'
defaults write com.apple.screencapture type -string "png"

e_info 'Disable shadow in screenshots'
defaults write com.apple.screencapture disable-shadow -bool true

e_info 'Enable subpixel font rendering on non-Apple LCDs'
# Reference: https://github.com/kevinSuttle/macOS-Defaults/issues/17#issuecomment-266633501
defaults write NSGlobalDomain AppleFontSmoothing -int 1

e_info 'Enable HiDPI display modes (requires restart)'
sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool true

e_info 'Set screensaver to Aerials if installed'
[[ -e "${HOME}/Library/Screen Savers/Aerial.saver" ]] && defaults -currentHost write com.apple.screensaver moduleDict -dict moduleName "Aerial" path "/Users/filipekiss/Library/Screen Savers/Aerial.saver" type 0

###############################################################################
# Finder                                                                      #
###############################################################################
e_header "Finder"

e_info 'Finder: allow quitting via ⌘ + Q; doing so will also hide desktop icons'
defaults write com.apple.finder QuitMenuItem -bool true

e_info 'Finder: disable window animations and Get Info animations'
defaults write com.apple.finder DisableAllAnimations -bool true

e_info 'Set Home Folder as the default location for new Finder windows'
# For other paths, use `PfLo` and `file:///full/path/here/`
defaults write com.apple.finder NewWindowTarget -string "PfHm"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

e_info 'Show icons for hard drives, servers, and removable media on the desktop'
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

e_info 'Finder: show hidden files by default'
defaults write com.apple.finder AppleShowAllFiles -bool true

e_info 'Finder: show all filename extensions'
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

e_info 'Finder: show status bar'
defaults write com.apple.finder ShowStatusBar -bool true

e_info 'Finder: show path bar'
defaults write com.apple.finder ShowPathbar -bool true

e_info 'Display full POSIX path as Finder window title'
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

e_info 'Keep folders on top when sorting by name'
defaults write com.apple.finder _FXSortFoldersFirst -bool true

e_info 'When performing a search, search the current folder by default'
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

e_info 'Disable the warning when changing a file extension'
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

e_info 'Enable spring loading for directories'
defaults write NSGlobalDomain com.apple.springing.enabled -bool true

e_info 'Remove the spring loading delay for directories'
defaults write NSGlobalDomain com.apple.springing.delay -float 0

e_info 'Avoid creating .DS_Store files on network or USB volumes'
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

e_info 'Disable disk image verification'
defaults write com.apple.frameworks.diskimages skip-verify -bool true
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

e_info 'Automatically open a new Finder window when a volume is mounted'
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true

e_info 'Show item info near icons on the desktop and in other icon views'
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist

# Show item info to the right of the icons on the desktop
# /usr/libexec/PlistBuddy -c "Set DesktopViewSettings:IconViewSettings:labelOnBottom false" ~/Library/Preferences/com.apple.finder.plist

e_info 'Enable snap-to-grid for icons on the desktop and in other icon views'
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

e_info 'Increase grid spacing for icons on the desktop and in other icon views'
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist

e_info 'Increase the size of icons on the desktop and in other icon views'
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist

e_info 'Use list view in all Finder windows by default'
# Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

e_info 'Disable the warning before emptying the Trash'
defaults write com.apple.finder WarnOnEmptyTrash -bool false

e_info 'Enable AirDrop over Ethernet and on unsupported Macs running Lion'
defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true

# Enable the MacBook Air SuperDrive on any Mac
# sudo nvram boot-args="mbasd=1"

e_info 'Show the ~/Library folder'
chflags nohidden ~/Library

e_info 'Show the /Volumes folder'
sudo chflags nohidden /Volumes

e_info 'Remove Dropbox’s green checkmark icons in Finder'
file=/Applications/Dropbox.app/Contents/Resources/emblem-dropbox-uptodate.icns
[ -e "${file}" ] && mv -f "${file}" "${file}.bak"

e_info 'Expand the following File Info panes:'
e_info '“General”, “Open with”, and “Sharing & Permissions”'
defaults write com.apple.finder FXInfoPanesExpanded -dict \
	General -bool true \
	OpenWith -bool true \
	Privileges -bool true

###############################################################################
# Dock, Dashboard, and hot corners                                            #
###############################################################################
e_header "Dock, Dashboard, and hot corners"

e_info 'Enable highlight hover effect for the grid view of a stack (Dock)'
defaults write com.apple.dock mouse-over-hilite-stack -bool true

e_info 'Set the icon size of Dock items to 36 pixels'
defaults write com.apple.dock tilesize -int 36

e_info 'Change minimize/maximize window effect'
defaults write com.apple.dock mineffect -string "scale"

e_info 'Dont minimize windows into their application’s icon'
defaults write com.apple.dock minimize-to-application -bool false

e_info 'Enable spring loading for all Dock items'
defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true

e_info 'Show indicator lights for open applications in the Dock'
defaults write com.apple.dock show-process-indicators -bool true

# Wipe all (default) app icons from the Dock
# This is only really useful when setting up a new Mac, or if you don’t use
# the Dock to launch apps.
#defaults write com.apple.dock persistent-apps -array

# Show only open applications in the Dock
#defaults write com.apple.dock static-only -bool true

e_info 'Don’t animate opening applications from the Dock'
defaults write com.apple.dock launchanim -bool false

e_info 'Speed up Mission Control animations'
defaults write com.apple.dock expose-animation-duration -float 0.1

e_info 'Don’t group windows by application in Mission Control'
e_info '(i.e. use the old Exposé behavior instead)'
defaults write com.apple.dock expose-group-by-app -bool false

e_info 'Disable Dashboard'
defaults write com.apple.dashboard mcx-disabled -bool true

e_info 'Don’t show Dashboard as a Space'
defaults write com.apple.dock dashboard-in-overlay -bool true

e_info 'Don’t automatically rearrange Spaces based on most recent use'
defaults write com.apple.dock mru-spaces -bool false

e_info 'Remove the auto-hiding Dock delay'
defaults write com.apple.dock autohide-delay -float 0
e_info 'Remove the animation when hiding/showing the Dock'
defaults write com.apple.dock autohide-time-modifier -float 0

e_info 'Automatically hide and show the Dock'
defaults write com.apple.dock autohide -bool true

e_info 'Position Dock at left side of the scree. Possible values are `left, `bottom` and `right`'
defaults write com.apple.dock orientation -string left

e_info 'Make Dock icons of hidden applications translucent'
defaults write com.apple.dock showhidden -bool true

# Disable the Launchpad gesture (pinch with thumb and three fingers)
#defaults write com.apple.dock showLaunchpadGestureEnabled -int 0

e_info 'Reset Launchpad, but keep the desktop wallpaper intact'
find "${HOME}/Library/Application Support/Dock" -name "*-*.db" -maxdepth 1 -delete

e_info 'Add iOS & Watch Simulator to Launchpad'
sudo ln -sf "/Applications/Xcode.app/Contents/Developer/Applications/Simulator.app" "/Applications/Simulator.app"
sudo ln -sf "/Applications/Xcode.app/Contents/Developer/Applications/Simulator (Watch).app" "/Applications/Simulator (Watch).app"

# Add a spacer to the left side of the Dock (where the applications are)
#defaults write com.apple.dock persistent-apps -array-add '{tile-data={}; tile-type="spacer-tile";}'
# Add a spacer to the right side of the Dock (where the Trash is)
#defaults write com.apple.dock persistent-others -array-add '{tile-data={}; tile-type="spacer-tile";}'

# Hot corners
# Possible values:
#  0: no-op
#  2: Mission Control
#  3: Show application windows
#  4: Desktop
#  5: Start screen saver
#  6: Disable screen saver
#  7: Dashboard
# 10: Put display to sleep
# 11: Launchpad
# 12: Notification Center
# Modifier Values
#  131072: Shift ⇧
#  1048576: Command ⌘
#  262144: Control ⌃
# If you need to check any other modifiers, just set them via System Preferences for bottom-left corner and run `defaults read com.apple.dock wvous-bl-modifier` to see the specific code
# Top left screen corner → ⌘ Mission Control
defaults write com.apple.dock wvous-tl-corner -int 2
defaults write com.apple.dock wvous-tl-modifier -int 1046576
# Top right screen corner → Desktop
defaults write com.apple.dock wvous-tr-corner -int 4
defaults write com.apple.dock wvous-tr-modifier -int 1046576
# Bottom left screen corner → Start screen saver
defaults write com.apple.dock wvous-bl-corner -int 5
defaults write com.apple.dock wvous-bl-modifier -int 1046576

###############################################################################
# Safari & WebKit                                                             #
###############################################################################
e_header "Safari & WebKit"

e_info 'Privacy: don’t send search queries to Apple'
defaults write com.apple.Safari UniversalSearchEnabled -bool false
defaults write com.apple.Safari SuppressSearchSuggestions -bool true

e_info 'Press Tab to highlight each item on a web page'
defaults write com.apple.Safari WebKitTabToLinksPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2TabsToLinks -bool true

e_info 'Show the full URL in the address bar (note: this still hides the scheme)'
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true

e_info 'Set Safari’s home page to `about:blank` for faster loading'
defaults write com.apple.Safari HomePage -string "about:blank"

e_info 'Prevent Safari from opening ‘safe’ files automatically after downloading'
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

e_info 'Allow hitting the Backspace key to go to the previous page in history'
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2BackspaceKeyNavigationEnabled -bool true

e_info 'Hide Safari’s bookmarks bar by default'
defaults write com.apple.Safari ShowFavoritesBar -bool false

e_info 'Hide Safari’s sidebar in Top Sites'
defaults write com.apple.Safari ShowSidebarInTopSites -bool false

e_info 'Disable Safari’s thumbnail cache for History and Top Sites'
defaults write com.apple.Safari DebugSnapshotsUpdatePolicy -int 2

e_info 'Enable Safari’s debug menu'
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

e_info 'Make Safari’s search banners default to Contains instead of Starts With'
defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false

e_info 'Remove useless icons from Safari’s bookmarks bar'
defaults write com.apple.Safari ProxiesInBookmarksBar "()"

e_info 'Enable the Develop menu and the Web Inspector in Safari'
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

e_info 'Add a context menu item for showing the Web Inspector in web views'
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

e_info 'Enable continuous spellchecking'
defaults write com.apple.Safari WebContinuousSpellCheckingEnabled -bool true
e_info 'Disable auto-correct'
defaults write com.apple.Safari WebAutomaticSpellingCorrectionEnabled -bool false

# Disable AutoFill
# defaults write com.apple.Safari AutoFillFromAddressBook -bool false
# defaults write com.apple.Safari AutoFillPasswords -bool false
# defaults write com.apple.Safari AutoFillCreditCardData -bool false
# defaults write com.apple.Safari AutoFillMiscellaneousForms -bool false

e_info 'Warn about fraudulent websites'
defaults write com.apple.Safari WarnAboutFraudulentWebsites -bool true

# Disable plug-ins
# defaults write com.apple.Safari WebKitPluginsEnabled -bool false
# defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2PluginsEnabled -bool false

e_info 'Disable Java'
defaults write com.apple.Safari WebKitJavaEnabled -bool false
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabled -bool false

e_info 'Block pop-up windows'
defaults write com.apple.Safari WebKitJavaScriptCanOpenWindowsAutomatically -bool false
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaScriptCanOpenWindowsAutomatically -bool false

e_info 'Disable auto-playing video'
defaults write com.apple.Safari WebKitMediaPlaybackAllowsInline -bool false
defaults write com.apple.SafariTechnologyPreview WebKitMediaPlaybackAllowsInline -bool false
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2AllowsInlineMediaPlayback -bool false
defaults write com.apple.SafariTechnologyPreview com.apple.Safari.ContentPageGroupIdentifier.WebKit2AllowsInlineMediaPlayback -bool false

e_info 'Enable “Do Not Track”'
defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true

e_info 'Update extensions automatically'
defaults write com.apple.Safari InstallExtensionUpdatesAutomatically -bool true

###############################################################################
# Mail                                                                        #
###############################################################################

# Disable send and reply animations in Mail.app
# defaults write com.apple.mail DisableReplyAnimations -bool true
# defaults write com.apple.mail DisableSendAnimations -bool true

# Copy email addresses as `foo@example.com` instead of `Foo Bar <foo@example.com>` in Mail.app
# defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false

# Add the keyboard shortcut ⌘ + Enter to send an email in Mail.app
# defaults write com.apple.mail NSUserKeyEquivalents -dict-add "Send" "@\U21a9"

# Display emails in threaded mode, sorted by date (oldest at the top)
# defaults write com.apple.mail DraftsViewerAttributes -dict-add "DisplayInThreadedMode" -string "yes"
# defaults write com.apple.mail DraftsViewerAttributes -dict-add "SortedDescending" -string "yes"
# defaults write com.apple.mail DraftsViewerAttributes -dict-add "SortOrder" -string "received-date"

# Disable inline attachments (just show the icons)
# defaults write com.apple.mail DisableInlineAttachmentViewing -bool true

# Disable automatic spell checking
# defaults write com.apple.mail SpellCheckingBehavior -string "NoSpellCheckingEnabled"

###############################################################################
# Spotlight                                                                   #
###############################################################################
e_header "Spotlight"

# Hide Spotlight tray-icon (and subsequent helper)
#sudo chmod 600 /System/Library/CoreServices/Search.bundle/Contents/MacOS/Search
e_info 'Disable Spotlight indexing for any volume that gets mounted and has not yet'
e_info 'been indexed before.'
e_info 'Use `sudo mdutil -i off "/Volumes/foo"` to stop indexing any volume.'
sudo defaults write /.Spotlight-V100/VolumeConfiguration Exclusions -array "/Volumes"
# Change indexing order and disable some search results
# Yosemite-specific search results (remove them if you are using macOS 10.9 or older):
# 	MENU_DEFINITION
# 	MENU_CONVERSION
# 	MENU_EXPRESSION
# 	MENU_SPOTLIGHT_SUGGESTIONS (send search queries to Apple)
# 	MENU_WEBSEARCH             (send search queries to Apple)
# 	MENU_OTHER
# defaults write com.apple.spotlight orderedItems -array \
# 	'{"enabled" = 1;"name" = "APPLICATIONS";}' \
# 	'{"enabled" = 1;"name" = "SYSTEM_PREFS";}' \
# 	'{"enabled" = 1;"name" = "DIRECTORIES";}' \
# 	'{"enabled" = 1;"name" = "PDF";}' \
# 	'{"enabled" = 1;"name" = "FONTS";}' \
# 	'{"enabled" = 0;"name" = "DOCUMENTS";}' \
# 	'{"enabled" = 0;"name" = "MESSAGES";}' \
# 	'{"enabled" = 0;"name" = "CONTACT";}' \
# 	'{"enabled" = 0;"name" = "EVENT_TODO";}' \
# 	'{"enabled" = 0;"name" = "IMAGES";}' \
# 	'{"enabled" = 0;"name" = "BOOKMARKS";}' \
# 	'{"enabled" = 0;"name" = "MUSIC";}' \
# 	'{"enabled" = 0;"name" = "MOVIES";}' \
# 	'{"enabled" = 0;"name" = "PRESENTATIONS";}' \
# 	'{"enabled" = 0;"name" = "SPREADSHEETS";}' \
# 	'{"enabled" = 0;"name" = "SOURCE";}' \
# 	'{"enabled" = 0;"name" = "MENU_DEFINITION";}' \
# 	'{"enabled" = 0;"name" = "MENU_OTHER";}' \
# 	'{"enabled" = 0;"name" = "MENU_CONVERSION";}' \
# 	'{"enabled" = 0;"name" = "MENU_EXPRESSION";}' \
# 	'{"enabled" = 0;"name" = "MENU_WEBSEARCH";}' \
# 	'{"enabled" = 0;"name" = "MENU_SPOTLIGHT_SUGGESTIONS";}'
e_info 'Load new settings before rebuilding the index'
killall mds > /dev/null 2>&1
e_info 'Make sure indexing is enabled for the main volume'
sudo mdutil -i on / > /dev/null
e_info 'Rebuild the index from scratch'
sudo mdutil -E / > /dev/null

###############################################################################
# Terminal                                                                    #
###############################################################################
e_header "Terminal"

e_info 'Only use UTF-8 in Terminal.app'
defaults write com.apple.terminal StringEncodings -array 4

# Enable “focus follows mouse” for Terminal.app and all X11 apps
# i.e. hover over a window and start typing in it without clicking first
#defaults write com.apple.terminal FocusFollowsMouse -bool true
#defaults write org.x.X11 wm_ffm -bool true

e_info 'Enable Secure Keyboard Entry in Terminal.app'
# See: https://security.stackexchange.com/a/47786/8918
defaults write com.apple.terminal SecureKeyboardEntry -bool true

e_info 'Disable the annoying line marks'
defaults write com.apple.Terminal ShowLineMarks -int 0

###############################################################################
# Time Machine                                                                #
###############################################################################
e_header "Time Machine"

e_info 'Prevent Time Machine from prompting to use new hard drives as backup volume'
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

e_info 'Disable local Time Machine backups'
hash tmutil &> /dev/null && sudo tmutil disablelocal

###############################################################################
# Activity Monitor                                                            #
###############################################################################
e_header "Activity Monitor"

e_info 'Show the main window when launching Activity Monitor'
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

e_info 'Visualize CPU usage in the Activity Monitor Dock icon'
defaults write com.apple.ActivityMonitor IconType -int 5

e_info 'Show all processes in Activity Monitor'
defaults write com.apple.ActivityMonitor ShowCategory -int 0

e_info 'Sort Activity Monitor results by CPU usage'
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

###############################################################################
# Address Book, Dashboard, iCal, TextEdit, and Disk Utility                   #
###############################################################################
e_header "Address Book, Dashboard, iCal, TextEdit, and Disk Utility"

e_info 'Enable the debug menu in Address Book'
defaults write com.apple.addressbook ABShowDebugMenu -bool true

e_info 'Enable Dashboard dev mode (allows keeping widgets on the desktop)'
defaults write com.apple.dashboard devmode -bool true

e_info 'Enable the debug menu in iCal (pre-10.8)'
defaults write com.apple.iCal IncludeDebugMenu -bool true

e_info 'Use plain text mode for new TextEdit documents'
defaults write com.apple.TextEdit RichText -int 0
e_info 'Open and save files as UTF-8 in TextEdit'
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

e_info 'Enable the debug menu in Disk Utility'
defaults write com.apple.DiskUtility DUDebugMenuEnabled -bool true
defaults write com.apple.DiskUtility advanced-image-options -bool true

e_info 'Auto-play videos when opened with QuickTime Player'
defaults write com.apple.QuickTimePlayerX MGPlayMovieOnOpen -bool true

###############################################################################
# Mac App Store                                                               #
###############################################################################
e_header "Mac App Store"

e_info 'Enable the WebKit Developer Tools in the Mac App Store'
defaults write com.apple.appstore WebKitDeveloperExtras -bool true

e_info 'Enable Debug Menu in the Mac App Store'
defaults write com.apple.appstore ShowDebugMenu -bool true

e_info 'Enable the automatic update check'
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

e_info 'Check for software updates daily, not just once per week'
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

e_info 'Download newly available updates in background'
defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1

e_info 'Install System data files & security updates'
defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1

# Automatically download apps purchased on other Macs
# defaults write com.apple.SoftwareUpdate ConfigDataInstall -int 1

e_info 'Turn on app auto-update'
defaults write com.apple.commerce AutoUpdate -bool true

e_info 'Allow the App Store to reboot machine on macOS updates'
defaults write com.apple.commerce AutoUpdateRestartRequired -bool true

###############################################################################
# Photos                                                                      #
###############################################################################
e_header "Photos"

e_info 'Prevent Photos from opening automatically when devices are plugged in'
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

###############################################################################
# Messages                                                                    #
###############################################################################
e_header "Messages"

e_info 'Disable automatic emoji substitution (i.e. use plain text smileys)'
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticEmojiSubstitutionEnablediMessage" -bool false

e_info 'Disable smart quotes as it’s annoying for messages that contain code'
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticQuoteSubstitutionEnabled" -bool false

e_info 'Disable continuous spell checking'
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "continuousSpellCheckingEnabled" -bool false

###############################################################################
# Google Chrome & Google Chrome Canary                                        #
###############################################################################

# Disable the all too sensitive backswipe on trackpads
# defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false
# defaults write com.google.Chrome.canary AppleEnableSwipeNavigateWithScrolls -bool false

# Disable the all too sensitive backswipe on Magic Mouse
# defaults write com.google.Chrome AppleEnableMouseSwipeNavigateWithScrolls -bool false
# defaults write com.google.Chrome.canary AppleEnableMouseSwipeNavigateWithScrolls -bool false

# Use the system-native print preview dialog
# defaults write com.google.Chrome DisablePrintPreview -bool true
# defaults write com.google.Chrome.canary DisablePrintPreview -bool true

# Expand the print dialog by default
# defaults write com.google.Chrome PMPrintingExpandedStateForPrint2 -bool true
# defaults write com.google.Chrome.canary PMPrintingExpandedStateForPrint2 -bool true

###############################################################################
# Opera & Opera Developer                                                     #
###############################################################################

# Expand the print dialog by default
# defaults write com.operasoftware.Opera PMPrintingExpandedStateForPrint2 -boolean true
# defaults write com.operasoftware.OperaDeveloper PMPrintingExpandedStateForPrint2 -boolean true

###############################################################################
# Transmission.app                                                            #
###############################################################################

# Use `~/Documents/Torrents` to store incomplete downloads
# defaults write org.m0k.transmission UseIncompleteDownloadFolder -bool true
# defaults write org.m0k.transmission IncompleteDownloadFolder -string "${HOME}/Documents/Torrents"

# Use `~/Downloads` to store completed downloads
# defaults write org.m0k.transmission DownloadLocationConstant -bool true

# Don’t prompt for confirmation before downloading
# defaults write org.m0k.transmission DownloadAsk -bool false
# defaults write org.m0k.transmission MagnetOpenAsk -bool false

# Don’t prompt for confirmation before removing non-downloading active transfers
# defaults write org.m0k.transmission CheckRemoveDownloading -bool true

# Trash original torrent files
# defaults write org.m0k.transmission DeleteOriginalTorrent -bool true

# Hide the donate message
# defaults write org.m0k.transmission WarningDonate -bool false
# Hide the legal disclaimer
# defaults write org.m0k.transmission WarningLegal -bool false

# IP block list.
# Source: https://giuliomac.wordpress.com/2014/02/19/best-blocklist-for-transmission/
# defaults write org.m0k.transmission BlocklistNew -bool true
# defaults write org.m0k.transmission BlocklistURL -string "http://john.bitsurge.net/public/biglist.p2p.gz"
# defaults write org.m0k.transmission BlocklistAutoUpdate -bool true

# Randomize port on launch
# defaults write org.m0k.transmission RandomPort -bool true

###############################################################################
# Tweetbot.app                                                                #
###############################################################################
e_header "Tweetbot.app"

e_info 'Bypass the annoyingly slow t.co URL shortener'
defaults write com.tapbots.TweetbotMac OpenURLsDirectly -bool true

###############################################################################
# Magnet.app                                                                  #
###############################################################################
e_header "Magnet.app"

e_info 'Bypass asking for rating'
defaults write com.crowdcafe.windowmagnet skipRatingReminder "1"
e_info 'Set my preferred shortcuts'
defaults write com.crowdcafe.windowmagnet expandWindowCenterThirdComboKey -dict keyCode 44 modifierFlags 786432
defaults write com.crowdcafe.windowmagnet expandWindowLeftThirdComboKey -dict keyCode 43 modifierFlags 786432
defaults write com.crowdcafe.windowmagnet expandWindowLeftTwoThirdsComboKey -dict keyCode 41 modifierFlags 786432
defaults write com.crowdcafe.windowmagnet expandWindowNorthEastComboKey -dict keyCode 14 modifierFlags 786432
defaults write com.crowdcafe.windowmagnet expandWindowNorthWestComboKey -dict keyCode 13 modifierFlags 786432
defaults write com.crowdcafe.windowmagnet expandWindowRightThirdComboKey -dict keyCode 47 modifierFlags 786432
defaults write com.crowdcafe.windowmagnet expandWindowRightTwoThirdsComboKey -dict keyCode 39 modifierFlags 786432
defaults write com.crowdcafe.windowmagnet expandWindowSouthEastComboKey -dict keyCode 2 modifierFlags 786432
defaults write com.crowdcafe.windowmagnet expandWindowSouthWestComboKey -dict keyCode 1 modifierFlags 786432

###############################################################################
# Kill affected applications                                                  #
###############################################################################
e_info "Killing affected applications"

for app in "Activity Monitor" \
	"Address Book" \
	"Calendar" \
	"cfprefsd" \
	"Contacts" \
	"Dock" \
	"Finder" \
	"Google Chrome Canary" \
	"Google Chrome" \
	"Mail" \
	"Magnet" \
	"Messages" \
	"Opera" \
	"Photos" \
	"Safari" \
	"SystemUIServer" \
	"Transmission" \
	"Tweetbot" \
	"iCal"; do
	killall "${app}" &> /dev/null
done

# Only kill the Terminal.app if it's not the current app being used to run this script
if [[ $TERM_PROGRAM != "Apple_Terminal" ]]; then
    killall "Terminal" &> /dev/null
else
    e_info "You may need to manually restart your terminal after this is finished"
fi

e_success "${RESET}Done. Note that some of these changes require a logout/restart to take effect."
