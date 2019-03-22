CONFIG_DIRS_DOTFILES := $(wildcard dotfiles/.config/*)
CONFIG_DIRS_HOME := $(subst dotfiles, ~, $(CONFIG_DIRS_DOTFILES))
HOME_DIRS_MKDIR = ~/.stack/ ~/bin/ ~/.ptpython

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: system_setup
system_setup:  ## Set up the operating system with an ansible playbook
	ansible-playbook \
		--ask-become-pass \
		--inventory=inventory/localhost \
		$@.yml

.PHONY: dotfiles
dotfiles: config_directories ## Place dotfiles in home folder, replacing all owned by stow
	-mkdir -p $(HOME_DIRS_MKDIR)
	stow -t ~ -R $@/

.PHONY: config_directories
config_directories: $(CONFIG_DIRS_HOME)  ## Create directories in ~/.config. Useful because these directories might not exist yet

~/.config/%: dotfiles/.config/%
	-mkdir -p $@
