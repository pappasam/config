MKDIR_CONFIG = $(subst dotfiles, ~, $(wildcard dotfiles/.config/*))

.PHONY: help
help: ## Print each target and its associated help message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: install
install: ## Install stowed dotfiles to home directory
	@mkdir -p $(MKDIR_CONFIG)
	@mkdir -p ~/.config/Code/User
	stow --target $(HOME) --restow dotfiles

.PHONY: run-scripts
run-scripts: ## Run relevant scripts (apt-install, etc) to set up system
	mkdir -p ~/.config/sensitive
	bash ./scripts/ubuntu/apt-installs.sh
	bash ./scripts/ubuntu/custom-installs.sh

.PHONY: murmure-import
murmure-import: ## Import the repo-backed Murmure configuration
	bash ./scripts/murmure/import-config.sh

.PHONY: murmure-sync
murmure-sync: ## Refresh the repo-backed Murmure configuration from local app state
	bash ./scripts/murmure/sync-config.sh

.PHONY: clean
clean: ## Remove stowed links
	stow --target $(HOME) -D dotfiles
