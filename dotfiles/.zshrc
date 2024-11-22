#!/usr/bin/zsh
# shellcheck shell=sh disable=all
if [[ -f "$HOME/.bashrc" ]]; then source "$HOME/.bashrc"; else echo "$HOME/.bashrc not found, zsh loading default shell" && return 0; fi
fpath=(${ASDF_DIR}/completions /usr/local/share/zsh-completions $fpath $HOME/.zfunc)
export STARSHIP_CONFIG=~/.config/starship/starship.toml
export HISTFILE=~/.zsh_history
export PERIOD=1
export LISTMAX=0
export WORDCHARS='*?_-.[]~&;!#$%^(){}<>' # delete function characters to include (omitted /=)
export ZSH_AUTOSUGGEST_STRATEGY=(completion)
alias pip='noglob pip' # Python: enable things like "pip install 'requests[security]'"
if [ -f "$HOME/.local/share/zinit/zinit.git/zinit.zsh" ]; then
  source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
  zinit ice wait lucid atinit "ZINIT[COMPINIT_OPTS]=-C; zpcompinit; zpcdreplay" && zinit light zsh-users/zsh-syntax-highlighting
  zinit ice wait lucid && zinit light zsh-users/zsh-completions
  zinit light starship/starship
  # https://github.com/zdharma-continuum/zinit?tab=readme-ov-file#plugins-and-snippets
  zinit ice as"command" from"gh-r" \
    atclone"./starship init zsh > init.zsh; ./starship completions zsh > _starship" \
    atpull"%atclone" src"init.zsh"
fi
function zinit-update {
  zinit self-update && zinit update --all
}
setopt APPENDHISTORY
setopt AUTOCD
setopt AUTO_LIST
setopt COMPLETE_ALIASES
setopt HIST_IGNORE_SPACE
setopt INCAPPENDHISTORY
setopt PROMPT_SUBST
setopt SHAREHISTORY
unsetopt MENU_COMPLETE
unsetopt AUTOREMOVESLASH
function precmd() { eval "$PROMPT_COMMAND"; } # zsh hook
autoload zcalc # enables zshell calculator: type with zcalc
autoload compinit
# BEGIN: https://gist.github.com/ctechols/ca1035271ad134841284
for dump in ~/.zcompdump(N.mh+24); do
  compinit
done
compinit -C
# END
autoload +X bashcompinit && bashcompinit
zstyle ':completion:*:*:git:*' script /usr/local/etc/bash_completion.d/git-completion.bash
zstyle ':completion:*' menu select incremental
zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"
zstyle ':completion:*' matcher-list '' 'm:{a-z\-A-Z}={A-Z\_a-z}' 'r:[^[:alpha:]]||[[:alpha:]]=** r:|=* m:{a-z\-A-Z}={A-Z\_a-z}' 'r:|?=** m:{a-z\-A-Z}={A-Z\_a-z}'
zmodload -i zsh/complist
bindkey -e # emacs
bindkey -M menuselect '^j' menu-complete
bindkey -M menuselect '^k' reverse-menu-complete
bindkey -M menuselect '^h' backward-char
bindkey -M menuselect '^l' forward-char
bindkey -M menuselect '^m' accept-line-and-down-history
bindkey -M menuselect '^y' accept-line
function _vplug_completion() { _directories -W "$HOME/.config/nvim/pack/packager/start"; }
function _kepler_completion() { _directories -W "$HOME/src/KeplerGroup"; }
function _rocket_completion() { _directories -W "$HOME/src/KeplerGroup/KIP-Rocket"; }
function _pappasam_completion() { _directories -W "$HOME/src/pappasam"; }
function _git_branches() {
  if [ ! "$(git rev-parse --is-inside-work-tree 2>/dev/null )" ]; then return 0; fi
  local -a subcmds
  subcmds=($(git branch | awk '{print $NF}'))
  _describe 'Select an existing git branch' subcmds
}
function _info() {
  local -a subcmds
  subcmds=($(/bin/info --output=- --subnodes '(dir)' 2>/dev/null | grep '^\* ' | awk -F: '{print $1}' | sed 's/^* //' | sort | uniq | sed 's/ /%20/g'))
  _describe 'Describe info pages' subcmds
}
compdef _vim f
compdef _vim fn
compdef _directories d
compdef "_files -W $GITIGNORE_DIR/" gitignore
compdef _vplug_completion vplug
compdef _kepler_completion k
compdef _rocket_completion r
compdef _pappasam_completion p
compdef _command ve
compdef _git_branches gdl
compdef _info info
compdef _make m
# Most additional completions
if command -v carapace > /dev/null; then # https://github.com/rsteube/carapace-bin
  source <(carapace _carapace) # https://rsteube.github.io/carapace-bin/completers.html
fi
# Completion that isn't included by carapace
if command -v pipx > /dev/null; then
  eval "$(register-python-argcomplete pipx)"
fi
if command -v mise > /dev/null; then
  eval "$(mise completions zsh)"
fi
if command -v zoxide > /dev/null; then
  eval "$(zoxide init zsh)"
fi
