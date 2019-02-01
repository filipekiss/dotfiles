" vim: ft=vim :tw=80 :sw=4

scriptencoding utf-8

if extensions#isInstalling()
	call extensions#loadExtension('https://github.com/tpope/vim-commentary')
	finish
endif
