# Editor Wrapper to support neovim-remote

# If not inside TMUX, just alias e to EDITOR, no need to all this roundabouts
[[ -z $TMUX ]] && alias e=$EDITOR && return 0

# Check if neovim is our editor of choice
[[ $EDITOR == *"nvim" ]] && __is_editor_nvim="yes"

# If we don't have nvim installed just alias e to $EDITOR and be done with it
[[ -z $__is_editor_nvim ]] && alias e=$EDITOR && return 0

# Check for NVR
(( $+commands[nvr] )) && __is_nvr_installed="yes"

# If we don't have NVR installed, just alias e to $EDITOR and be done with it
[[ -z $__is_nvr_installed ]] && alias e=$EDITOR && return 0

unalias e 2>/dev/null

function e() {
    __socket_name=$(__e_get_current_socket_name)
    __e_prepare_socket $__socket_name
    # Use nvr to start or send the current received arguments to the current window nvim instance
    # Options:
    # -s: supress the message shown if nvr needs to create the instance
    # --servername: The current window socket
    # --remote-silent is the same as --remote (use a existing instance), but throws no error if no
    # process is found
    nvr --servername=${__socket_name} --remote-silent -s $@
}

function __e_prepare_socket() {
    local __socket_name="$1"
    if ! __e_check_socket $__socket_name; then
        # The socket $__socket_name is currently invalid. Remove it and let nvr create a new one
        rm -rf $__socket_name
    fi
}

function __e_get_current_socket_name() {
    local __current_tmux_session=$(tmux display-message -p '#S')
    local __current_session_window=$(tmux display-message -p '#I')
    # Replace slashes on session name to prevent socket creation errors
    __current_tmux_session=${__current_tmux_session//\//-}
    echo "/tmp/nvimsocket-${__current_tmux_session}-${__current_session_window}"
}

function __e_check_socket {
    local __socket_to_validate="$1"
    local __socket_is_valid
    __socket_netstat=$(netstat -ln | grep "${__socket_to_validate}")
    [[ -n $__socket_netstat ]] && return 0
    return 1
}

# Let's export the $EDITOR and NVIM_LISTEN_ADDRESS to use nvr and the current session socket. Mainly so git also benefits
# from nvr
export NVIM_LISTEN_ADDRESS=$(__e_get_current_socket_name)
export EDITOR="nvr"
export VISUAL=$EDITOR
export GIT_EDITOR="$EDITOR --remote-wait-silent -s"