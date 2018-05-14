# Use rmg to remove a path copied from git's diff header (I'm lazy, I know)
unalias rmg 2>/dev/null

function rmg() {
    if [[ $# -eq 0 ]]; then
        echo "USAGE: rmg <targets to remove>" && exit 1
    else
        local rmOptions
        rmOptions=()
        local filesToDelete
        filesToDelete=()
        for filePath in $@; do
            [[ $filePath == "-"* ]] && rmOptions+=($filePath) && continue
            filesToDelete+=(${filePath#(a|b)//#})
        done;
        rm ${rmOptions} ${filesToDelete}
    fi
}

# Ensure rmg is completed like rm
compdef rmg=rm
