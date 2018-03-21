function tmux-set-size() {
    local size="$1"
    local direction="-${2:-R}"
    local currentWidth=$(tput cols)
    local currentHeight=$(tput lines)
    if [[ "-R" == $direction || "-L" == $direction ]]; then
        if [[ $currentWidth -gt $size ]]; then
            let "finalSize=$currentWidth - $size"
        else
            let "finalSize=$size - $currentWidth"
            [[ $direction == '-R' ]] && direction="-L" || direction="-R"
        fi
    else
        if [[ $currentHeight -gt $size ]]; then
            let "finalSize=$currentHeight - $size"
        else
            let "finalSize=$size - $currentHeight"
            [[ $direction == '-U' ]] && direction="-D" || direction="-R"
        fi
    fi
    if [[ $finalSize -eq 0 ]]; then
        echo "→ The pane is already at ${size}"
        return
    fi
    tmux resize-pane ${direction} ${finalSize}
}