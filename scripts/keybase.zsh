(( ! $+commands[keybase] )) && echo "Keybase not found! Install keybase or fix your path" && exit 1

e_info() {
    echo "→ $@"
}

e_header() {
    echo
    echo "== $@ =="
    echo
}

e_success() {
    echo
    echo "✔ $@"
}

function login_keybase() {
    e_info "Checking Keybase login"
    $commands[keybase] login && e_success "Keybase successfully athenticated" || (e_error "${RESET}Something went wrong. You're not logged in" && exit 1)
}

function init_submodules() {
    e_info "Updating submodule"
    GIT_ALLOW_PROTOCOL=keybase $commands[git] submodule update --init --recursive --remote
    e_info "Done"
}

login_keybase
init_submodules
