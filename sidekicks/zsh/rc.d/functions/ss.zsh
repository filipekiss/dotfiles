# macOS Only
is_macos || return 0

unalias ss 2>/dev/null

function ss(){
    CURRENT_LOCATION=$(defaults read com.apple.screencapture location)
    if [[ $# -eq 0 ]]; then
        SCREENSHOT_PATH="${HOME}/Desktop"
    else
        SCREENSHOT_PATH="$1"
    fi
    if [[ $CURRENT_LOCATION == $SCREENSHOT_PATH ]]; then
        e_success "${RESET}Screenshots are already being saved to ${GREEN}${CURRENT_LOCATION/#$HOME/~}"
        return
    fi
    e_info "Screenshots are currently saved to ${PURPLE}${CURRENT_LOCATION/#$HOME/~}"
    if [[ ${SCREENSHOT_PATH} == "--view" ]]; then
        return 0
    fi
    defaults write com.apple.screencapture location -string "${SCREENSHOT_PATH}"
    e_info "Screenshots will be saved on ${BLUE}${SCREENSHOT_PATH/#$HOME/~}${RESET} from now on"
}
