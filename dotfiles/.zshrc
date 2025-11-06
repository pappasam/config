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
# BEGIN: zsh hooks
function chpwd() {
  ls
}
function precmd() {
  eval "$PROMPT_COMMAND";
  dir=$(pwd | sed -E -e "s:^${HOME}:~:" -e "s:([^/\.])[^/]+/:\1/:g")
  printf "\033]0;%s(zsh)\007" "$dir"
}
function preexec() {
  dir=$(pwd | sed -E -e "s:^${HOME}:~:" -e "s:([^/\.])[^/]+/:\1/:g")
  printf "\033]0;%s($1)\007" "$dir"
}
# END: zsh hooks
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
function _dircomp_config() { _directories -W "$HOME/config"; }
function _dircomp_kepler() { _directories -W "$HOME/src/KeplerGroup"; }
function _dircomp_kyu() { _directories -W "$HOME/src/kyucollective"; }
function _dircomp_pappasam() { _directories -W "$HOME/src/pappasam"; }
function _dircomp_rocket() { _directories -W "$HOME/src/KeplerGroup/KIP-Rocket"; }
function _dircomp_vplug() { _directories -W "$HOME/.local/share/nvim/site/pack/core/opt"; }
function _dircomp_lib() { _directories -W "$HOME/src/lib"; }
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
compdef "_files -W $GITIGNORE_DIR/" gitignore
compdef _command ve
compdef _dircomp_config c
compdef _dircomp_kepler k
compdef _dircomp_kyu kk
compdef _dircomp_lib l
compdef _dircomp_pappasam pp
compdef _dircomp_rocket r
compdef _dircomp_vplug vplug
compdef _directories d
compdef _git_branches gdl
compdef _git_branches gdd
compdef _git_branches gdp
compdef _info info
compdef _make m
compdef _vim f
compdef _vim fn
# Most additional completions
if command -v carapace > /dev/null; then # https://github.com/rsteube/carapace-bin
  source <(carapace _carapace) # https://carapace-sh.github.io/carapace-bin/completers.html
fi
# Completion that isn't included by carapace
if command -v pipx > /dev/null; then
  eval "$(register-python-argcomplete pipx)"
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
[[ ! -r "$HOME/.opam/opam-init/init.zsh" ]] || source "$HOME/.opam/opam-init/init.zsh"  > /dev/null 2> /dev/null
