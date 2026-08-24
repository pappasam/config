#!/usr/bin/zsh
if [[ -r "$HOME/.config/shell/common.sh" ]]; then
  source "$HOME/.config/shell/common.sh"
else
  echo "$HOME/.config/shell/common.sh not found; zsh loading default shell" >&2
  return 0
fi

typeset -U path PATH
path=(
  "$HOME/config/bin"
  "$HOME/.local/bin"
  "$HOME/.bin"
  "$HOME/bin"
  "$HOME/.cargo/bin"
  "$HOME/.local/opt/curl/bin"
  $path
)
export PATH

fpath=("$HOME/.zfunc" $fpath)
export STARSHIP_CONFIG=~/.config/starship/starship.toml
export HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=5000
export PERIOD=1
export LISTMAX=0
export WORDCHARS='*?_-.[]~&;!#$%^(){}<>' # delete function characters to include (omitted /=)
export CARAPACE_BRIDGES=zsh
export CARAPACE_ENV=0
export CARAPACE_MATCH=1
export CARAPACE_UNFILTERED=1
export ZSH_AUTOSUGGEST_MANUAL_REBIND=1
export ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=(end-of-line)
export ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS=(forward-word forward-char)
alias pip='noglob pip' # Python: enable things like "pip install 'requests[security]'"
if [ -f "$HOME/.local/share/zinit/zinit.git/zinit.zsh" ]; then
  source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
  zinit light zsh-users/zsh-autosuggestions
  zinit light zsh-users/zsh-completions
  zinit light wbingli/zsh-claudecode-completion
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
  printf "\033]0;%s\007" "${PWD:t}"
}
function preexec() { # hook
  printf "\033]0;%s\007" "${PWD:t}"
}
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"
zstyle ':completion:*' completer _complete _approximate
zstyle ':completion:*' matcher-list \
  '' \
  'm:{[:lower:][:upper:]-_}={[:upper:][:lower:]_-}' \
  'm:{[:lower:][:upper:]-_}={[:upper:][:lower:]_-} l:|=* r:|=* r:|[/_.-]=**'
zstyle ':completion:*:approximate:*' max-errors 1 numeric
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-dirs-first true
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*:messages' format '%F{purple}-- %d --%f'
zstyle ':completion:*:warnings' format '%F{red}-- no matches --%f'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$HOME/.zcompcache"
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*:*:kill:*' menu yes select
# rewrites '#' as '\x23' for code formatter sanity
zstyle ':completion:*:*:kill:*:processes' list-colors $'=(\x23b) \x23([0-9]\x23)*=0=01;31'
zmodload -i zsh/complist
bindkey -e # emacs
bindkey '^y' autosuggest-accept
bindkey '^f' forward-word
bindkey '^[[Z' reverse-menu-complete
bindkey -M menuselect '^j' down-line-or-history
bindkey -M menuselect '^k' up-line-or-history
bindkey -M menuselect '^h' backward-char
bindkey -M menuselect '^l' forward-char
bindkey -M menuselect '^[[Z' reverse-menu-complete
bindkey -M menuselect '^[' send-break
bindkey -M menuselect '^y' accept-line
bindkey -M menuselect '^m' .accept-line
compdef "_files -W $GITIGNORE_DIR/" gitignore
function _wtclean() {
  local -a saved_words=("${words[@]}")
  local saved_current=$CURRENT
  local result
  words=(wt step prune "${saved_words[@]:1}")
  CURRENT=$((saved_current + 2))
  _wt_lazy_complete "$@"
  result=$?
  words=("${saved_words[@]}")
  CURRENT=$saved_current
  return $result
}
compdef _wtclean wtclean
if command -v carapace > /dev/null; then
  # Let Carapace fill gaps without replacing native or generated completions.
  typeset -A _native_completions
  _native_completions=("${(@kv)_comps}")
  source <(carapace _carapace zsh)
  for _command _completer in "${(@kv)_native_completions}"; do
    _comps[$_command]=$_completer
  done
  unset _native_completions _command _completer
fi
if [[ -o interactive ]]; then
  if [[ -e "$HOME/.local/bin/mise" ]]; then
    eval "$("$HOME/.local/bin/mise" activate zsh)"
    eval "$(mise hook-env -s zsh)"
  else
    echo 'Mise not installed, please install. See:'
    echo 'https://mise.jdx.dev/getting-started.html'
  fi
fi
if command -v fzf > /dev/null; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_DEFAULT_OPTS='--bind=ctrl-y:accept,ctrl-j:down,ctrl-k:up'
  export FZF_CTRL_T_COMMAND='fd --type f --hidden --follow --exclude .git'
  unset FZF_CTRL_R_COMMAND
  export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
  export FZF_COMPLETION_DIR_COMMANDS='cd pushd rmdir d'
  source <(fzf --zsh)

  function fzf-context-widget() {
    local FZF_COMPLETION_TRIGGER=''
    fzf-completion
  }
  zle -N fzf-context-widget
  bindkey '^T' fzf-context-widget
fi
if command -v starship > /dev/null; then
  eval "$(starship init zsh)"
fi
if (( $+functions[zinit] )); then
  zinit light zsh-users/zsh-syntax-highlighting
fi
if command -v wt >/dev/null 2>&1; then
  eval "$(command wt config shell init zsh)"
fi
