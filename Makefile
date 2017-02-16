all: homebrew

homebrew_setup:
	@./homebrew/setup.sh

homebrew:
	@brew update
	@brew bundle --file=~/.dotfiles/homebrew/Brewfile
	@brew cleanup
	@brew doctor

install:
	@./scripts/install

symlink:
	@echo "Stowing files to $(HOME)"
	@stow --ignore ".DS_Store" --target="$(HOME)" --dir="$(HOME)/.dotfiles" \
		git \
		dig \
		atom \
		zsh

apt_setup:
	@./apt/ppa.sh


.PHONY: homebrew install symlink apt
