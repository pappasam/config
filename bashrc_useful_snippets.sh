# File contains useful code for ~/.bashrc files

#######################################################################
# Copy and paste using terminal
#######################################################################
alias pbcopy='xsel --clipboard --input'
alias pbpaste='xsel --clipboard --output'

#######################################################################
# Open tmux with proper color schemes enabled
#######################################################################
alias tmux='tmux -2'

#######################################################################
# View public IP address
#######################################################################
alias publicip='wget -qO - http://ipecho.net/plain ; echo'

#######################################################################
# Git aliases
#######################################################################
alias g="git status"

#######################################################################
# Set command to include git branch in my prompt
#######################################################################
COLOR_BRIGHT_GREEN="\033[38;5;10m"
COLOR_BRIGHT_BLUE="\033[38;5;115m"
COLOR_RED="\033[0;31m"
COLOR_YELLOW="\033[0;33m"
COLOR_GREEN="\033[0;32m"
COLOR_PURPLE="\033[1;35m"
COLOR_ORANGE="\033[38;5;202m"
COLOR_BLUE="\033[34;5;115m"
COLOR_WHITE="\033[0;37m"
COLOR_RESET="\033[0m"
BOLD="$(tput bold)"

function git_color {
  local git_status="$(git status 2> /dev/null)"
  local branch="$(git rev-parse --abbrev-ref HEAD 2> /dev/null)"
  local git_commit="$(git --no-pager diff --stat origin/${branch} 2>/dev/null)"
  if [[ ! $git_status =~ "working directory clean" ]]; then
    echo -e $COLOR_RED
  elif [[ $git_status =~ "Your branch is ahead of" ]]; then
    echo -e $COLOR_YELLOW
  elif [[ $git_status =~ "nothing to commit" ]] && \
      [[ ! -n $git_commit ]]; then
    echo -e $COLOR_GREEN
  else
    echo -e $COLOR_ORANGE
  fi
}

function git_branch {
  local git_status="$(git status 2> /dev/null)"
  local on_branch="On branch ([^${IFS}]*)"
  local on_commit="HEAD detached at ([^${IFS}]*)"

  if [[ $git_status =~ $on_branch ]]; then
    local branch=${BASH_REMATCH[1]}
    echo "($branch) "
  elif [[ $git_status =~ $on_commit ]]; then
    local commit=${BASH_REMATCH[1]}
    echo "($commit) "
  fi
}

# Set Bash PS1
PS1_USR="\[$BOLD\]\[$COLOR_BRIGHT_GREEN\]\u@\h"
PS1_DIR="\[$BOLD\]\[$COLOR_BRIGHT_BLUE\] \w "
PS1_GIT="\[\$(git_color)\]\[$BOLD\]\$(git_branch)\[$BOLD\]\[$COLOR_RESET\]"
PS1_END="\[$BOLD\]\[$COLOR_BRIGHT_BLUE\]\

$ \[$COLOR_RESET\]"
PS1="${PS1_USR}${PS1_DIR}${PS1_GIT}${PS1_END}"

#######################################################################
# Move up n directories
# using:  cd.. 10   cd.. dir
#######################################################################
function cd_up() {
  pushd . >/dev/null
  case $1 in
    *[!0-9]*)                                          # if no a number
      cd $( pwd | sed -r "s|(.*/$1[^/]*/).*|\1|" )     # search dir_name in current path, if found - cd to it
      ;;                                               # if not found - not cd
    *)
      cd $(printf "%0.0s../" $(seq 1 $1));             # cd ../../../../  (N dirs)
    ;;
  esac
}
alias 'cd..'='cd_up'                                # can not name function 'cd..'
