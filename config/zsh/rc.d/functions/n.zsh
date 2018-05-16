#!/usr/bin/env zsh

_n_version="v0.1.0"

function n::node_build_details() {
    if (( $+commands[node-build] )); then
        _node_build_version=$(node-build --version | cut -d ' ' -f2-)
    else
        _node_build_version="node-build not found!"
    fi
}

function n::usage() {
    n::node_build_details
    echo "USAGE:"
    echo "n <node version>"
    echo "This will install the requested version if not yet installed"
    echo ""
    echo "versions"
    echo "--------"
    echo "n: ${_n_version}"
    echo "node-build: v${_node_build_version}"
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


function n::parse_multi_options() {
    echo "Multi-options are not supported! Please, separate them"
}

function n::parse_args() {
    if [[ -z "$1" ]]; then
        1=""
    fi
    while (( $# > 0 ))
    do
        local arg="$1"
        case $arg in
            -h|--help|"")
                n::usage
                _n_options[exit_n]="yes"
                ;;
            --versions|--list|--find)
                _n_options[find_version]="yes"
                _n_options[exit_n]="yes"
                ;;
            --no-install)
                _n_options[install_node]="no"
                ;;
            -c|--compile)
                _n_options[compile_arg]="--compile"
                ;;
            --direnv-allow)
                _n_options[add_to_direnv]="yes"
                _n_options[direnv_allow]="yes"
                ;;
            --direnv)
                _n_options[add_to_direnv]="yes"
                ;;
            -*)
                n::parse_multi_options "$arg"
                _n_options[exit_n]="yes"
                ;;
            *)
                n::parse_version $arg
                ;;
        esac
        shift
    done;
}

function n::find_version() {
    local requested_node_version="$1"
    command node-build --definitions | grep "${requested_node_version:-}"
}

function n::parse_version() {
    _n_options[requested_node_version]="${1##v}" # If vX.Y.Z is passed, convert to X.Y.Z
    [[ -x /usr/local/bin/node ]] && _n_options[has_global_node]="yes"
    _n_options[global_node_version]=$(/usr/local/bin/node --version | cut -d 'v' -f2-)
    [[ ${_n_options[requested_node_version]} == ${_n_options[global_node_version]} ]] && _n_options[use_global_node]="yes" && echo "Using /usr/local/bin/node version v${_n_options[global_node_version]}" && return 0
    [[ -d ${_n_options[node_versions_location]}/${_n_options[requested_node_version]} ]] && _n_options[has_requested_version]="yes" && echo "Using ${_n_options[node_versions_location]}/${_n_options[requested_node_version]}/bin/node version v${_n_options[requested_node_version]}"
}

function n::install_missing_version() {
    [[ ${_n_options[has_requested_version]:-"no"} == "yes" ]] && return 0
    [[ ${_n_options[use_global_node]:-"no"} == "yes" ]] && return 0
    local version_to_install="$1"
    [[ ${_n_options[install_node]:-"yes"} == "no" ]] && echo "Node v${version_to_install} not installed but --no-install was passed" && return 1
    if (( $+commands[node-build] )); then
        command node-build ${_n_options[compile_arg]} ${version_to_install} ${_n_options[node_versions_location]}/${version_to_install}
    else
        echo "node-build is required. Install node-build and try again"
        return 1
    fi
}

function n::find_up() {
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

function n::update_path() {
    local path_to_add
    path_to_add="${_n_options[node_versions_location]}/${_n_options[requested_node_version]}/bin"
    if [[ ${_n_options[use_global_node]:-"no"} == "yes" ]]; then
        export PATH=$(n::path_remove "${_n_options[node_versions_location]}")
        return
    fi
    [[ $PATH =~ $path_to_add ]] && return
    path=(
        "${_n_options[node_versions_location]}/${_n_options[requested_node_version]}/bin"
        "$path[@]"
    )
}

function n::path_remove() {
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

function n::update_dir_env() {
    local old_value new_value
    envrc_location=$(n::find_up ".envrc")
    [[ -z $envrc_location ]] && echo "n: --direnv was passed but .envrc was not found"
    old_value=$(n::file::get_line "use_node" $envrc_location)
    function n::file::delete_line "use_node" $envrc_location
    if [[ ${_n_options[use_global_node]:-"no"} == "no" ]]; then
        new_value="use_node ${_n_options[requested_node_version]}"
        n::file::add_line $new_value $envrc_location
    fi
    if [[ -n $new_value ]]; then
        echo "Updated ${envrc_location}"
        echo "Changes:"
        [[ -n $old_value ]] && echo "-${old_value}"
        [[ -n $new_value ]] && echo "+${new_value}"
    fi
    [[ ${_n_options[direnv_allow]:-"no"} == "yes" ]] && direnv allow $envrc_location && direnv reload
}

function n::file::get_line() {
    local needle haystack
    function needle="$1"
    haystack="$2"
    match=$(grep -h ${needle} ${haystack})
    if [[ -n $match ]]; then
        echo $match
    fi
}

function n::file::delete_line() {
    local needle haystack
    function needle="$1"
    haystack="$2"
    sed=$(command -v sed)
    command $sed -i "/${needle}/d" $haystack
}

function n::file::add_line() {
    local needle haystack
    function needle="$1"
    haystack="$2"
    echo "$needle" | tee -a $haystack > /dev/null
}

function n() {
    local node_versions_location=${NODE_VERSIONS:-"${HOME}/.node-versions"}
    typeset -g -A -U _n_options
    _n_options[node_versions_location]=${node_versions_location}
    n::parse_args "$@"
    [[ ${_n_options[find_version]:-"no"} == "yes" ]] && n::find_version ${_n_options[requested_node_version]}
    [[ ${_n_options[exit_n]:-"no"} == "yes" ]] && return
    n::install_missing_version ${_n_options[requested_node_version]} || return 1
    [[ ${_n_options[add_to_direnv]:-"no"} == "yes" ]] && n::update_dir_env ${_n_options[requested_node_version]}
    n::update_path
    unset _n_options
}
