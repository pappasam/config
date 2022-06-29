MKDIR_CONFIG = $(subst dotfiles, ~, $(wildcard dotfiles/.config/*))
MKDIR_HOME = ~/.stack/ ~/bin/

.PHONY: stow-dotfiles
stow-dotfiles:  ## soft-link dotfiles in home folder with stow
	@mkdir -p $(MKDIR_CONFIG) $(MKDIR_HOME)
	@echo "\033[1m\033[31mNOTE\033[0m: Ignore BUG warnings, they're spurious"
	stow --target $(HOME) --restow dotfiles

.PHONY: unstow-dotfiles
unstow-dotfiles:  ## remove stowed links
	@echo "\033[1m\033[31mNOTE\033[0m: Ignore BUG warnings, they're spurious"
	stow --target $(HOME) -D dotfiles
