help: ## Show this help.
	@fgrep -h "##" $(MAKEFILE_LIST) | \
		fgrep -v fgrep | \
		sed -e 's/\\$$//' | \
		sed -e 's/##//'

.PHONY: dotfiles
dotfiles: ## Place dotfiles in home folder, replacing all owned by stow
	stow -R dotfiles/
