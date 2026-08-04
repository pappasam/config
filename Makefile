MKDIR_CONFIG = $(subst dotfiles, ~, $(wildcard dotfiles/.config/*))
COMPLETION_DIR = dotfiles/.zfunc

.PHONY: help
help: ## Print each target and its associated help message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: completions
completions: ## Regenerate native Zsh completions for managed tools
	./scripts/dotfiles/gen-completion.sh "$(COMPLETION_DIR)/_mise" mise completions zsh
	./scripts/dotfiles/gen-completion.sh "$(COMPLETION_DIR)/_uv" uv generate-shell-completion zsh
	./scripts/dotfiles/gen-completion.sh "$(COMPLETION_DIR)/_uvx" uvx --generate-shell-completion zsh
	./scripts/dotfiles/gen-completion.sh "$(COMPLETION_DIR)/_codex" codex completion zsh

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

.PHONY: clean
clean: ## Remove stowed links
	stow --target $(HOME) -D dotfiles
