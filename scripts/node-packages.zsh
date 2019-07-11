e_error() {
    echo "✖ $@"
}

PACKAGES=(
    "alex"
    "eslint"
    "eslint-config-airbnb"
    "eslint-config-prettier"
    "eslint-plugin-import"
    "eslint-plugin-react"
    "eslint-plugin-prettier"
    "flow-language-server"
    "typescript"
    "vscode-html-languageserver-bin"
    "css-langserver"
    "vscode-json-languageserver"
    "javascript-typescript-langserver"
    "jscpd"
    "prettier"
    "tern"
)

for package in "${PACKAGES[@]}"; do
    if (( $+commands[npm] )); then
        npm install --global "$package"
    else
        e_error "Install npm before continuing" && exit 1
    fi
done

unset -v PACKAGES
