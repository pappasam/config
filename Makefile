CONFIG_DIRS_DOTFILES := $(wildcard dotfiles/.config/*)
CONFIG_DIRS_HOME := $(subst dotfiles, ~, $(CONFIG_DIRS_DOTFILES))

help: ## Show this help.
	@fgrep -h "##" $(MAKEFILE_LIST) | \
		fgrep -v fgrep | \
		sed -e 's/\\$$//' | \
		sed -e 's/##//'

.PHONY: dotfiles
dotfiles: directories ## Place dotfiles in home folder, replacing all owned by stow
	stow -R dotfiles/

.PHONY: directories
directories: $(CONFIG_DIRS_HOME)

~/.config/%: dotfiles/.config/%
	-mkdir -p $@
