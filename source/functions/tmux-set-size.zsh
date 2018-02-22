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
        fi
    else
        if [[ $currentHeight -gt $size ]]; then
            let "finalSize=$currentHeight - $size"
        else
            let "finalSize=$size - $currentHeight"
        fi
    fi
    if [[ $finalSize -eq 0 ]]; then
        echo "Hey! The pane is already at ${size}"
        return
    fi
    tmux resize-pane ${direction} ${finalSize}
}
