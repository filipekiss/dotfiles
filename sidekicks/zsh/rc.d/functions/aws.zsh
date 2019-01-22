function awsu() {
    if [[ $1 == "login" ]]; then
        eval $(aws ecr get-login --no-include-email --region us-east-1)
    fi
}

awsu "$@"
