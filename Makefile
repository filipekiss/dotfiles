all: brew permissions python iterm githooks

permissions:
	-@zsh ./scripts/file-permissions.zsh

requirements:
	-@zsh ./scripts/brew.zsh "required"

brew:
	-@zsh ./scripts/brew.zsh

python:
	-@zsh ./scripts/python-packages.zsh

macos:
	-@zsh ./scripts/macos-options.zsh

githooks:
	-@zsh ./scripts/link-git-hooks.zsh

iterm:
	-@zsh ./scripts/iterm.zsh


PHONY: all brew permissions iterm python macos githooks requirements
