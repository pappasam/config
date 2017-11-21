#!/bin/zsh

# Notes --- {{{

# Searching for a specific man page
#   1. apropros
#   2. man -k

# }}}
# Import from other Bash Files --- {{{

include () {
  [[ -f "$1" ]] && source "$1"
}

include ~/.profile
include ~/.bashrc_local
include ~/.bash/sensitive

# }}}
# Executed Commands --- {{{

# turn off ctrl-s and ctrl-q from freezing / unfreezing terminal
stty -ixon

# run cowsay
COWSAY_WORD_MESSAGE="$(shuf -n 1 ~/dotfiles/gre_words.txt)"
COWSAY_QUOTE="$(fortune -s ~/dotfiles/fortunes/ | grep -v '\-\-' | grep .)"
echo -e "$COWSAY_WORD_MESSAGE\n\n$COWSAY_QUOTE" | cowsay

# }}}
# ZShell Options --- {{{

# enable functions to operate in PS1
setopt PROMPT_SUBST

# do not automatically remove the slash
unsetopt AUTO_REMOVE_SLASH

# }}}
# ZShell Styles --- {{{

zstyle ':completion:*:*:git:*' script /usr/local/etc/bash_completion.d/git-completion.bash
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"
fpath=(/usr/local/share/zsh-completions $fpath)
autoload -U compinit && compinit
zmodload -i zsh/complist

# }}}
# ZShell Key-Bindings --- {{{

# emacs
bindkey -e

# j selects options down, k selects options up
bindkey -r '^j'
bindkey -r -M menuselect '^j'
bindkey '^j' expand-or-complete
bindkey -M menuselect '^j' menu-complete

bindkey '^k' reverse-menu-complete

# delete function doesn't delete /
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

# }}}
# Aliases --- {{{

# Easier directory navigation for going up a directory tree
alias 'a'='cd - &> /dev/null'
alias 'cd..'='cd_up'  # can not name function 'cd..'; references cd_up below
alias .='cd ..'
alias ..='cd ../..'
alias ...='cd ../../..'
alias ....='cd ../../../..'
alias .....='cd ../../../../..'
alias ......='cd ../../../../../..'
alias .......='cd ../../../../../../..'
alias ........='cd ../../../../../../../..'
alias .........='cd ../../../../../../../../..'
alias ..........='cd ../../../../../../../../../..'

# Tree that ignores annoying directories
alias itree="tree -I '__pycache__|venv'"

# Tmux launch script
alias t='~/tmuxlaunch.sh'

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# ls aliases
alias sl='ls'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# diff
# r: recursively; u: shows line number; p: shows difference in C function
# P: if multiple files then showing complete path
alias diff="diff -rupP"

# Set copy/paste helper functions
# the perl step removes the final newline from the output
alias pbcopy="perl -pe 'chomp if eof' | xsel --clipboard --input"
alias pbpaste="xsel --clipboard --output"

# Octave
alias octave="octave --no-gui"

# Public IP
alias publicip='wget -qO - http://ipecho.net/plain ; echo'

# Git
alias g="git status"
alias gl="git branch --verbose --all"
alias gm="git commit --verbose"
alias gma="git commit --verbose --all"

# Less with default options
# -c: auto-clear screen
# alias less='less -c'

# Regex ignore annoying directories
alias regrep="grep --perl-regexp -Ir \
--exclude=*~ \
--exclude=*.pyc \
--exclude=*.csv \
--exclude=*.tsv \
--exclude=*.md \
--exclude-dir=.bzr \
--exclude-dir=.git \
--exclude-dir=.svn \
--exclude-dir=node_modules \
--exclude-dir=venv"

# upgrade
alias upgrade="sudo apt-get update && sudo apt-get upgrade"

# battery
alias bat='upower -i /org/freedesktop/UPower/devices/battery_BAT0| grep -E "state|to\ full|percentage"'

# dynamodb
alias docker-dynamodb="docker run -v /data:$HOME/data -p 8000:8000 dwmkerr/dynamodb -dbPath $HOME/data"

# }}}
# Functions --- {{{

# Colored cat
cats() {
  pygmentize -g $1 | less -rc
}

# dictionary lookups
def() {  # arg1: word
  dict -d gcide $1 | less -XF
}

syn() {  # arg1: word
  dict -d moby-thesaurus $1 | less -XF
}

# install
install() {  # arg1: word
  apt-cache show $1 && sudo apt install $1
}

# Move up n directories using:  cd.. dir
cd_up() {  # arg1: number|word
  pushd . >/dev/null
  cd $( pwd | sed -r "s|(.*/$1[^/]*/).*|\1|" ) # cd up into path (if found)
}

# Get the weather
weather() {  # arg1: Optional<location>
  if [ $# -eq 0 ]; then
    curl wttr.in/new_york
  else
    curl wttr.in/$1
  fi
}

# Open pdf files with Zathura
pdf() {  # arg1: filename
  # GDK_SCALE is set to 2 for hd monitors
  # this environment variable makes text fuzzy on my 4k monitor
  # setting env var to 0 fixes the problem
  # The () communicate that the entire process should execute in a subshell,
  # avoiding unnecessary printing to console
  (GDK_SCALE=0 zathura "$1" &> /dev/null &)
}

# Open files with gnome-open
gn() {  # arg1: filename
  gn_filename=$(basename "$1")
  gn_extension="${gn_filename##*.}"
  if [[ "$gn_extension" != "pdf" ]]; then
    gnome-open "$1" &> /dev/null
  elif ! type "zathura" &> /dev/null; then
    gnome-open "$1" &> /dev/null
  else
    pdf "$1"
  fi
}

urlencode() {  # arg1: urlencode <string>
  old_lc_collate=$LC_COLLATE
  LC_COLLATE=C

  local length="${#1}"
  for (( i = 0; i < length; i++ )); do
    local c="${1:i:1}"
    case $c in
      [a-zA-Z0-9.~_-]) printf "$c" ;;
      *) printf '%%%02X' "'$c" ;;
    esac
  done
  LC_COLLATE=$old_lc_collate
  printf '\n'
}

urldecode() {  # arg1: urldecode <string>
  local url_encoded="${1//+/ }"
  printf '%b' "${url_encoded//%/\\x}"
  printf '\n'
}

# [optionally] create and activate Python virtual environment
ve() {
  if [ ! -d venv ]; then
    echo "Creating new Python 3.6 virtualenv"
    python3.6 -m venv venv
    source venv/bin/activate
    pip install -U pip
    pip install neovim
  else
    source venv/bin/activate
  fi
  echo "Activated $(python --version) virtualenv"
}

# alias for ve because I type va a lot more
va() {
  ve
}

# Clubhouse story template
clubhouse() {
  echo -e "## Objective\n## Value\n## Acceptance Criteria" | pbcopy
}

# Reload bashrc
so() {
  source ~/.bashrc
}

# GIT: git-clone keplergrp repos to src/ directory
klone() {
  git clone git@github.com:KeplerGroup/$1 $HOME/src/$1
}

# GIT: push current branch from origin to current branch
push() {
  CURRENT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
  git push origin "$CURRENT_BRANCH"
}

# GIT: pull current branch from origin to current branch
pull() {
  CURRENT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
  git pull origin "$CURRENT_BRANCH"
}

# Timer
countdown-seconds(){
  date1=$((`date +%s` + $1));
  while [ "$date1" -ge `date +%s` ]; do
    ## Is this more than 24h away?
    days=$(($(($(( $date1 - $(date +%s))) * 1 ))/86400))
    echo -ne "$days day(s) and $(date -u --date @$(($date1 - `date +%s`)) +%H:%M:%S)\r";
    sleep 0.1
  done
  echo ""
  spd-say "Beep, beep, beeeeeeeep. Countdown is finished"
}

countdown-minutes() {
  countdown-seconds $(($1 * 60))
}

stopwatch(){
  date1=`date +%s`;
  while true; do
    days=$(( $(($(date +%s) - date1)) / 86400 ))
    echo -ne "$days day(s) and $(date -u --date @$((`date +%s` - $date1)) +%H:%M:%S)\r";
    sleep 0.1
  done
}

# }}}
# ZShell Command line prompt (PS1) --- {{{

# NOTE this is not cross-shell; zsh-specific

autoload -Uz vcs_info
zstyle ':vcs_info:*' stagedstr '🌊 '
zstyle ':vcs_info:*' unstagedstr '🔥 '
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' actionformats '%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f '
zstyle ':vcs_info:*' formats \
  '%F{5}[%F{2}%b%F{5}] %F{2}%c%F{3}%u%f'
zstyle ':vcs_info:git*+set-message:*' hooks git-untracked
zstyle ':vcs_info:*' enable git
+vi-git-untracked() {
  if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
  [[ $(git ls-files --other --directory --exclude-standard | sed q | wc -l | tr -d ' ') == 1 ]] ; then
  hook_com[unstaged]+='%F{1}??%f'
fi
}

precmd () { vcs_info }

COLOR_BRIGHT_BLUE="086"
COLOR_GOLD="184"
COLOR_SILVER="250"

# Set Bash PS1
PS1_DIR="%B%F{$COLOR_BRIGHT_BLUE}%~%f%b"
PS1_USR="%B%F{$COLOR_GOLD}%n@%M%b%f"
PS1_END="%B%F{$COLOR_SILVER}$ %f%b"

PS1="${PS1_DIR} \$vcs_info_msg_0_ \

${PS1_USR} ${PS1_END}"

# }}}
