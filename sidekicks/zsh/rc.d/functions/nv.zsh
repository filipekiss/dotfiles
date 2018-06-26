#!/usr/bin/env zsh

_nv_version="v0.1.0"

function nv::node_details() {
    if (( $+commands[node-build] )); then
        _node_build_version=$(node-build --version | cut -d ' ' -f2-)
    else
        _node_build_version="node-build not found!"
    fi

    if (( $+commands[node] )); then
        _node_version=$(node --version)
    else
        _node_version="node not found!"
    fi
}

function nv::usage() {
    nv::node_details
    echo "USAGE:"
    echo "nv <node version>"
    echo "This will install the requested version if not yet installed"
    echo ""
    echo "versions"
    echo "--------"
    echo "nv: ${_nv_version}"
    echo "node-build: v${_node_build_version}"
    echo "current node version: ${_node_version}"
    echo ""
    echo "options"
    echo "-------"
    echo "-h, --help        Show this help message"
    echo "-c, --compile     Compile Node version isntead of installing the binary."
    echo "                  This is passed to node-build as --compile"
    echo "--versions,--list List all available versions. This is the same as"
    echo "--find            node-build --definitions. If you pass a version, for example"
    echo "                  n --find 9.8, only the matching versions will be shown"
    echo "--no-install      If the version is not installed, don't install and exit"
    echo "--direnv          Add a use_node <version> line to the closest .envrc file"
    echo "--direnv-allow    Automatically allows direnv to be loaded. If you pass this"
    echo "                  options, there's no need to pass --direnv"
}


function nv::parse_multi_options() {
    echo "Multi-options are not supported! Please, separate them"
}

function nv::parse_args() {
    if [[ -z "$1" ]]; then
        1=""
    fi
    while (( $# > 0 ))
    do
        local arg="$1"
        case $arg in
            -h|--help|"")
                nv::usage
                _nv_options[exit_n]="yes"
                ;;
            --versions|--list|--find)
                _nv_options[find_version]="yes"
                _nv_options[exit_n]="yes"
                ;;
            --no-install)
                _nv_options[install_node]="no"
                ;;
            -c|--compile)
                _nv_options[compile_arg]="--compile"
                ;;
            --direnv-allow)
                _nv_options[add_to_direnv]="yes"
                _nv_options[direnv_allow]="yes"
                ;;
            --direnv)
                _nv_options[add_to_direnv]="yes"
                ;;
            -*)
                nv::parse_multi_options "$arg"
                _nv_options[exit_n]="yes"
                ;;
            *)
                nv::parse_version $arg
                ;;
        esac
        shift
    done;
}

function nv::find_version() {
    local requested_node_version="$1"
    command node-build --definitions | grep "${requested_node_version:-}"
}

function nv::parse_version() {
    _nv_options[requested_node_version]="${1##v}" # If vX.Y.Z is passed, convert to X.Y.Z
    [[ -x /usr/local/bin/node ]] && _nv_options[has_global_node]="yes"
    _nv_options[global_node_version]=$(/usr/local/bin/node --version | cut -d 'v' -f2-)
    [[ ${_nv_options[requested_node_version]} == ${_nv_options[global_node_version]} ]] && _nv_options[use_global_node]="yes" && echo "Using /usr/local/bin/node version v${_nv_options[global_node_version]}" && return 0
    [[ -d ${_nv_options[node_versions_location]}/${_nv_options[requested_node_version]} ]] && _nv_options[has_requested_version]="yes" && echo "Using ${_nv_options[node_versions_location]}/${_nv_options[requested_node_version]}/bin/node version v${_nv_options[requested_node_version]}"
}

function nv::install_missing_version() {
    [[ ${_nv_options[has_requested_version]:-"no"} == "yes" ]] && return 0
    [[ ${_nv_options[use_global_node]:-"no"} == "yes" ]] && return 0
    local version_to_install="$1"
    [[ ${_nv_options[install_node]:-"yes"} == "no" ]] && echo "Node v${version_to_install} not installed but --no-install was passed" && return 1
    if (( $+commands[node-build] )); then
        command node-build ${_nv_options[compile_arg]} ${version_to_install} ${_nv_options[node_versions_location]}/${version_to_install}
    else
        echo "node-build is required. Install node-build and try again"
        return 1
    fi
}

function nv::find_up() {
    (
    while true; do
        if [[ -f $1 ]]; then
            echo "$PWD/$1"
            return 0
        fi
        if [[ $PWD = / ]] || [[ $PWD = // ]]; then
            return 1
        fi
        cd ..
    done
    )
}

function nv::update_path() {
    local path_to_add
    path_to_add="${_nv_options[node_versions_location]}/${_nv_options[requested_node_version]}/bin"
    if [[ ${_nv_options[use_global_node]:-"no"} == "yes" ]]; then
        export PATH=$(nv::path_remove "${_nv_options[node_versions_location]}")
        return
    fi
    # @TODO: Change node binary link instead of changing path
    # @BODY: Changing the path is a mess, so make a node link to $DOTFILES/.bin
    # or something
    [[ $PATH =~ $path_to_add ]] && return
    export PATH="${path_to_add}:${(j|:|)path}"
}

function nv::path_remove() {
    local arg local_path
    local_path=("${(@s/:/)PATH}")
    typeset -a -U final_path
    # remove all paths that match the passed arg
    for path_part in $local_path; do
        for arg in "$@"; do
            if [[ ! $path_part =~ $arg ]]; then
                final_path+=($path_part)
            fi
        done
    done
    echo ${(j|:|)final_path}
}

function nv::update_dir_env() {
    local old_value new_value
    envrc_location=$(nv::find_up ".envrc")
    [[ -z $envrc_location ]] && echo "n: --direnv was passed but .envrc was not found"
    old_value=$(nv::file::get_line "use_node" $envrc_location)
    function nv::file::delete_line "use_node" $envrc_location
    if [[ ${_nv_options[use_global_node]:-"no"} == "no" ]]; then
        new_value="use_node ${_nv_options[requested_node_version]}"
        nv::file::add_line $new_value $envrc_location
    fi
    if [[ -n $new_value ]]; then
        echo "Updated ${envrc_location}"
        echo "Changes:"
        [[ -n $old_value ]] && echo "-${old_value}"
        [[ -n $new_value ]] && echo "+${new_value}"
    fi
    [[ ${_nv_options[direnv_allow]:-"no"} == "yes" ]] && direnv allow $envrc_location && direnv reload
}

function nv::file::get_line() {
    local needle haystack
    function needle="$1"
    haystack="$2"
    match=$(grep -h ${needle} ${haystack})
    if [[ -n $match ]]; then
        echo $match
    fi
}

function nv::file::delete_line() {
    local needle haystack
    function needle="$1"
    haystack="$2"
    sed=$(command -v sed)
    command $sed -i "/${needle}/d" $haystack
}

function nv::file::add_line() {
    local needle haystack
    function needle="$1"
    haystack="$2"
    echo "$needle" | tee -a $haystack > /dev/null
}

function nv() {
    local node_versions_location=${NODE_VERSIONS:-"${HOME}/.node-versions"}
    typeset -g -A -U _nv_options
    _nv_options[node_versions_location]=${node_versions_location}
    nv::parse_args "$@"
    [[ ${_nv_options[find_version]:-"no"} == "yes" ]] && nv::find_version ${_nv_options[requested_node_version]}
    [[ ${_nv_options[exit_n]:-"no"} == "yes" ]] && return
    nv::install_missing_version ${_nv_options[requested_node_version]} || return 1
    [[ ${_nv_options[add_to_direnv]:-"no"} == "yes" ]] && nv::update_dir_env ${_nv_options[requested_node_version]}
    nv::update_path
    unset _nv_options
}
