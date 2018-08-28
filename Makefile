CONFIG_DIRS_DOTFILES := $(wildcard dotfiles/.config/*)
CONFIG_DIRS_HOME := $(subst dotfiles, ~, $(CONFIG_DIRS_DOTFILES))

help: ## Show this help.
	@fgrep -h "##" $(MAKEFILE_LIST) | \
		fgrep -v fgrep | \
		sed -e 's/\\$$//' | \
		sed -e 's/##//'

.PHONY: dotfiles
dotfiles: config_directories ## Place dotfiles in home folder, replacing all owned by stow
	stow -t ~ -R dotfiles/

.PHONY: config_directories
config_directories: $(CONFIG_DIRS_HOME)  ## Create directories in ~/.config. Useful because these directories might not exist yet

~/.config/%: dotfiles/.config/%
	-mkdir -p $@
