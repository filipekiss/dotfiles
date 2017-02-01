all: homebrew

homebrew: homebrew/Brewfile
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


.PHONY: homebrew install symlink
