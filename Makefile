MKDIR_CONFIG = $(subst dotfiles, ~, $(wildcard dotfiles/.config/*))
MKDIR_HOME = ~/.stack/ ~/bin/

.PHONY: stow-dotfiles
stow-dotfiles:  ## soft-link dotfiles in home folder with stow
	@mkdir -p $(MKDIR_CONFIG) $(MKDIR_HOME)
	stow --target $(HOME) --restow dotfiles

.PHONY: stow-dotfiles-no-restow
stow-dotfiles-no-restow:  ## soft-link dotfiles in home folder with stow, without restow
	@mkdir -p $(MKDIR_CONFIG) $(MKDIR_HOME)
	stow --target $(HOME) dotfiles
