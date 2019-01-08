all: brew python node italics macos

permissions:
	-@zsh ./scripts/file-permissions.zsh

brew:
	-@zsh ./scripts/brew.zsh

python:
	-@zsh ./scripts/python-packages.zsh

node:
	-@zsh ./scripts/node-packages.zsh

macos:
	-@zsh ./scripts/macos-options.zsh

keybase:
	-@zsh ./scripts/keybase.zsh

italics:
	-@tic -o ~/.terminfo ./terminfo/xterm-256color.terminfo
	-@tic -o ~/.terminfo ./terminfo/tmux-256color.terminfo
	-@echo `tput sitm`italics`tput ritm` `tput smso`standout`tput rmso`

PHONY: all permissions brew python node macos keybase italics
