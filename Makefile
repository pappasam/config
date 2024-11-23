MKDIR_CONFIG = $(subst dotfiles, ~, $(wildcard dotfiles/.config/*))

.PHONY: help
help: ## Print each target and its associated help message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: setup
setup: dotfiles run-scripts ## Run all system setup steps

.PHONY: dotfiles
dotfiles: ## Run stow on dotfiles directory, linking files to home directory
	@mkdir -p $(MKDIR_CONFIG)
	@mkdir -p ~/.config/nvim/pack
	stow --target $(HOME) --restow dotfiles

.PHONY: run-scripts
run-scripts: ## Run relevant scripts (apt-install, etc) to set up system
	mkdir -p ~/.config/sensitive
	bash ./scripts/ubuntu/apt-installs.sh
	bash ./scripts/ubuntu/custom-installs.sh

.PHONY: clean
clean: ## Remove stowed links
	stow --target $(HOME) -D dotfiles
