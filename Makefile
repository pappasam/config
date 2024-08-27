MKDIR_CONFIG = $(subst dotfiles, ~, $(wildcard dotfiles/.config/*))

.PHONY: help
help: ## Print each target and its associated help message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: stow
stow: ## Run stow on dotfiles directory, linking files to home directory
	@mkdir -p $(MKDIR_CONFIG)
	stow --target $(HOME) --restow dotfiles

.PHONY: clean
clean: ## Remove stowed links
	stow --target $(HOME) -D dotfiles

.PHONY: setup-ubuntu
setup-ubuntu: ## Setup Ubuntu for the first time
	mkdir -p ~/.config/sensitive
	bash ./scripts/ubuntu/apt-installs.sh
	bash ./scripts/ubuntu/custom-installs.sh

.PHONY: setup-asdf
setup-asdf: ## Install useful software post asdf installation
	bash ./scripts/ubuntu/asdf-installs.sh

.PHONY: setup-cinnamon-on-ubuntu
setup-cinnamon-on-ubuntu: ## Run commands to get cinnamon working, if relevant
	bash ./scripts/ubuntu/ubuntu-cinnamon.sh
