" vim: ft=vim :tw=80 :sw=4

scriptencoding utf-8

if extensions#isInstalling()
    call extensions#loadExtension('https://github.com/editorconfig/editorconfig-vim')
    finish
endif

if extensions#isMissing('editorconfig-vim', 'editorconfig.vim')
    finish
endif

let g:EditorConfig_core_mode = 'external_command'
let g:EditorConfig_exclude_patterns = ['fugitive://.*']
