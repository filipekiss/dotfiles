all: brew permissions python iterm githooks

permissions:
	-@zsh ./scripts/file-permissions.zsh

brew:
	-@zsh ./scripts/brew-select.zsh

python:
	-@zsh ./scripts/python-packages.zsh

macos:
	-@zsh ./scripts/macos-options.zsh

githooks:
	-@zsh ./scripts/link-git-hooks.zsh

iterm:
	-@zsh ./scripts/iterm.zsh


PHONY: all brew permissions iterm python macos githooks
