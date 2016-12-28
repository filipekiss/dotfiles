all: homebrew

homebrew: homebrew/Brewfile
	@brew update
	@brew bundle --file=~/.dotfiles/homebrew/Brewfile
	@brew cleanup
	@brew doctor

install:
	@./scripts/install

.PHONY: install homebrew
