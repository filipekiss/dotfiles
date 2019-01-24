# Use rm to remove a link and it's target
unalias rml 2>/dev/null

function rml() {
    if [[ $# -eq 0 ]]; then
        echo "USAGE: rml <targets to remove>" && exit 1
    else
        local rmOptions
        rmOptions=()
        local filesToDelete
        filesToDelete=()
        for filePath in $@; do
            [[ $filePath == "-"* ]] && rmOptions+=($filePath) && continue
            filesToDelete+=($filePath)
            [[ -L $filePath ]] && filesToDelete+=($(readlink $filePath))
        done;
        rm ${rmOptions} ${filesToDelete}
    fi
}

# Ensure rml is completed like rm
compdef rml=rm