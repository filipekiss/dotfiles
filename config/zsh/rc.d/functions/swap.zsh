swap() {
    local _can_swap_paths
    [[ $# -eq 2 ]] && _can_swap_paths=1
    [[ -z _can_swap_paths ]] && echo "USAGE: swap <path1> <path2>" && echo "Swap <path1> with <path2>" && return 1
    local _path_left="$1"
    local _path_right="$2"
    if [[ ! -e ${_path_left} ]]; then
        # Left path does not exists. See if right exists
        [[ -e ${_path_right} ]] && command mv ${_path_right} ${_path_left} && return 0
        # Right path did not exists either. Warn and abort
        echo "Neither ${_path_left} nor ${_path_right} was found… Aborting." && return 1
    fi
    # Path left exists. If right does not exists, just mv <left> <right> and exit
    [[ ! -e ${_path_right} ]] && command mv ${_path_left} ${_path_right} && return 0
    # Both paths exists. Move left to temp, move right to left, move left to right.
    local _tmp_path="/tmp/${_path_left:h}"
    command mkdir -p ${_tmp_path}
    command mv ${_path_left} /tmp/${_path_left}
    command mv ${_path_right} ${_path_left}
    command mv /tmp/${_path_left} ${_path_right}
    [[ -z $(ls $_tmp_path) ]] && command rm -rf ${_tmp_path} || return 0
}
