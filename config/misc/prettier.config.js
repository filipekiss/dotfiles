module.exports = {
    useTabs: false, // Use spaces and not tabs
    tabWidth: 4, // Ident using 4 spaces
    semi: true, // Append semicolons to end of statement,
    singleQuote: true, // Use single quote for strings,
    trailingComma: 'es5', // Add trailing comma when valid. See https://prettier.io/docs/en/options.html#trailing-commas
    bracketSpacing: true, // Change {foo: bar} to { foo: bar }
    jsxBracketSameLine: true, // See https://prettier.io/docs/en/options.html#jsx-brackets
    arrowParens: 'avoid', // Don't wrap arros functions in parens if not needed (example => { example.toUpperCase() } instead of (example) => { return example.toUpperCase() }
};
