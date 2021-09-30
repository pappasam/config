MKDIR_CONFIG = $(subst dotfiles, ~, $(wildcard dotfiles/.config/*))
MKDIR_HOME = ~/.stack/ ~/bin/

.PHONY: xstow-dotfiles
xstow-dotfiles:  ## soft-link dotfiles in home folder with stow
	@mkdir -p $(MKDIR_CONFIG) $(MKDIR_HOME)
	xstow --target $(HOME) --restow dotfiles
