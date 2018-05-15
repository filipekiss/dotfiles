all: brew keybase stow private permissions python ruby node italics macos

permissions:
	-@zsh ./scripts/file-permissions.zsh

brew:
	-@zsh ./scripts/brew.zsh

python:
	-@zsh ./scripts/python-packages.zsh

node:
	-@zsh ./scripts/node-packages.zsh

ruby:
	-@bundle install --system --gemfile=./config/ruby/Gemfile

macos:
	-@zsh ./scripts/macos-options.zsh

private:
	-@zsh ./scripts/transcrypt-config.zsh

stow:
	-@zsh ./scripts/stow.zsh

keybase:
	-@zsh ./scripts/keybase.zsh

italics:
	-@tic -o ~/.terminfo ./terminfo/xterm-256color.terminfo
	-@tic -o ~/.terminfo ./terminfo/tmux-256color.terminfo
	-@echo `tput sitm`italics`tput ritm` `tput smso`standout`tput rmso`

PHONY: all brew permissions python macos requirements stow keybase italics node
