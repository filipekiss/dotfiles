
unalias project 2>/dev/null


function project() {
    local action="$1"
    shift
    case $action in
        create)
            __create_project $@
            ;;
        *)
            echo "Command Invalid. Try project create <namespace/project>"
            ;;
    esac
}


function __create_project() {
    local projectName="$1"
    local projectLocation="${PROJECTS:-${HOME}}/${projectName}"
    if [[ -d ${projectLocation} ]]; then
        e_info "Project already exists. Wish to go there? [Y/n]"
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
