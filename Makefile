all: italics brew permissions python ruby node iterm private

permissions:
	-@zsh ./scripts/file-permissions.zsh

requirements:
	-@zsh ./scripts/brew.zsh "required"

brew:
	-@zsh ./scripts/brew.zsh

python:
	-@zsh ./scripts/python-packages.zsh

node:
	-@zsh ./scripts/node-packages.zsh

ruby:
	-@gem install bundler
	-@bundle install --system --gemfile=./config/ruby/Gemfile

macos:
	-@zsh ./scripts/macos-options.zsh

private:
	-@zsh ./scripts/transcrypt-config.zsh

iterm:
	-@zsh ./scripts/iterm.zsh

stow:
	-@zsh ./scripts/stow.zsh

keybase:
	-@zsh ./scripts/keybase.zsh

italics:
	-@tic -o ~/.terminfo ./terminfo/xterm-256color.terminfo
	-@tic -o ~/.terminfo ./terminfo/tmux-256color.terminfo
	-@echo `tput sitm`italics`tput ritm` `tput smso`standout`tput rmso`

PHONY: all brew permissions iterm python macos requirements stow keybase italics node
