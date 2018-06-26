function todo () {
    typeset -a _rg_options
    typeset -a _rg_args

    local grep_prg filename
    filename=${${(%):-%x}:t}

    # Don't let `parse_arguments` function leak to the interactive session
    (
    function parse_arguments() {
        local arg
        while (( $# > 0 ))
        do
            arg="$1"
            case "$arg" in
                --*=*)
                    _rg_options+=("${arg}")
                    ;;
                -*|--*)
                    _rg_options+=("$arg")
                    [[ -n $2 ]] && \
                        _rg_options+=("${(qq)2}") && \
                        shift
                    ;;
                *)
                    _rg_args+=("$arg")
                    ;;
            esac
            shift
        done
        [[ -z $_rg_args ]] && _rg_args=("./")
    }

    parse_arguments ${(z)@}
    )
    _rg_options+=("--glob=!${filename}")
    if (( $+commands[rg] )); then
        $commands[rg] \
            ${_rg_options} \
            "TODO|NOTE|HACK|IDEA|FIXME|OPTMIZE" \
            ${_rg_args}
    else
        echo "Install ripgrep"
    fi
}
