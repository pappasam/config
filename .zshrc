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
# ZShell Options --- {{{

#######################################################################
# Set options
#######################################################################

# enable functions to operate in PS1
setopt PROMPT_SUBST

# list available directories automatically
setopt AUTO_LIST
setopt LIST_AMBIGUOUS
setopt LIST_BEEP

#######################################################################
# Unset options
#######################################################################

# disable quicker completion
unsetopt MENU_COMPLETE

# do not automatically remove the slash
unsetopt AUTO_REMOVE_SLASH

#######################################################################
# Expected parameters
#######################################################################
export PERIOD=1

# }}}
# ZShell Menu Completion --- {{{

autoload -U compinit && compinit
zstyle ':completion:*:*:git:*' script /usr/local/etc/bash_completion.d/git-completion.bash

# CURRENT STATE: does not select any sort of searching
# searching was too annoying and I didn't really use it
# If you want it back, use "search-backward" as an option
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"

# Fuzzy completion
zstyle ':completion:*' matcher-list '' \
  'm:{a-z\-A-Z}={A-Z\_a-z}' \
  'r:[^[:alpha:]]||[[:alpha:]]=** r:|=* m:{a-z\-A-Z}={A-Z\_a-z}' \
  'r:|?=** m:{a-z\-A-Z}={A-Z\_a-z}'
fpath=(/usr/local/share/zsh-completions $fpath)
zmodload -i zsh/complist

# }}}
# ZShell Misc Autoloads --- {{{

# Enables zshell calculator: type with zcalc
autoload -Uz zcalc

# }}}
# ZShell Hook Functions --- {{{

# NOTE: precmd is defined within the prompt section

# Executed whenever the current working directory is changed
function chpwd() {
  ls --color=auto
}

# Executed every $PERIOD seconds, just before a prompt.
# NOTE: if multiple functions are defined using the array periodic_functions,
# only  one  period  is applied to the complete set of functions, and the
# scheduled time is not reset if the list of functions is altered.
# Hence the set of functions is always called together.
function periodic() {
}

# Executed just after a command has been read and is about to be executed
#   arg1: the string that the user typed OR an empty string
#   arg2: a single-line, size-limited version of the command
#     (with things like function bodies elided)
#   arg3: full text that is being executed
function preexec() {
  # local user_string="$1"
  # local cmd_single_line="$2"
  # local cmd_full="$3"
}


# Executed when a history line is read interactively, but before it is executed
#   arg1: the complete history line (terminating newlines are present
function zshaddhistory() {
  # local history_complete="$1"
}

# Executed at the point where the main shell is about to exit normally.
function zshexit() {
}


# }}}
# ZShell Key-Bindings --- {{{

# emacs
bindkey -e

# NOTE: about menu-complete
# '^d' - list options without selecting any of them
# '^i' - synonym to TAB; tap twice to get into menu complete
# '^o' - choose selection and execute
# '^j' - choose selection but do NOT execute AND leave current mode
# '^k' - choose selection but do NOT execute AND leave all modes in menu-select
#         useful to get out of both select and search-backward
# '^p' - cycle through options backward (binding below necessary)
# '^n' - cycle through options forward (binding below necessary)
# '^z' - stop interactive tab-complete mode and go back to regular selection

bindkey -M menuselect '^n' expand-or-complete
bindkey -M menuselect '^p' reverse-menu-complete

# delete function characters to include
# Omitted: /=
WORDCHARS='*?_-.[]~&;!#$%^(){}<>'

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

# Vim and Vi
alias vi="nvim"
alias vim='nvim'

# Tree that ignores annoying directories
alias itree="tree -I '__pycache__|venv'"

# Tmux launch script
alias t='~/tmuxlaunch.sh'

# enable color support of ls and also add handy aliases
alias ls='ls --color=auto'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

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
alias gp="git remote prune origin"

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
function gitzip() {  # arg1: the git repository
  if [ $# -eq 0 ]; then
    local git_dir='.'
  else
    local git_dir="$1"
  fi
  pushd $git_dir > /dev/null
  local git_root=$(git rev-parse --show-toplevel)
  local git_name=$(basename $git_root)
  local outfile="$git_root/../$git_name.zip"
  git archive --format=zip --prefix="$git_name-from-zip/" HEAD -o "$outfile"
  popd > /dev/null
}

function cats() {
  pygmentize -g $1 | less -rc
}

# dictionary lookups
function def() {  # arg1: word
  dict -d gcide $1 | less -XF
}

function syn() {  # arg1: word
  dict -d moby-thesaurus $1 | less -XF
}

# install
function install() {  # arg1: word
  apt-cache show $1 && sudo apt install $1
}

# Move up n directories using:  cd.. dir
function cd_up() {  # arg1: number|word
  pushd . >/dev/null
  cd $( pwd | sed -r "s|(.*/$1[^/]*/).*|\1|" ) # cd up into path (if found)
}

# Get the weather
function weather() {  # arg1: Optional<location>
  if [ $# -eq 0 ]; then
    curl wttr.in/new_york
  else
    curl wttr.in/$1
  fi
}

# Open pdf files with Zathura
function pdf() {  # arg1: filename
  # GDK_SCALE is set to 2 for hd monitors
  # this environment variable makes text fuzzy on my 4k monitor
  # setting env var to 0 fixes the problem
  # The () communicate that the entire process should execute in a subshell,
  # avoiding unnecessary printing to console
  (GDK_SCALE=0 zathura "$1" &> /dev/null &)
}

# Open files with gnome-open
function gn() {  # arg1: filename
  local gn_filename=$(basename "$1")
  local gn_extension="${gn_filename##*.}"
  if [[ "$gn_extension" != "pdf" ]]; then
    gnome-open "$1" &> /dev/null
  elif ! type "zathura" &> /dev/null; then
    gnome-open "$1" &> /dev/null
  else
    pdf "$1"
  fi
}

# activate virtual environment from any directory from current and up
DEFAULT_VENV_NAME=venv
DEFAULT_PYTHON_VERSION="3.6"
function va() {
  if [ $# -eq 0 ]; then
    local VENV_NAME=$DEFAULT_VENV_NAME
  else
    local VENV_NAME="$1"
  fi
  local slashes=${PWD//[^\/]/}
  local DIR="$PWD"
  for (( n=${#slashes}; n>0; --n ))
  do
    if [ -d "$DIR/$VENV_NAME" ]; then
      source "$DIR/$VENV_NAME/bin/activate"
      local DIR_REL=$(realpath --relative-to='.' "$DIR/$VENV_NAME")
      echo "Activated $(python --version) virtualenv in $DIR_REL/"
      return
    fi
    local DIR="$DIR/.."
  done
  echo "no $VENV_NAME/ found from here to OS root"
}

# [optionally] create and activate Python virtual environment
function ve() {
  if [ $# -eq 0 ]; then
    local VENV_NAME="$DEFAULT_VENV_NAME"
  else
    local VENV_NAME="$1"
  fi
  if [ ! -d "$VENV_NAME" ]; then
    echo "Creating new Python virtualenv in $VENV_NAME/"
    python$DEFAULT_PYTHON_VERSION -m venv "$VENV_NAME"
    source "$VENV_NAME/bin/activate"
    pip install -U pip neovim bpython
    deactivate
    va
  else
    va
  fi
}

# Clubhouse story template
function clubhouse() {
  echo -e "## Objective\n## Value\n## Acceptance Criteria" | pbcopy
}

# Reload bashrc
function so() {
  source ~/.zshrc
}

# GIT: git-clone keplergrp repos to src/ directory
function klone() {
  git clone git@github.com:KeplerGroup/$1 $HOME/src/$1
}

# GIT: push current branch from origin to current branch
function push() {
  local current_branch="$(git rev-parse --abbrev-ref HEAD)"
  git push -u origin "$current_branch"
}

# GIT: pull current branch from origin to current branch
function pull() {
  local current_branch="$(git rev-parse --abbrev-ref HEAD)"
  git pull origin "$current_branch"
}

# Timer
function countdown-seconds(){
  local date1=$((`date +%s` + $1));
  while [ "$date1" -ge `date +%s` ]; do
    ## Is this more than 24h away?
    local days=$(($(($(( $date1 - $(date +%s))) * 1 ))/86400))
    echo -ne "$days day(s) and $(date -u --date @$(($date1 - `date +%s`)) +%H:%M:%S)\r";
    sleep 0.1
  done
  echo ""
  spd-say "Beep, beep, beeeeeeeep. Countdown is finished"
}

function countdown-minutes() {
  countdown-seconds $(($1 * 60))
}

function stopwatch(){
  local date1=`date +%s`;
  while true; do
    local days=$(( $(($(date +%s) - date1)) / 86400 ))
    echo -ne "$days day(s) and $(date -u --date @$((`date +%s` - $date1)) +%H:%M:%S)\r";
    sleep 0.1
  done
}

function quote() {
  local cowsay_word_message="$(shuf -n 1 ~/dotfiles/gre_words.txt)"
  local cowsay_quote="$(fortune -s ~/dotfiles/fortunes/ | grep -v '\-\-' | grep .)"
  echo -e "$cowsay_word_message\n\n$cowsay_quote" | cowsay
}

# }}}
# ZShell prompt (PS1) --- {{{

# NOTE this is not cross-shell; zsh-specific

#######################################################################
# BEGIN: Git formatting
#######################################################################
autoload -Uz vcs_info
zstyle ':vcs_info:*' stagedstr '%F{yellow}🔒%f'
zstyle ':vcs_info:*' unstagedstr '%F{red}🔓%f'
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' actionformats \
  '%F{magenta}[%F{green}%b%F{yellow}|%F{red}%a%F{magenta}]%f '
zstyle ':vcs_info:*' formats \
  '%F{magenta}[%F{green}%b%m%F{magenta}] %F{green}%c%F{yellow}%u%f'
zstyle ':vcs_info:git*+set-message:*' hooks git-untracked git-st git-stash
zstyle ':vcs_info:*' enable git

# Show untracked files
function +vi-git-untracked() {
  if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
  [[ $(git ls-files --others --exclude-standard | sed q | wc -l | tr -d ' ') == 1 ]] ; then
  hook_com[unstaged]+='%F{red}🔍%f'
  fi
}

# Show remote ref name and number of commits ahead-of or behind
function +vi-git-st() {
  local ahead behind remote
  local -a gitstatus

  # Are we on a remote-tracking branch?
  remote=${$(git rev-parse --verify ${hook_com[branch]}@{upstream} \
    --symbolic-full-name 2>/dev/null)/refs\/remotes\/}

  if [[ -n ${remote} ]] ; then
    ahead=$(git rev-list ${hook_com[branch]}@{upstream}..HEAD 2>/dev/null | wc -l)
    (( $ahead )) && gitstatus+=( "${c3}+${ahead}${c2}" )
    behind=$(git rev-list HEAD..${hook_com[branch]}@{upstream} 2>/dev/null | wc -l)
    (( $behind )) && gitstatus+=( "${c4}-${behind}${c2}" )
    hook_com[branch]="${hook_com[branch]} [🛂${(j:/:)gitstatus}]"
  fi
}

# Show count of stashed changes
function +vi-git-stash() {
  local -a stashes

  if [[ -s ${hook_com[base]}/.git/refs/stash ]] ; then
    stashes=$(git stash list 2>/dev/null | wc -l)
    hook_com[misc]+=" (💰${stashes})"
  fi
}

function precmd() { vcs_info }
#######################################################################
# END: Git formatting
#######################################################################

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
# Executed Commands --- {{{

# turn off ctrl-s and ctrl-q from freezing / unfreezing terminal
stty -ixon

# get a cool quote
quote

# }}}
