if executable('jq')
    setlocal formatprg=jq\ .
else
    setlocal formatprg=python\ -m\ json.tool
endif

au! BufRead,BufNewFile .{babel,eslint,stylelint,jshint}*rc,\.tern-*,*.json setl filetype=json
