all: install

install:
	@./scripts/install

homebrew_setup:
	@./homebrew/setup.sh

osx:
	@./scripts/symlink
	@./scripts/osx


symlink:
	@./scripts/backup-config
	@./scripts/symlink

apt_setup:
	@./apt/ppa.sh

ubuntu: apt_setup
	@./scripts/symlink
	@./apt/install.sh

.PHONY: all install homebrew_setup osx symlink apt_setup ubuntu
