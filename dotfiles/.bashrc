#!/bin/bash
# shellcheck disable=SC1090,SC1091
# Usage: toggle fold in Vim with 'za'. 'zR' to open all folds, 'zM' to close
# Environment: ls_colors {{{

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
# Environment: exported variables {{{

# React
export REACT_EDITOR='less'

# Colored GCC warnings and errors
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

# Set default text editor
export EDITOR=nvim

# Environment variable controlling difference between HI-DPI / Non HI_DPI
# Turn off because it messes up my pdf tooling
export GDK_SCALE=0

# History: How many lines of history to keep in memory
export HISTSIZE=5000

# History: ignore leading space, where to save history to disk
export HISTCONTROL=ignorespace
export HISTFILE=~/.bash_history

# History: Number of history entries to save to disk
export SAVEHIST=5000

# Python virtualenv (disable the prompt so I can configure it myself below)
export VIRTUAL_ENV_DISABLE_PROMPT=1

# Default browser for some programs (eg, urlview)
export BROWSER='/usr/bin/firefox'

# Enable editor to scale with monitor's DPI
export WINIT_HIDPI_FACTOR=1.0

# Bat
export BAT_PAGER=''

# Asdf: to use install-poetry script
export ASDF_POETRY_INSTALL_URL=https://install.python-poetry.org

# Commands to execute before a bash prompt. Kept here for bash compatibility
export PROMPT_COMMAND='auto_venv_precmd'

# }}}
# Environment: path appends + misc env setup {{{

# Takes 1 argument and adds it to the beginning of the PATH
function path_ladd() {
  if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
    PATH="$1${PATH:+":$PATH"}"
  fi
}

# Takes 1 argument and adds it to the end of the PATH
function path_radd() {
  if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
    PATH="${PATH:+"$PATH:"}$1"
  fi
}

HOME_BIN="$HOME/bin"
if [ -d "$HOME_BIN" ]; then
  path_ladd "$HOME_BIN"
fi

HOME_BIN_HIDDEN="$HOME/.bin"
if [ ! -d "$HOME_BIN_HIDDEN" ]; then
  mkdir "$HOME_BIN_HIDDEN"
fi
path_ladd "$HOME_BIN_HIDDEN"

HOME_LOCAL_BIN="$HOME/.local/bin"
if [ ! -d "$HOME_LOCAL_BIN" ]; then
  mkdir -p "$HOME_LOCAL_BIN"
fi
path_ladd "$HOME_LOCAL_BIN"

OPAM_LOC="$HOME/.opam/default/bin"
if [ -d "$OPAM_LOC" ]; then
  path_ladd "$OPAM_LOC"
fi

path_ladd "$HOME/config/bin"

# EXPORT THE FINAL, MODIFIED PATH
export PATH

# }}}
# Imports: script sourcing {{{

function include() {
  [[ -f "$1" ]] && source "$1"
}

include "$HOME/.config/sensitive/secrets.sh"
include "$HOME/.asdf/asdf.sh"

# }}}
# Bash: prompt (PS1) {{{

PS1_COLOR_BRIGHT_BLUE="\033[38;5;115m"
PS1_COLOR_RED="\033[0;31m"
PS1_COLOR_YELLOW="\033[0;33m"
PS1_COLOR_GREEN="\033[0;32m"
PS1_COLOR_ORANGE="\033[38;5;202m"
# PS1_COLOR_GOLD="\033[38;5;142m"
PS1_COLOR_SILVER="\033[38;5;248m"
PS1_COLOR_RESET="\033[0m"
PS1_BOLD="$(tput bold)"

function ps1_git_color() {
  local git_status
  local branch
  local git_commit
  git_status="$(git status 2> /dev/null)"
  branch="$(git rev-parse --abbrev-ref HEAD 2> /dev/null)"
  git_commit="$(git --no-pager diff --stat "origin/${branch}" 2>/dev/null)"
  if [[ $git_status == "" ]]; then
    echo -e "$PS1_COLOR_SILVER"
  elif [[ $git_status =~ "not staged for commit" ]]; then
    echo -e "$PS1_COLOR_RED"
  elif [[ $git_status =~ "Your branch is ahead of" ]]; then
    echo -e "$PS1_COLOR_YELLOW"
  elif [[ $git_status =~ "nothing to commit" ]] && \
      [[ -z $git_commit ]]; then
    echo -e "$PS1_COLOR_GREEN"
  else
    echo -e "$PS1_COLOR_ORANGE"
  fi
}

function ps1_git_branch() {
  local git_status
  local on_branch
  local on_commit
  git_status="$(git status 2> /dev/null)"
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
# PS1_USR="\[$PS1_BOLD\]\[$PS1_COLOR_GOLD\]\u@\h"
PS1_END="\[$PS1_BOLD\]\[$PS1_COLOR_GREEN\]$ \[$PS1_COLOR_RESET\]"
PS1="${PS1_DIR} ${PS1_GIT} ${PS1_VIRTUAL_ENV}\

${PS1_END}"

# }}}
# Aliases: general {{{

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

# Neovim
alias f='nvim'
alias fn='nvim -u NORC --noplugin'
alias v='nvim -c "cd ~/config/dotfiles/.config/nvim" ~/config/dotfiles/.config/nvim/init.vim'
alias b='nvim ~/config/dotfiles/.bashrc'

# ls et al, with color support and handy aliases
alias ls='ls --color=auto'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias sl='ls'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Copy/paste helpers: perl step removes the final newline from the output
alias pbcopy="perl -pe 'chomp if eof' | xsel --clipboard --input"
alias pbpaste='xsel --clipboard --output'

# Public IP
alias publicip='curl -s checkip.amazonaws.com'

# Git shortcuts
alias g='git status'
alias gg='nvim -c "G | only"'
alias gl='git --no-pager branch --verbose --list'
alias gll='git --no-pager branch --verbose --remotes --list'
alias gm='git commit'
alias gma='git add --all && git commit'
alias gp='git remote prune origin && git remote set-head origin -a'
alias gdw='git diff --word-diff'
alias gop='gh browse'

# Battery
alias battery='upower -i /org/freedesktop/UPower/devices/battery_BAT0| grep -E "state|time\ to\ full|percentage"'

# Python: enable things like "pip install 'requests[security]'"
alias pip='noglob pip'

# }}}
# Functions: general {{{

# dictionary definition lookup
function def() {  # arg1: word
  dict -d gcide "$1"
}

# dictionary synonym lookup
function syn() {  # arg1: word
  dict -d moby-thesaurus "$1"
}

# I type cd so much, I'll just type d instead
function d() {
  # shellcheck disable=SC2164,SC2086
  cd "$@"
}

# Move up n directories using:  cd.. dir
function cd_up() {  # arg1: number|word
  pushd . >/dev/null
  cd "$( pwd | sed -r "s|(.*/$1[^/]*/).*|\1|" )" || return  # cd up into path (if found)
}

# Open files with gnome-open
function gn() {  # arg1: filename
  gio open "$1"
}

# Cargo local documentation for crates
function cargodoc() {  # arg1: packagename
  if [ $# -eq 0 ]; then
    cargo doc --open
  elif [ $# -eq 1 ]; then
    cargo doc --open --package "$1"
  else
    echo 'usage: cargodoc [<package name>]'
    return 1
  fi
}

function quote() {
  local cowsay_word_message cowsay_quote
  cowsay_word_message="$(shuf -n 1 ~/config/docs/dict/gre_words.txt)"
  cowsay_quote="$(fortune -s ~/config/docs/fortunes/ | grep -v '\-\-' | grep .)"
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

function dat() {
  if [ $# -ne 1 ]; then
    echo "dat <file_name>"
    return 1
  fi
  local file_name="$1"
  strfile -c % "$file_name" "$file_name.dat"
}

# Remove spaces from a filename.
# Accepts stdin and arguments, preferring arguments if they are given.
function despace() {
  if [ $# -eq 0 ]; then
    while read -r filename; do
      mv "$filename" "$(echo -n "$filename" | tr -s ' ' '_')"
    done
  else
    for filename in "$@"; do
      mv "$filename" "$(echo -n "$filename" | tr -s ' ' '_')"
    done
  fi
}

# }}}
# Functions: alacritty {{{

function dark() {
  alacritty-colorscheme \
    -c "$HOME/config/dotfiles/.config/alacritty/alacritty.yml" \
    -C "$HOME/src/lib/alacritty-theme/themes/" \
    apply 'ayu_dark.yaml'
  if [ -n "$TMUX" ]; then
    tmux source-file ~/.config/tmux/tmux.conf
  fi
}

function light() {
  alacritty-colorscheme \
    -c "$HOME/config/dotfiles/.config/alacritty/alacritty.yml" \
    -C "$HOME/src/lib/alacritty-theme/themes/" \
    apply 'papercolor_light.yaml'
  if [ -n "$TMUX" ]; then
    tmux source-file ~/.config/tmux/tmux-light.conf
  fi
}

# }}}
# Functions: tmux {{{

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
  elif [[ $# -gt 0 ]]; then
    SESSION=$1
  else
    SESSION=Main
  fi
  if tmux has-session -t $SESSION 2>/dev/null; then
    echo "session '$SESSION' already exists, attach with: tmux -2 attach -t $SESSION"
  else
    tmux -2 new-session -d -s $SESSION
    if [[ "$(alacritty-which-colorscheme)" = 'light' ]]; then
      tmux -2 select-window -t $SESSION:1
      tmux source-file ~/.config/tmux/tmux-light.conf
    fi
    tmux -2 attach -t $SESSION
  fi
}

# output colors for tmux
function tmux-colors() {
  for i in {0..255}; do
    # shellcheck disable=2059
    printf "\x1b[38;5;${i}mcolour${i}\x1b[0m\n"
  done
}

# }}}
# Functions: git {{{

# cd to the current git root
function gr() {
  if [ "$(git rev-parse --is-inside-work-tree 2>/dev/null )" ]; then
    cd "$(git rev-parse --show-toplevel)" || return
  else
    echo "'$PWD' is not inside a git repository"
    return 1
  fi
}

# git diff
function gd() {
  if [[ "$(alacritty-which-colorscheme)" = 'light' ]]; then
    git diff "$@" | delta --light --line-numbers
  else
    git diff "$@" | delta --dark  --line-numbers
  fi
}

# checkout origin default, pull, delete old branch, and prune
function gdl() {
  if [ ! "$(git rev-parse --is-inside-work-tree 2>/dev/null )" ]; then
    echo "'$PWD' is not inside a git repository"
    return 1
  fi
  local branch_default
  branch_default=$(git remote show origin | grep 'HEAD branch' | cut -d ' ' -f 5)
  if [ -z "$branch_default" ]; then
    echo "Cannot connect to remote repo. Check internet connection..."
    return 2
  fi
  branch_current=$(git branch --show-current)
  git checkout "$branch_default" && \
    git pull && \
    git branch -d "$branch_current" && \
    git remote prune origin && \
    git remote set-head origin -a
}

# Print out the Github-recommended gitignore
export GITIGNORE_DIR="$HOME/src/lib/gitignore"
function gitignore() {
  if [ ! -d "$GITIGNORE_DIR" ]; then
    mkdir -p "$HOME/src/lib"
    git clone https://github.com/github/gitignore "$GITIGNORE_DIR"
    return 1
  elif [ $# -eq 0 ]; then
    echo "Usage: gitignore <file1> <file2> <file3> <file...n>"
    return 1
  else
    # print all the files
    local count=0
    for filevalue in "$@"; do
      echo "#################################################################"
      echo "# $filevalue"
      echo "#################################################################"
      cat "$GITIGNORE_DIR/$filevalue"
      if [ $count -ne $# ]; then
        echo
      fi
      (( count++ ))
    done
  fi
}

# push current branch from origin to current branch
function push() {
  local current_branch
  current_branch="$(git rev-parse --abbrev-ref HEAD)"
  git push -u origin "$current_branch"
}

# pull current branch from origin to current branch
function pull() {
  local current_branch
  current_branch="$(git rev-parse --abbrev-ref HEAD)"
  git pull origin "$current_branch"
}

# list all of an organization's repositories
function github-list {
  local username=$1
  local organization=$2
  local page=$3
  curl -u "$username" "https://api.github.com/orgs/$organization/repos?per_page=100&page=$page"
}

# }}}
# Functions: vim {{{

# go to a Neovim plugin
function vplug() {
  cd "$HOME/.config/nvim/pack/packager/start/$1" || return
}

# pipe man stuff to neovim
function m() {
  if man --location "$@" &> /dev/null; then
    # shellcheck disable=SC2145
    nvim -c "Man $@" -c "only"
  else
    man "$@"
  fi
}

# get profiling information about neovim
function nvim-profiler() {
  nvim --startuptime nvim_startup.txt \
    --cmd 'profile start nvim_init_profile.txt' \
    --cmd 'profile! file ~/.config/nvim/init.vim' \
    "$@"
}

# }}}
# Functions: python dev {{{

# activate virtual environment from any directory from current and up
VIRTUAL_ENV_DEFAULT=.venv  # Name of virtualenv
function va() {
  local venv_name="$VIRTUAL_ENV_DEFAULT"
  local slashes=${PWD//[^\/]/}
  local current_directory="$PWD"
  for (( n=${#slashes}; n>0; --n )); do
    if [ -d "$current_directory/$venv_name" ]; then
      source "$current_directory/$venv_name/bin/activate"
      return
    fi
    local current_directory="$current_directory/.."
  done
  if command -v deactivate > /dev/null; then
    deactivate
  fi
}

# Toggles whether the virtualenv is automatically set
export AUTO_VIRTUALENV=1  # if not 1, then auto activation of venv disabled
function toggle_auto_virtualenv() {
  if [ "$AUTO_VIRTUALENV" -eq "0" ]; then
    export AUTO_VIRTUALENV=1
  else
    export AUTO_VIRTUALENV=0
  fi
}
function auto_venv_precmd() {
  if [ "$AUTO_VIRTUALENV" -ne "0" ]; then
    va
  fi
}

# Create and activate a virtual environment with all Python dependencies
# installed. Optionally change Python interpreter.
# shellcheck disable=SC2120
function ve() {  # arg1?: python interpreter name
  local venv_name="$VIRTUAL_ENV_DEFAULT"
  if [ -z "$1" ]; then
    local python_name='python'
  else
    local python_name="$1"
  fi
  if [ ! -d "$venv_name" ]; then
    if ! $python_name -m venv "$venv_name"; then
      local error_code=$?
      echo "Virtualenv creation failed, aborting"
      return $error_code
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

function cat-pyproject() {
  echo '[tool.black]'
  echo 'line-length = 79'
  echo ''
  echo '[tool.isort]'
  echo 'profile = "black"'
  echo 'line_length = 79'
}

# initialize python repo
function poetry-init() {
  if [ -f pyproject.toml ]; then
    echo "pyproject.toml exists, aborting"
    return 1
  fi
  poetry init --no-interaction &> /dev/null
  cat-pyproject >> pyproject.toml
  toml-sort --in-place pyproject.toml
  touch README.md
}

# create instance folder with only .gitignore ignored
function mkinstance() {
  mkdir instance
  cat > instance/.gitignore <<EOL
*
!.gitignore
EOL
}

# create new python repo
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
  cd "$dir_name" || return
  poetry-init
  gitignore Python.gitignore | grep -v instance/ > .gitignore
  mkinstance
  ve
  poetry add \
    -D mypy \
    -D pylint \
    -D black \
    -D docformatter \
    -D isort \
    -D toml-sort
  cat > main.py <<EOL
"""The main module"""

EOL
  git init
  git add .
  git commit -m "Initial commit"
}

# }}}
# Functions: upgrade/install {{{

# upgrade relevant local systems
function upgrade() {
  sudo apt update
  sudo apt upgrade -y
  sudo apt autoremove -y
  asdf update
  asdf plugin-update --all
  pushd .
  cd ~/src/lib/alacritty || return
  git pull
  alacritty-install
  popd || return
  asdf uninstall neovim nightly && \
    asdf install neovim nightly && \
    asdf global neovim nightly
  nvim -c 'PackagerClean | PackagerUpdate | CocUpdate'
}

function global-install() {
  goglobal-install
  nodeglobal-install
  perlglobal-install
  pyglobal-install
  rubyglobal-install
  rustglobal-install
}

function rustglobal-install() {
  rustup component add rls
  rustup component add rust-src
  cargo install bat
  cargo install cargo-deb
  cargo install cargo-edit
  cargo install cargo-update
  cargo install fd-find
  cargo install git-delta
  cargo install ripgrep
  cargo install stylua --features lua52 --features luau
  asdf reshim rust
  cargo install-update -a
}

function rubyglobal-install() {
  gem install neovim
  asdf reshim ruby
}

function perlglobal-install() {
  cpanm -n Neovim::Ext
  cpanm -n App::cpanminus
  asdf reshim perl
}

function nodeglobal-install() {
  local env=(
    @angular/cli
    bash-language-server
    devspace
    dockerfile-language-server-nodejs
    firebase-tools
    git+https://github.com/Perlence/tstags.git
    jsctags
    neovim
    nginx-linter
    nginxbeautifier
    npm
    prettier
    prettier-plugin-svelte
    tree-sitter-cli
    write-good
  )
  # shellcheck disable=SC2128,SC2086
  npm install --no-save -g $env
  asdf reshim nodejs
}

# install default python dependencies
function pydev-install() {
  local for_pip=(
    bpython
    mypy
    pip
    pylint
    wheel
  )
  # shellcheck disable=SC2128,SC2086
  pip install -U $for_pip
  asdf reshim python
}

# install global Python applications
function pyglobal-install() {
  pip install -U pipx pynvim neovim-remote
  pydev-install
  asdf reshim python
  local for_pipx=(
    alacritty-colorscheme
    aws-sam-cli
    black
    cookiecutter
    docformatter
    docker-compose
    isort
    jupyterlab
    jupytext
    nginx-language-server
    pre-commit
    restview
    toml-sort
    ueberzug
  )
  if command -v pipx > /dev/null; then
    # shellcheck disable=SC2128
    for arg in $for_pipx; do
      # We avoid reinstall because it won't install uninstalled pacakges
      pipx uninstall "$arg"
      pipx install "$arg"
    done
  else
    echo 'pipx not installed. Install with "pip install pipx"'
  fi
}

function goglobal-install() {
  go install github.com/jedib0t/go-wordle/cmd/go-wordle@latest
  asdf reshim golang
}

function alacritty-install() {
  cargo build --release

  # Install
  sudo cp target/release/alacritty /usr/local/bin # or anywhere else in $PATH
  sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
  sudo desktop-file-install extra/linux/Alacritty.desktop
  sudo update-desktop-database

  # terminfo
  tic -xe alacritty,alacritty-direct extra/alacritty.info

  # man page
  sudo mkdir -p /usr/local/share/man/man1
  gzip -c extra/alacritty.man | \
    sudo tee /usr/local/share/man/man1/alacritty.1.gz > /dev/null
}

function asdfl() {  ## Install and set the latest version of asdf
  asdf install "$1" latest && asdf global "$1" latest
}

# }}}
# Runtime: executed commands for interactive shell {{{

if [[ "$TMUX_PANE" == "%0" ]]; then
  # if you're in the first tmux pane within all of tmux
  quote
elif [ -n "$TMUX" ]; then
  :
elif tmux has-session -t Main 2>/dev/null; then
  :
else
  echo 'Command "t" to enter tmux'
fi

# turn off ctrl-s and ctrl-q from freezing / unfreezing terminal
stty -ixon

# Assigns permissions so that only I have read/write access for files, and
# read/write/search for directories I own. All others have read access only
# to my files, and read/search access to my directories.
umask 022

# }}}
