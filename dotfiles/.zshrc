#!/bin/zsh

# Notes:
#
# Searching for a specific man page
#   1. apropros
#   2. man -k
#
# Clearning "less" search results
#   Alt-u

#######################################################################
# Environment Setup
#######################################################################

# Path Functions {{{

function path_ladd() {
  # Takes 1 argument and adds it to the beginning of the PATH
  if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
    PATH="$1${PATH:+":$PATH"}"
  fi
}

function path_radd() {
  # Takes 1 argument and adds it to the end of the PATH
  if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
    PATH="${PATH:+"$PATH:"}$1"
  fi
}

# }}}
# Exported variable: LS_COLORS {{{

# Colors when using the LS command
# NOTE:
# Color codes:
#   0   Default Colour
#   1   Bold
#   4   Underlined
#   5   Flashing Text
#   7   Reverse Field
#   31  Red
#   32  Green
#   33  Orange
#   34  Blue
#   35  Purple
#   36  Cyan
#   37  Grey
#   40  Black Background
#   41  Red Background
#   42  Green Background
#   43  Orange Background
#   44  Blue Background
#   45  Purple Background
#   46  Cyan Background
#   47  Grey Background
#   90  Dark Grey
#   91  Light Red
#   92  Light Green
#   93  Yellow
#   94  Light Blue
#   95  Light Purple
#   96  Turquoise
#   100 Dark Grey Background
#   101 Light Red Background
#   102 Light Green Background
#   103 Yellow Background
#   104 Light Blue Background
#   105 Light Purple Background
#   106 Turquoise Background
# Parameters
#   di 	Directory
LS_COLORS="di=1;34:"
#   fi 	File
LS_COLORS+="fi=0:"
#   ln 	Symbolic Link
LS_COLORS+="ln=1;36:"
#   pi 	Fifo file
LS_COLORS+="pi=5:"
#   so 	Socket file
LS_COLORS+="so=5:"
#   bd 	Block (buffered) special file
LS_COLORS+="bd=5:"
#   cd 	Character (unbuffered) special file
LS_COLORS+="cd=5:"
#   or 	Symbolic Link pointing to a non-existent file (orphan)
LS_COLORS+="or=31:"
#   mi 	Non-existent file pointed to by a symbolic link (visible with ls -l)
LS_COLORS+="mi=0:"
#   ex 	File which is executable (ie. has 'x' set in permissions).
LS_COLORS+="ex=1;92:"
# additional file types as-defined by their extension
LS_COLORS+="*.rpm=90"

# Finally, export LS_COLORS
export LS_COLORS

# }}}
# Exported variables: General {{{

# React
export REACT_EDITOR='less'

# colored GCC warnings and errors
GCC_COLORS="error=01;31:warning=01;35:note=01;36:caret=01"
GCC_COLORS="$GCC_COLORS;32:locus=01:quote=01"
export GCC_COLORS

# Configure less (de-initialization clears the screen)
# Gives nicely-colored man pages
LESS="--ignore-case --status-column --LONG-PROMPT --RAW-CONTROL-CHARS"
LESS="$LESS --HILITE-UNREAD --tabs=4 --quit-if-one-screen"
export LESS
export LESS_TERMCAP_mb=$'\E[1;31m'     # begin bold
export LESS_TERMCAP_md=$'\E[1;36m'     # begin blink
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\E[01;44;33m' # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline
export PAGER=less

# Configure Man Pager
export MANWIDTH=79
export MANPAGER=less

# Git
export GIT_PAGER=less

# tmuxinator
export EDITOR=/usr/bin/nvim
export SHELL=/usr/bin/zsh

# environment variable controlling difference between HI-DPI / Non HI_DPI
# turn off because it messes up my pdf tooling
export GDK_SCALE=0

# History: How many lines of history to keep in memory
export HISTSIZE=5000

# History: ignore leading space, where to save history to disk
export HISTCONTROL=ignorespace
export HISTFILE=~/.zsh_history

# History: Number of history entries to save to disk
export SAVEHIST=5000

# FZF
export FZF_COMPLETION_TRIGGER=''
export FZF_DEFAULT_OPTS="--bind=ctrl-o:accept --ansi"
FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*"'
export FZF_DEFAULT_COMMAND

# Python virtualenv (disable the prompt so I can configure it myself below)
export VIRTUAL_ENV_DISABLE_PROMPT=1

# Default browser for some programs (eg, urlview)
export BROWSER='/usr/bin/firefox'

# Enable editor to scale with monitor's DPI
export WINIT_HIDPI_FACTOR=1.0

# Bat
export BAT_PAGER=''

# }}}
# Path appends + Misc env setup {{{

RUST_CARGO="$HOME/.cargo/bin"
if [ -d "$RUST_CARGO" ]; then
  path_ladd "$RUST_CARGO"
fi

HOME_BIN="$HOME/bin"
if [ -d "$HOME_BIN" ]; then
  path_ladd "$HOME_BIN"
fi

POETRY_LOC="$HOME/.poetry/bin"
if [ -d "$POETRY_LOC" ]; then
  path_ladd "$POETRY_LOC"
  source $HOME/.poetry/env
fi

OPAM_LOC="$HOME/.opam/default/bin"
if [ -d "$OPAM_LOC" ]; then
  path_ladd "$OPAM_LOC"
fi

# EXPORT THE FINAL, MODIFIED PATH
export PATH

# }}}

#######################################################################
# Interactive session setup
#######################################################################

# Import from other Bash Files {{{

include () {
  [[ -f "$1" ]] && source "$1"
}

include ~/.bash/sensitive

# }}}
# Plugins {{{

if [ -f $HOME/.zplug/init.zsh ]; then
  source $HOME/.zplug/init.zsh

  # BEGIN: List plugins

  # use double quotes: the plugin manager author says we must for some reason
  zplug "paulirish/git-open", as:plugin
  zplug "greymd/docker-zsh-completion", as:plugin
  zplug "zsh-users/zsh-completions", as:plugin
  zplug "zsh-users/zsh-syntax-highlighting", as:plugin
  zplug "junegunn/fzf-bin", \
    from:gh-r, \
    as:command, \
    rename-to:fzf
  zplug "junegunn/fzf", use:"shell/*.zsh", defer:2
  zplug "denysdovhan/spaceship-prompt", \
    use:spaceship.zsh, \
    from:github, \
    as:theme

  #END: List plugins

  # Install plugins if there are plugins that have not been installed
  if ! zplug check --verbose; then
      printf "Install? [y/N]: "
      if read -q; then
          echo; zplug install
      fi
  fi

  # Then, source plugins and add commands to $PATH
  zplug load
else
  echo "zplug not installed, so no plugins available"
fi

# }}}
# ZShell Options {{{

#######################################################################
# Set options
#######################################################################

# enable functions to operate in PS1
setopt PROMPT_SUBST

# list available directories automatically
setopt AUTO_LIST
setopt LIST_AMBIGUOUS
setopt LIST_BEEP

# completions
setopt COMPLETE_ALIASES

# automatically CD without typing cd
setopt AUTOCD

# Dealing with history
setopt HIST_IGNORE_SPACE
setopt APPENDHISTORY
setopt SHAREHISTORY
setopt INCAPPENDHISTORY

#######################################################################
# Unset options
#######################################################################

# do not automatically complete
unsetopt MENU_COMPLETE

# do not automatically remove the slash
unsetopt AUTO_REMOVE_SLASH

#######################################################################
# Expected parameters
#######################################################################
export PERIOD=1
export LISTMAX=0

# }}}
# ZShell Misc Autoloads {{{

# Enables zshell calculator: type with zcalc
autoload -Uz zcalc

# }}}
# ZShell Hook Functions {{{

# NOTE: precmd is defined within the prompt section

# Executed whenever the current working directory is changed
function chpwd() {
  # Magically find Python's virtual environment based on name
  va
}

# Executed every $PERIOD seconds, just before a prompt.
# NOTE: if multiple functions are defined using the array periodic_functions,
# only  one  period  is applied to the complete set of functions, and the
# scheduled time is not reset if the list of functions is altered.
# Hence the set of functions is always called together.
function periodic() {
  # Magically find Python's virtual environment based on name
  va
}

# Executed before each prompt. Note that precommand functions are not
# re-executed simply because the command line is redrawn, as happens, for
# example, when a notification about an exiting job is displayed.
function precmd() {
  # Gather information about the version control system
  vcs_info
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
# ZShell Auto Completion {{{

autoload -U compinit && compinit
autoload -U +X bashcompinit && bashcompinit
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

# Manual libraries

# vault, by Hashicorp
_vault_complete() {
  local word completions
  word="$1"
  completions="$(vault --cmplt "${word}")"
  reply=( "${(ps:\n:)completions}" )
}
compctl -f -K _vault_complete vault

# Add autocompletion path
fpath+=~/.zfunc

# }}}
# ZShell Key-Bindings {{{

# emacs
bindkey -e

# NOTE: about menu-complete
# '^d' - list options without selecting any of them
# '^i' - synonym to TAB; tap twice to get into menu complete
# '^o' - choose selection and execute
# '^m' - choose selection but do NOT execute AND leave all modes in menu-select
#         useful to get out of both select and search-backward
# '^z' - stop interactive tab-complete mode and go back to regular selection

# make vi keys do menu-expansion (eg, ^j does expansion, navigate with hjkl)
bindkey '^j' menu-expand-or-complete
bindkey -M menuselect '^j' menu-complete
bindkey -M menuselect '^k' reverse-menu-complete
bindkey -M menuselect '^h' backward-char
bindkey -M menuselect '^l' forward-char

# delete function characters to include
# Omitted: /=
WORDCHARS='*?_-.[]~&;!#$%^(){}<>'

# }}}
# ASDF: needs to run after ZSH setup {{{

source $HOME/.asdf/asdf.sh
source $HOME/.asdf/completions/asdf.bash

# }}}
# Aliases {{{

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

# Restart Xserver (go to a tty to run, if necessary)
alias restart-xserver='sudo systemctl restart display-manager'

# Vim and Vi
alias f='nvim'
alias vi='nvim'
alias vim='nvim'
alias svim='sudo nvim -u NONE'
alias snvim='sudo nvim -u NONE'
alias vimrc='nvim ~/.config/nvim/init.vim'

# Grep, but ignore annoying directories
alias grep='grep --color=auto'

# enable color support of ls and also add handy aliases
alias ls='ls --color=auto'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'

alias sl='ls'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# diff
# r: recursively; u: shows line number; p: shows difference in C function
# P: if multiple files then showing complete path
alias diff='diff -rupP'

# Set copy/paste helper functions
# the perl step removes the final newline from the output
alias pbcopy="perl -pe 'chomp if eof' | xsel --clipboard --input"
alias pbpaste='xsel --clipboard --output'

# Octave
alias octave='octave --no-gui'

# Public IP
alias publicip='curl -s checkip.amazonaws.com'

# Git
# NOTE: git add --patch forces interactive consideration of all hunks; useful
alias g='git status'
alias gg='nvim -c "G | only"'
alias gl='git --no-pager branch --verbose --all'
alias gm='git commit --verbose'
alias gma='git add --all && git commit --verbose'
alias gp='git remote prune origin'
alias gd='git diff'
alias gdw='git diff --word-diff'

# upgrade
alias upgrade='sudo mintupdate'

# battery
alias battery='upower -i /org/freedesktop/UPower/devices/battery_BAT0| grep -E "state|time\ to\ full|percentage"'

# dynamodb
alias docker-dynamodb="docker run -v /data:$HOME/data -p 8000:8000 dwmkerr/dynamodb -dbPath $HOME/data"

# alias for say
alias say='spd-say'
compdef _dict_words say

# reload zshrc
alias so='source ~/.zshrc'

# Cookiecutter (project boilerplate generator)
alias cookiecutter-hovercraft='cookiecutter gh:pappasam/cookiecutter-hovercraft'

# Rust

# need cargo install cargo-update
# NOTE: CARGO_INCREMENTAL=0 turns off incremental compilation
alias cargo-update='cargo +nightly install-update -a'
alias cargo-doc='cargo doc --open'

# Alacritty helpers
alias alacritty-deb-install='cargo deb --install --manifest-path alacritty/Cargo.toml'

# Python
# Enable things like "pip install 'requests[security]'"
alias pip='noglob pip'
alias poetry-clean='poetry cache:clear --all pypi'
alias p='PYTHONSTARTUP="$(python -m jedi repl)" python'
alias pycache-clean='find . -name "*.pyc" -delete'

# Language-env helpers
alias pyenv-init='eval "$(pyenv init -)"'
alias nodenv-init='eval "$(nodenv init -)"'
alias goenv-init='eval "$(goenv init -)"'
alias rbenv-init='eval "$(rbenv init -)"'

# }}}
# Functions {{{

# Tmux Launch
# NOTE: I use the option "-2" to force Tmux to accept 256 colors. This is
# necessary for proper Vim support in the Linux Console. My Vim colorscheme,
# PaperColor, does a lot of smart translation for Color values between 256 and
# terminal 16 color support, and this translation is lost otherwise.
# Steps (assuming index of 1, which requires tmux config):
# 1. Create session in detached mode
# 2. Select first window
# 3. Rename first window to 'edit'
# 4. Attach to session newly-created session
function t() {
  if [ -n "$TMUX" ]; then
    echo 'Cannot run t() in tmux session'
    return 1
  elif [[ $# > 0 ]]; then
    SESSION=$1
  else
    SESSION=Main
  fi
  HAS_SESSION=$(tmux has-session -t $SESSION 2>/dev/null)
  if [ $HAS_SESSION ]; then
    if [[ "$(alacritty-which-colorscheme)" = 'light' ]]; then
      tmux -2 select-window -t $SESSION:1
      tmux source-file ~/.tmux-light
    fi
    tmux -2 attach -t $SESSION
  else
    tmux -2 new-session -d -s $SESSION
    if [[ "$(alacritty-which-colorscheme)" = 'light' ]]; then
      tmux -2 select-window -t $SESSION:1
      tmux source-file ~/.tmux-light
    fi
    tmux -2 attach -t $SESSION
  fi
}

# Alacritty Helpers
function dark() {
  alacritty-dark
  if [ ! -z "$TMUX" ]; then
    tmux source-file ~/.tmux.conf
  fi
}

function light() {
  alacritty-light
  if [ ! -z "$TMUX" ]; then
    tmux source-file ~/.tmux-light
  fi
}

# Fix window dimensions: tty mode
# Set consolefonts to appropriate size based on monitor resolution
# For each new monitor, you'll need to do this manually
# Console fonts found here: /usr/share/consolefonts
# Finally, suppress all messages from the kernel (and its drivers) except panic
# messages from appearing on the console.
function fix-console-window() {
  echo "Getting window dimensions, waiting 5 seconds..."
  MONITOR_RESOLUTIONS=$(sleep 5 && xrandr -d :0 | grep '*')
  if $(echo $MONITOR_RESOLUTIONS | grep -q "3840x2160"); then
    setfont Uni3-Terminus32x16.psf.gz
  elif $(echo $MONITOR_RESOLUTIONS | grep -q "2560x1440"); then
    setfont Uni3-Terminus24x12.psf.gz
  fi
  echo "Enter sudo password to disable kernel from sending console messages..."
  sudo dmesg -n 1
}

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
compdef _dirs gitzip

# Pipe man stuff to neovim
function m() {
  man --location $@ &> /dev/null
  if [ $? -eq 0 ]; then
    man --pager=cat $@ | nvim -c 'set ft=man' -
  else
    man $@
  fi
}
compdef _man m

# dictionary lookups
function def() {  # arg1: word
  dict -d gcide $1
}
compdef _dict_words def

function syn() {  # arg1: word
  dict -d moby-thesaurus $1
}
compdef _dict_words syn

# I type cd so much, I'll just type d instead
function d() { #arg1: directory
  cd $1
}
compdef _dirs d

# Move up n directories using:  cd.. dir
function cd_up() {  # arg1: number|word
  pushd . >/dev/null
  cd $( pwd | sed -r "s|(.*/$1[^/]*/).*|\1|" ) # cd up into path (if found)
}

# Open files with gnome-open
function gn() {  # arg1: filename
  gio open $1
}

# Open documentation files
export DOC_DIR="$HOME/Documents/reference"
function doc() {  # arg1: filename
  gio open "$DOC_DIR/$1"
}
compdef "_files -W $DOC_DIR" doc

# Cargo local documentation for crates
function cargodoc() {  # arg1: packagename
  if [ $# -eq 0 ]; then
    cargo doc --open
  elif [ $# -eq 1 ]; then
    cargo doc --open --package $1
  else
    echo 'usage: cargodoc [<package name>]'
    return 1
  fi
}

function nodedev-install() {  ## Install default nodejs dependencies
  local env=(\
    javascript-typescript-langserver \
    jsctags \
    npm \
    prettier \
    vscode-html-languageserver-bin \
    write-good \
    yaml-language-server \
  )
  npm install --no-save -g $env
  asdf reshim nodejs
}

# pydev-install: install only env dependencies
# pydev-install dev: install only dev dependencies
# pydev-install all: install all deps
function pydev-install() {  ## Install default python dependencies
  local env=(\
    black \
    isort \
    jedi-language-server \
    pip \
    pylint\
    pynvim \
    restview \
    toml-sort \
  )
  local dev=(\
    mypy \
    pre-commit \
  )
  if [[ "$1" == 'all' ]]; then
    pip install -U $env $dev
  elif [[ "$1" == 'dev' ]]; then
    pip install -U $dev
  else
    pip install -U $env
  fi
  asdf reshim python
}

# activate virtual environment from any directory from current and up
# Name of virtualenv
VIRTUAL_ENV_DEFAULT=.venv
function va() {  # No arguments
  local venv_name="$VIRTUAL_ENV_DEFAULT"
  local old_venv=$VIRTUAL_ENV
  local slashes=${PWD//[^\/]/}
  local current_directory="$PWD"
  for (( n=${#slashes}; n>0; --n ))
  do
    if [ -d "$current_directory/$venv_name" ]; then
      source "$current_directory/$venv_name/bin/activate"
      if [[ "$old_venv" != "$VIRTUAL_ENV" ]]; then
        echo "Activated $(python --version) virtualenv in $VIRTUAL_ENV"
      fi
      return
    fi
    local current_directory="$current_directory/.."
  done
  # If reached this step, no virtual environment found from here to root
  if [[ -z $VIRTUAL_ENV ]]; then
  else
    deactivate
    echo "Disabled existing virtualenv $old_venv"
  fi
}

# Create and activate a virtual environment with all Python dependencies
# installed. Optionally change Python interpreter.
function ve() {  # Optional arg: python interpreter name
  local venv_name="$VIRTUAL_ENV_DEFAULT"
  if [ -z "$1" ]; then
    local python_name='python'
  else
    local python_name="$1"
  fi
  if [ ! -d "$venv_name" ]; then
    $python_name -m venv "$venv_name"
    if [ $? -ne 0 ]; then
      local error_code=$?
      echo "Virtualenv creation failed, aborting"
      return error_code
    fi
    source "$venv_name/bin/activate"
    pip install -U pip
    pydev-install  # install dependencies for editing
    deactivate
  else
    echo "$venv_name already exists, activating"
  fi
  source $venv_name/bin/activate
}
compdef _command ve

# Choose a virtualenv from backed up virtualenvs
# Assumes in current directory, set up with zsh auto completion based on
# current directory.
function vc() {  # Optional arg: python venv version
  if [ -z "$VIRTUAL_ENV" ]; then
    echo "No virtualenv active, skipping backup"
  else
    mkdir -p venv.bak
    local python_version=$(python --version | cut -d ' ' -f 2)
    local bak_dir="venv.bak/$python_version"
    if [ ! -d "$bak_dir" ]; then
      mv "$VIRTUAL_ENV" "$bak_dir"
    else
      echo "ERROR: $bak_dir already exists"
      return 1
    fi
  fi
  if [ -z "$1" ]; then
    return 0
  fi
  local choose_dir="venv.bak/$1"
  if [ ! -d "$choose_dir" ]; then
    echo "ERROR: no such virtualenv $1 backed up"
    return 1
  fi
  mv "$choose_dir" .venv
}
_vc_completion() {
  _directories -W $PWD/venv.bak
}
compdef _vc_completion vc

# Print out the Github-recommended gitignore
export GITIGNORE_DIR=$HOME/src/lib/gitignore
function gitignore() {
  if [ ! -d "$GITIGNORE_DIR" ]; then
    mkdir -p $HOME/src/lib
    git clone https://github.com/github/gitignore $GITIGNORE_DIR
    return 1
  elif [ $# -eq 0 ]; then
    echo "Usage: gitignore <file1> <file2> <file3> <file...n>"
    return 1
  else
    # print all the files
    local count=0
    for filevalue in $@; do
      echo "#################################################################"
      echo "# $filevalue"
      echo "#################################################################"
      cat $GITIGNORE_DIR/$filevalue
      if [ $count -ne $# ]; then
        echo
      fi
      (( count++ ))
    done
  fi
}
compdef "_files -W $GITIGNORE_DIR/" gitignore

# Create instance folder with only .gitignore ignored
function mkinstance() {
  mkdir instance
  cat > instance/.gitignore <<EOL
*
!.gitignore
EOL
}

# Initialize Python Repo
function poetry-init() {
  if [ -f pyproject.toml ]; then
    echo "pyproject.toml exists, aborting"
    return 1
  fi
  poetry init --no-interaction &> /dev/null
  sed -i '1s/^/[tool.black]\nline-length = 79\n\n/' pyproject.toml
  touch README.md
  echo "Python poetry project initialized!"
}

# Create New Python Repo
function pynew() {
  if [ $# -ne 1 ]; then
    echo "pynew <directory>"
    return 1
  fi
  local dir_name="$1"
  if [ -d "$dir_name" ]; then
    echo "$dir_name already exists"
    return 1
  fi
  mkdir "$dir_name"
  cd "$dir_name"
  poetry-init
  gitignore Python.gitignore | grep -v instance/ > .gitignore
  mkinstance
  ve
  cat > main.py <<EOL
#!/usr/bin/env python
"""The main module"""

EOL
  chmod +x main.py
}

# Templates for nvim
function _md_template() {  # arg1: template
  local current_date=$(date +'%Y-%m-%d_%H:%M:%S')
  local calling_func=$funcstack[2]
  local filepath="/tmp/${calling_func}_$current_date.md"
  echo -e $1 > $filepath
  nvim -c 'set nofoldenable' $filepath
}

function clubhouse() {
  _md_template "## Objective\n## Value\n## Acceptance Criteria"
}

function standup() {
  _md_template "*Yesterday:*\n*Today:*\n*Blockers/Reminders:*"
}

# Profiling neovim
function nvim-profiler() {
  nvim --startuptime nvim_startup.txt \
    --cmd 'profile start nvim_init_profile.txt' \
    --cmd 'profile! file ~/.config/nvim/init.vim'
}

# GIT: git-clone keplergrp repos to src/ directory
function klone() {
  git clone git@github.com:KeplerGroup/$1
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

# GIT: prune/cleanup the local references to remote branch and delete merged
# local branches
function gc() {
  local refs="$(git remote prune origin --dry-run)"
  if [ -z "$refs" ]
  then
    echo "No prunable references found"
  else
    echo $refs
    while true; do
     read yn\?"Do you wish to prune these local references to remote branches? "
     case $yn in
       [Yy]* ) break;;
       [Nn]* ) return;;
       * ) echo "Please answer yes or no.";;
     esac
    done
    git remote prune origin
    echo "Pruned!"
  fi
  local branches="$(git branch --merged master | grep -v '^[ *]*master$')"
  if [ -z "$branches" ]
  then
    echo "No merged branches found"
  else
    echo $branches
    while true; do
     read yn\?"Do you wish to delete these merged local branches? "
     case $yn in
       [Yy]* ) break;;
       [Nn]* ) return;;
       * ) echo "Please answer yes or no.";;
     esac
    done
    echo $branches | xargs git branch -d
    echo "Deleted!"
  fi
}

# GITHUB: list all of an organization's Repositories
function github-list {
  local username=$1
  local organization=$2
  local page=$3
  curl -u $username "https://api.github.com/orgs/$organization/repos?per_page=100&page=$page"
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
  local cowsay_word_message="$(shuf -n 1 ~/.gre_words.txt)"
  local cowsay_quote="$(fortune -s ~/.fortunes/ | grep -v '\-\-' | grep .)"
  echo -e "$cowsay_word_message\n\n$cowsay_quote" | cowsay
}

function deshake-video() {
  # see below link for documentation
  # https://github.com/georgmartius/vid.stab
  if [ $# -ne 2 ]; then
    echo "deshake-video <infile> <outfile>"
    exit 1
  fi
  local infile="$1"
  local outfile="$2"
  local transfile="$infile.trf"
  if [ ! -f "$transfile" ]; then
    echo "Generating $transfile ..."
    ffmpeg2 -i "$infile" -vf vidstabdetect=result="$transfile" -f null -
  fi
  ffmpeg2 -i "$infile" -vf \
    vidstabtransform=smoothing=10:input="$transfile" \
    "$outfile"
}

function dat(){
  if [ $# -ne 1 ]; then
    echo "dat <file_name>"
    return 1
  fi
  local file_name="$1"
  strfile -c % "$file_name" "$file_name.dat"
}

# Lint Jenkinsfile
function jenkinsfilelint() {  # [arg1]: path to Jenkinsfile
  if [ $# -eq 0 ]; then
    local jenkinsfile_path='Jenkinsfile'
  elif [ $# -eq 1 ]; then
    local jenkinsfile_path=$1
  else
    echo 'lint-jenkinsfile [<path-to-jenkinsfile>|default is Jenkinsfile]'
    return 1
  fi
  local result=$(curl -s -X POST -F "jenkinsfile=<$jenkinsfile_path" \
    localhost:8080/pipeline-model-converter/validate )
  if [[ $result == 'Jenkinsfile successfully validated.' ]]; then
    echo $result
    return 0
  else
    echo "error processing Jenkinsfile at '$jenkinsfile_path'"
    if [[ $result != '' ]]; then
      echo 'error message:'
      echo $result
    fi
    return 1
  fi
}

# Zoom
function zoomy() {
  if [ -z $1 ]; then
    echo "Conference room number needed! 'zoomy 1234567890'"
  else
    gio open "zoommtg://zoom.us/join?action=join&confno=$1"
  fi
}

# Yaml to JSON
function yamltojson() {
  local pycmd='import sys, yaml, json'
  local pycmd="$pycmd;json.dump(yaml.load(sys.stdin), sys.stdout, indent=2)"
  cat $1 | python -W ignore -c "$pycmd"
}
compdef '_files -g "*.(yml|yaml)"' yamltojson

# }}}
# Compdef Test {{{

# Example from:
# https://mads-hartmann.com/2017/08/06/writing-zsh-completion-scripts.html

function _hello {
  local line

  _arguments -C \
    "-h [Show help information]" \
    "--help[Show help information]" \
    "-v[Print verbose message]" \
    "--verbose[Print verbose message]" \
    "1: :(quietly loudly)" \
    "*::arg:->args"

  case $line[1] in
    loudly)
      _hello_loudly
      ;;
    quietly)
      _hello_quietly
      ;;
  esac
}

function _hello_quietly {
  _arguments "--silent[Dont output anything]"
}

function _hello_loudly {
  _arguments "--yolo=[Do that yolo thang]"
}

function hello() {
  if [[ "$1" = '--help' ]]; then
    echo "There is no help for you here."
  elif [[ "$1" = '--verbose' ]]; then
    echo "There is no verbosity here"
  elif [[ "$1" = 'quietly' ]]; then
    if [[ "$2" = "--silent" ]]; then
      echo "You told me to say it quietly, but I can't!"
    else
      echo "hello"
    fi
  elif [[ "$1" = 'loudly' ]]; then
    if [[ "$2" = "--yolo" ]]; then
      echo "HELLOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO"
    else
      echo "HELLO"
    fi
  else
    echo "Hello"
    return 1
  fi
}
compdef _hello hello


# }}}
# ZShell prompt (PS1) {{{

# https://github.com/denysdovhan/spaceship-prompt/blob/master/docs/Options.md

SPACESHIP_PROMPT_ORDER=(
  user          # Username section
  host          # Hostname section
  dir           # Current directory section
  git           # Git section (git_branch + git_status)
  # hg            # Mercurial section (hg_branch  + hg_status)
  # package       # Package version
  # node          # Node.js section
  # ruby          # Ruby section
  # elixir        # Elixir section
  # xcode         # Xcode section
  # swift         # Swift section
  # golang        # Go section
  # php           # PHP section
  # rust          # Rust section
  # haskell       # Haskell Stack section
  # julia         # Julia section
  # docker        # Docker section
  # aws           # Amazon Web Services section
  venv          # virtualenv section
  # conda         # conda virtualenv section
  # pyenv         # Pyenv section
  # dotnet        # .NET section
  # ember         # Ember.js section
  # kubecontext   # Kubectl context section
  # terraform     # Terraform workspace section
  # exec_time     # Execution time
  line_sep      # Line break
  # battery       # Battery level and status
  # vi_mode       # Vi-mode indicator
  # jobs          # Background jobs indicator
  # exit_code     # Exit code section
  char          # Prompt character
)

SPACESHIP_PROMPT_ADD_NEWLINE=false
SPACESHIP_CHAR_SYMBOL='$ '
SPACESHIP_DIR_PREFIX=
SPACESHIP_DIR_TRUNC=0
SPACESHIP_DIR_TRUNC_REPO=false
SPACESHIP_HOST_COLOR=yellow
SPACESHIP_HOST_PREFIX=@
SPACESHIP_HOST_SHOW=true
SPACESHIP_USER_COLOR=yellow
SPACESHIP_USER_SHOW=true
SPACESHIP_USER_SUFFIX=
SPACESHIP_VENV_PREFIX='('
SPACESHIP_VENV_SUFFIX=')'
SPACESHIP_VENV_GENERIC_NAMES=()
SPACESHIP_CHAR_COLOR_SUCCESS=green
SPACESHIP_CHAR_COLOR_FAILURE=green


# NOTE Below is legacy:
# NOTE this is not cross-shell; zsh-specific

########################################################################
## BEGIN: Git formatting
########################################################################
#autoload -Uz vcs_info
#zstyle ':vcs_info:*' stagedstr '%F{yellow}=%f'
#zstyle ':vcs_info:*' unstagedstr '%F{red}!%f'
#zstyle ':vcs_info:*' check-for-changes true
#zstyle ':vcs_info:*' actionformats \
#  '%F{magenta}[%F{green}%b%F{yellow}|%F{red}%a%F{magenta}]%f '
#zstyle ':vcs_info:*' formats \
#  '%F{magenta}[%F{green}%b%m%F{magenta}] %F{green}%c%F{yellow}%u%f'
#zstyle ':vcs_info:git*+set-message:*' hooks git-untracked git-st git-stash
#zstyle ':vcs_info:*' enable git

## Show untracked files
#untracked_msg="Untracked files:"
#function +vi-git-untracked() {
#  local in_tree=$(git rev-parse --is-inside-work-tree 2> /dev/null)
#  local untracked=$(git status | grep "$untracked_msg")
#  if [[ "$in_tree" == 'true' ]] && [[ "$untracked" == "$untracked_msg" ]]; then
#    hook_com[unstaged]+='%F{red}?%f'
#  fi
#}

## Show remote ref name and number of commits ahead-of or behind
#function +vi-git-st() {
#  local ahead behind remote
#  local -a gitstatus

#  # Are we on a remote-tracking branch?
#  remote=${$(git rev-parse --verify ${hook_com[branch]}@{upstream} \
#    --symbolic-full-name 2>/dev/null)/refs\/remotes\/}

#  if [[ -n ${remote} ]] ; then
#    ahead=$(git rev-list ${hook_com[branch]}@{upstream}..HEAD 2>/dev/null | wc -l)
#    (( $ahead )) && gitstatus+=( "${c3}+${ahead}${c2}" )
#    behind=$(git rev-list HEAD..${hook_com[branch]}@{upstream} 2>/dev/null | wc -l)
#    (( $behind )) && gitstatus+=( "${c4}-${behind}${c2}" )
#    hook_com[branch]="${hook_com[branch]} [@ ${(j:/:)gitstatus}]"
#  fi
#}

## Show count of stashed changes
#function +vi-git-stash() {
#  local -a stashes

#  if [[ -s ${hook_com[base]}/.git/refs/stash ]] ; then
#    stashes=$(git stash list 2>/dev/null | wc -l)
#    hook_com[misc]+=" (stash ${stashes})"
#  fi
#}

########################################################################
## END: Git formatting
########################################################################

## Set Terminal settings
## https://en.wikipedia.org/wiki/ANSI_escape_code#Colors
#COLOR_BRIGHT_BLUE="6"
#COLOR_GOLD="3"
#COLOR_SILVER="7"
#COLOR_PYTHON_GREEN="2"
#COLOR_WHITE="15"
#COLOR_BLACK="0"

## Set Bash PS1
#PS1_DIR="%B%F{$COLOR_BRIGHT_BLUE}%~%f%b"
#PS1_USR="%B%F{$COLOR_GOLD}%n@%M%b%f"
#PS1_END="%B%F{$COLOR_BLACK}$ %f%b"

## Figure out if a Python virtualenv is active
#function virtualenv_info(){
#  if [[ -n "$VIRTUAL_ENV" ]]; then
#    echo "<venv-active>"
#  fi
#}

#PS1="${PS1_DIR} \$vcs_info_msg_0_ %F{$COLOR_PYTHON_GREEN}\$(virtualenv_info)%f \

#${PS1_USR} ${PS1_END}"

# }}}
# FZF {{{

# Use fd to generate the list for file and directory completion
_fzf_compgen_path() {
  fd -c always --hidden --follow --exclude ".git" . "$1"
}

_fzf_compgen_dir() {
  fd -c always --hidden --type d --follow --exclude ".git" . "$1"
}

# <C-t> does fzf; <C-i> does normal stuff; <C-o> does the same thing as enter
bindkey '^T' fzf-completion
bindkey '^R' fzf-history-widget
bindkey '^B' fzf-file-widget
bindkey '^I' $fzf_default_completion

# Widgets:
# fzf-cd-widget
# fzf-completion
# fzf-file-widget
# fzf-history-widget

# }}}
# Executed Commands {{{

if [[ -o interactive ]]; then
  if [[ "$TMUX_PANE" == "%0" ]]; then
    # if you're in the first tmux pane within all of tmux
    quote
  fi

  # turn off ctrl-s and ctrl-q from freezing / unfreezing terminal
  stty -ixon

  # kubectl autocompletion
  if [ $commands[kubectl] ]; then
    source <(kubectl completion zsh)
  fi

  # Try activate virtual environment, don't worry about console output
  va &> /dev/null

fi

# }}}
