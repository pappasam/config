#!/usr/bin/zsh
# shellcheck shell=sh disable=all
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"; fi
if [[ -f "$HOME/.bashrc" ]]; then source "$HOME/.bashrc"; else echo "$HOME/.bashrc not found, zsh loading default shell" && return 0; fi
fpath=(${ASDF_DIR}/completions /usr/local/share/zsh-completions $fpath $HOME/.zfunc)
export HISTFILE=~/.zsh_history
export PERIOD=1
export LISTMAX=0
export WORDCHARS='*?_-.[]~&;!#$%^(){}<>' # delete function characters to include (omitted /=)
export ZSH_AUTOSUGGEST_STRATEGY=(completion)
alias z='nvim ~/config/dotfiles/.zshrc'
alias pip='noglob pip' # Python: enable things like "pip install 'requests[security]'"
if [ -f "$HOME/.local/share/zinit/zinit.git/zinit.zsh" ]; then
  source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
  zinit ice wait lucid atinit "ZINIT[COMPINIT_OPTS]=-C; zpcompinit; zpcdreplay" && zinit light zsh-users/zsh-syntax-highlighting
  zinit ice wait lucid && zinit light greymd/docker-zsh-completion
  zinit ice wait lucid && zinit light zsh-users/zsh-completions
  zinit ice depth=1 && zinit light romkatv/powerlevel10k
  [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
fi
function zinit-update { zinit self-update && zinit update --all ; }
setopt APPENDHISTORY
setopt AUTOCD
setopt AUTO_LIST
setopt COMPLETE_ALIASES
setopt HIST_IGNORE_SPACE
setopt INCAPPENDHISTORY
# setopt LIST_AMBIGUOUS
# setopt LIST_BEEP
setopt MENU_COMPLETE
setopt PROMPT_SUBST
setopt SHAREHISTORY
# unsetopt AUTO_REMOVE_SLASH
function precmd() { eval "$PROMPT_COMMAND"; } # zsh hook
autoload -Uz zcalc # enables zshell calculator: type with zcalc
autoload -U compinit && compinit
autoload -U +X bashcompinit && bashcompinit
zstyle ':completion:*:*:git:*' script /usr/local/etc/bash_completion.d/git-completion.bash
zstyle ':completion:*' menu select incremental search
zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"
zstyle ':completion:*' matcher-list '' 'm:{a-z\-A-Z}={A-Z\_a-z}' 'r:[^[:alpha:]]||[[:alpha:]]=** r:|=* m:{a-z\-A-Z}={A-Z\_a-z}' 'r:|?=** m:{a-z\-A-Z}={A-Z\_a-z}'
zmodload -i zsh/complist
if command -v aws > /dev/null; then complete -C aws_completer aws; fi
if command -v pipx > /dev/null; then eval "$(register-python-argcomplete pipx)"; fi
if command -v kubectl > /dev/null; then source <(kubectl completion zsh); fi
bindkey -e # emacs
bindkey -M menuselect '^j' menu-complete
bindkey -M menuselect '^k' reverse-menu-complete
bindkey -M menuselect '^h' backward-char
bindkey -M menuselect '^l' forward-char
function _vplug_completion() { _directories -W "$HOME/.config/nvim/pack/packager/start"; }
function _asdf_complete_plugins() {
  local -a subcmds
  subcmds=($(asdf plugin-list | tr '\n' ' '))
  _describe 'List installed plugins for zsh completion' subcmds
}
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
compdef _command ve
compdef _asdf_complete_plugins asdfl
compdef _asdf_complete_plugins asdfpurge
compdef _git_branches gdl
compdef _info info
if [ $commands[direnv] ]; then emulate zsh -c "$(direnv hook zsh)"; fi
