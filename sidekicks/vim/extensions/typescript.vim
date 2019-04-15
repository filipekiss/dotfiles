" vim: ft=vim :tw=80 :sw=4

scriptencoding utf-8

if extensions#isInstalling()
    call extensions#loadExtension('https://github.com/HerringtonDarkholme/yats.vim')
    call extensions#loadExtension('https://github.com/mhartington/nvim-typescript', {'do': ':!install.sh \| UpdateRemotePlugins'})
    finish
endif


