all: brew permissions python iterm githooks

permissions:
	-@zsh ./scripts/file-permissions.zsh

brew:
	-@brew bundle --file="$(HOME)/.dotfiles/homebrew/Brewfile"
	-@brew cleanup
	-@brew doctor
	-@/usr/local/opt/fzf/install --all

python:
	-@zsh ./scripts/python-packages.zsh

macos:
	-@zsh ./scripts/macos-options.zsh

githooks:
	-@zsh ./scripts/link-git-hooks.zsh

iterm:
	-@zsh ./scripts/iterm.zsh


PHONY: all brew permissions iterm python macos githooks
