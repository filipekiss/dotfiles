unalias project 2>/dev/null


function project() {
    local action="$1"
    shift
    case $action in
        create)
            __create_project $@
            ;;
        clone)
            __clone_project $@
            ;;
        *)
            echo "Command Invalid."
            ;;
    esac
}


function __create_project() {
    local projectNamespace="$1"
    local projectName="${2}"
    [[ -z $projectName ]] && echo "You need a project name!\nTry project create ${projectNamespace} my-cool-project" && return 1
    local projectLocation="${PROJECTS:-${HOME}}/${projectNamespace}/${projectName}"
    if [[ -d ${projectLocation} ]]; then
        e_info "Project ${projectNamespace}/${projectName} already exists. Wish to go there? [Y/n]"
        read -sk 1 "goToProject"
        if [[ ${goToProject:-y} != ^[Yy]$ ]]; then
            return 0
        fi
    else
        e_info "Creating $projectLocation"
        mkdir -p "${projectLocation}"
    fi
    cd ${projectLocation}
}

function __clone_project() {
    local projectNamespace="$1"
    local projectName="${2}"
    [[ -z $projectName ]] && echo "You need a project name!\nTry project clone ${projectNamespace} my-cool-project" && return 1
    local projectLocation="${PROJECTS:-${HOME}}/${projectNamespace}/${projectName}"
    if [[ -d ${projectLocation} ]]; then
        e_info "Project ${projectNamespace}/${projectName} already exists. Wish to go there? [Y/n]"
        read -sk 1 "goToProject"
        if [[ ${goToProject:-y} != ^[Yy]$ ]]; then
            return 0
        fi
    else
        e_info "Cloning $projectLocation"
        command git clone "https://github.com/${projectNamespace}/${projectName}" "${PROJECTS:-${HOME}}/${projectNamespace}/${projectName}" && e_info "Project cloned into ${PROJECTS}/${projectNamespace}/${projectName}"
        [[ $status -gt 0 ]] && e_error "And error ocurred when cloning ${projectNamespace}/${projectName}" && return 127
    fi
    cd ${projectLocation}
}

# Load the autocompletion for the function
(( ! $+functions[_project] )) && autoload -U _project
compdef _project project
