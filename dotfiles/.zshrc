#!/usr/bin/zsh
# shellcheck shell=sh disable=all
if [[ -f "$HOME/.bashrc" ]]; then source "$HOME/.bashrc"; else echo "$HOME/.bashrc not found, zsh loading default shell" && return 0; fi
fpath=($fpath $HOME/.zfunc)
export STARSHIP_CONFIG=~/.config/starship/starship.toml
export HISTFILE=~/.zsh_history
export PERIOD=1
export LISTMAX=0
export WORDCHARS='*?_-.[]~&;!#$%^(){}<>' # delete function characters to include (omitted /=)
export ZSH_AUTOSUGGEST_STRATEGY=(completion)
alias pip='noglob pip' # Python: enable things like "pip install 'requests[security]'"
if [ -f "$HOME/.local/share/zinit/zinit.git/zinit.zsh" ]; then
  source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
  zinit light zsh-users/zsh-syntax-highlighting
  zinit light zsh-users/zsh-completions
  zinit light starship/starship
  # https://github.com/zdharma-continuum/zinit?tab=readme-ov-file#plugins-and-snippets
  zinit ice as"command" from"gh-r" \
    atclone"./starship init zsh > init.zsh; ./starship completions zsh > _starship" \
    atpull"%atclone" src"init.zsh"
fi
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
autoload -Uz compinit && compinit
function precmd() { # hook
  dir=$(pwd | sed -E -e "s:^${HOME}:~:" -e "s:([^/\.])[^/]+/:\1/:g")
  printf "\033]0;%s(zsh)\007" "$dir"
}
function preexec() { # hook
  dir=$(pwd | sed -E -e "s:^${HOME}:~:" -e "s:([^/\.])[^/]+/:\1/:g")
  printf "\033]0;%s($1)\007" "$dir"
}
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
compdef "_files -W $GITIGNORE_DIR/" gitignore
compdef _command ve
compdef _directories d
compdef _make m
compdef _vim f
compdef _vim fn
if command -v carapace > /dev/null; then # https://github.com/rsteube/carapace-bin
  source <(carapace _carapace) # https://carapace-sh.github.io/carapace-bin/completers.html
fi
if command -v mise > /dev/null; then
  eval "$(mise completions zsh)"
fi
if command -v uv > /dev/null; then
  eval "$(uv generate-shell-completion zsh)"
fi
if command -v uvx > /dev/null; then
  eval "$(uvx --generate-shell-completion zsh)"
fi
