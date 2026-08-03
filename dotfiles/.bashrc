#!/bin/bash
if [[ -r "$HOME/.config/shell/common.sh" ]]; then
  # shellcheck source=/dev/null
  source "$HOME/.config/shell/common.sh"
else
  echo "$HOME/.config/shell/common.sh not found; bash loading without shared configuration" >&2
fi

export HISTCONTROL=ignorespace
export HISTFILE=~/.bash_history
export HISTSIZE=5000

function rm_from_path() { # $1: path to remove
  PATH=$(echo "$PATH" | tr ':' '\n' | grep -v "^${1}$" | tr '\n' ':' | sed 's/:$//')
}
function path_ladd() { # $1 path to add
  rm_from_path "$1"
  PATH="$1${PATH:+":$PATH"}"
}
function path_radd() { # $1 path to add
  rm_from_path "$1"
  PATH="${PATH:+"$PATH:"}$1"
}
path_ladd "$HOME/.local/opt/curl/bin"
path_ladd "$HOME/.cargo/bin"
path_ladd "$HOME/bin"
path_ladd "$HOME/.bin"
path_ladd "$HOME/.local/bin"
path_ladd "$HOME/config/bin"
export PATH

if [[ -n "${BASH_VERSION-}" ]]; then
  PS1_COLOR_BRIGHT_BLUE="\033[38;5;115m"
  PS1_COLOR_RED="\033[0;31m"
  PS1_COLOR_YELLOW="\033[0;33m"
  PS1_COLOR_GREEN="\033[0;32m"
  PS1_COLOR_ORANGE="\033[38;5;202m"
  PS1_COLOR_SILVER="\033[38;5;248m"
  PS1_COLOR_RESET="\033[0m"
  PS1_BOLD="$(tput bold)"
  function ps1_git_color() {
    local git_status
    local branch
    local git_commit
    git_status="$(git status 2>/dev/null)"
    branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
    git_commit="$(git --no-pager diff --stat "origin/${branch}" 2>/dev/null)"
    if [[ $git_status == "" ]]; then
      echo -e "$PS1_COLOR_SILVER"
    elif [[ $git_status =~ "not staged for commit" ]]; then
      echo -e "$PS1_COLOR_RED"
    elif [[ $git_status =~ "Your branch is ahead of" ]]; then
      echo -e "$PS1_COLOR_YELLOW"
    elif [[ $git_status =~ "nothing to commit" ]] && [[ -z $git_commit ]]; then
      echo -e "$PS1_COLOR_GREEN"
    else
      echo -e "$PS1_COLOR_ORANGE"
    fi
  }
  function ps1_git_branch() {
    local git_status
    local on_branch
    local on_commit
    git_status="$(git status 2>/dev/null)"
    on_branch="On branch ([^${IFS}]*)"
    on_commit="HEAD detached at ([^${IFS}]*)"
    if [[ $git_status =~ $on_branch ]]; then
      local branch=${BASH_REMATCH[1]}
      echo " $branch"
    elif [[ $git_status =~ $on_commit ]]; then
      local commit=${BASH_REMATCH[1]}
      echo " $commit"
    else
      echo ""
    fi
  }
  function ps1_python_virtualenv() {
    if [[ -z $VIRTUAL_ENV ]]; then
      echo ""
    else
      echo "($(basename "$VIRTUAL_ENV"))"
    fi
  }
  PS1_DIR="\[$PS1_BOLD\]\[$PS1_COLOR_BRIGHT_BLUE\]\w"
  PS1_GIT="\[\$(ps1_git_color)\]\[$PS1_BOLD\]\$(ps1_git_branch)\[$PS1_BOLD\]\[$PS1_COLOR_RESET\]"
  PS1_VIRTUAL_ENV="\[$PS1_BOLD\]\$(ps1_python_virtualenv)\[$PS1_BOLD\]\[$PS1_COLOR_RESET\]"
  PS1_END="\[$PS1_BOLD\]\[$PS1_COLOR_GREEN\]$ \[$PS1_COLOR_RESET\]"
  PS1="${PS1_DIR} ${PS1_GIT} ${PS1_VIRTUAL_ENV}
${PS1_END}"
fi

if [[ -n "${BASH_VERSION-}" && $- == *i* ]]; then # bash interactive shell
  if [ -e "$HOME/.local/bin/mise" ]; then
    eval "$("$HOME/.local/bin/mise" activate bash)"
  else
    echo 'Mise not installed, please install. See:'
    echo 'https://mise.jdx.dev/getting-started.html'
  fi
fi
