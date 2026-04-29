#!/usr/bin/zsh
if [[ -f "$HOME/.bashrc" ]]; then
  source "$HOME/.bashrc"
else
  echo "$HOME/.bashrc not found, zsh loading default shell"
  return 0
fi
fpath=($fpath $HOME/.zfunc)
export STARSHIP_CONFIG=~/.config/starship/starship.toml
export HISTFILE=~/.zsh_history
export PERIOD=1
export LISTMAX=0
export WORDCHARS='*?_-.[]~&;!#$%^(){}<>' # delete function characters to include (omitted /=)
export CARAPACE_MATCH=1
export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense'
export ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd completion history)
export ZSH_AUTOSUGGEST_MANUAL_REBIND=1
export ZSH_AUTOSUGGEST_HISTORY_IGNORE='?(#c1,2)'
export ZSH_AUTOSUGGEST_COMPLETION_IGNORE='?(#c1,2)'
export ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=(end-of-line)
export ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS=(forward-word forward-char)
alias pip='noglob pip' # Python: enable things like "pip install 'requests[security]'"
if [ -f "$HOME/.local/share/zinit/zinit.git/zinit.zsh" ]; then
  source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
  zinit light zsh-users/zsh-autosuggestions
  zinit light zsh-users/zsh-syntax-highlighting
  zinit light zsh-users/zsh-completions
  zinit light starship/starship
  # https://github.com/zdharma-continuum/zinit?tab=readme-ov-file#plugins-and-snippets
  zinit ice as"command" from"gh-r" \
    atclone"./starship init zsh > init.zsh; ./starship completions zsh > _starship" \
    atpull"%atclone" src"init.zsh"
fi
setopt ALWAYS_TO_END
setopt APPENDHISTORY
setopt AUTO_LIST
setopt AUTO_MENU
setopt AUTOCD
setopt COMPLETE_IN_WORD
setopt GLOB_COMPLETE
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt INCAPPENDHISTORY
setopt LIST_PACKED
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
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]-_}={[:upper:][:lower:]_-}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*:messages' format '%F{purple}-- %d --%f'
zstyle ':completion:*:warnings' format '%F{red}-- no matches --%f'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$HOME/.zcompcache"
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' complete-options true
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zmodload -i zsh/complist
bindkey -e # emacs
bindkey '^y' autosuggest-accept
bindkey '^f' forward-word
bindkey -M menuselect '^j' menu-complete
bindkey -M menuselect '^k' reverse-menu-complete
bindkey -M menuselect '^h' backward-char
bindkey -M menuselect '^l' forward-char
bindkey -M menuselect '^[' send-break
bindkey -M menuselect '^y' accept-line
bindkey -M menuselect '^m' accept-line-and-down-history
compdef "_files -W $GITIGNORE_DIR/" gitignore
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
