all: install

install:
	@./scripts/install

homebrew_setup:
	@./homebrew/setup.sh

osx:
	@./scripts/symlink
	@./scripts/osx


symlink:
	@./scripts/symlink

apt_setup:
	@./apt/ppa.sh

ubuntu:
	@./scripts/symlink
	@./apt/install.sh

.PHONY: osx install symlink apt
