#!/bin/bash
# shellcheck disable=SC1090,SC1091
# Environment {{{

export ASDF_GOLANG_MOD_VERSION_ENABLED=true
export BROWSER='/usr/bin/firefox'
export DELTA_PAGER="less -RF"
export EDITOR=nvim
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
export GDK_SCALE=0 # controls HI-DPI / Non HI_DPI, off because messes up pdf tooling
export HISTCONTROL=ignorespace # ignore leading space, where to save history to disk
export HISTFILE=~/.bash_history
export HISTSIZE=5000 # how many lines of history to keep in memory
export KUBECTL_EXTERNAL_DIFF="colordiff -N -u"
export LD_LIBRARY_PATH="$HOME/src/lib/nccl_2.18.3-1+cuda11.0_x86_64/lib:$LD_LIBRARY_PATH"
export LD_LIBRARY_PATH="/usr/local/cuda-11.7/lib64:$LD_LIBRARY_PATH"
export LESS='--ignore-case --status-column --LONG-PROMPT --RAW-CONTROL-CHARS --HILITE-UNREAD --tabs=4 --quit-if-one-screen --mouse --wheel-lines=3'
export LESS_TERMCAP_mb=$'\E[1;31m'     # begin bold
export LESS_TERMCAP_md=$'\E[1;36m'     # begin blink
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_so=$'\E[01;44;33m' # begin reverse video
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline
export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
export LS_COLORS='di=1;34:fi=0:ln=1;36:pi=5:so=5:bd=5:cd=5:or=31:mi=0:ex=1;92:*.rpm=90'
export MANPAGER='nvim +Man!'
export MANWIDTH=79
export MESA_DEBUG=silent # silence mesa warnings: https://bugzilla.mozilla.org/show_bug.cgi?id=1744389
export PAGER=less
export PROMPT_COMMAND='auto_venv_precmd' # commands to execute before a bash prompt.
export PYTHON_CONFIGURE_OPTS='--enable-shared' # For installing R through ASDF, need shared libraries in Python and R
export R_EXTRA_CONFIGURE_OPTIONS='--enable-R-shlib --with-cairo' # For installing R through ASDF, need shared libraries in Python and R
export SAVEHIST=5000 # how many lines of history to save to disk
export VIRTUAL_ENV_DISABLE_PROMPT=1 # disable python venv prompt so I can configure myself
export WINIT_HIDPI_FACTOR=1.0 # enable editor to scale with monitor's DPI

# PATH
function path_ladd() {
  if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
    PATH="$1${PATH:+":$PATH"}"
  fi
}
function path_radd() {
  if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
    PATH="${PATH:+"$PATH:"}$1"
  fi
}
path_ladd "$HOME/bin"
path_ladd "$HOME/.bin"
path_ladd "$HOME/.local/bin"
path_ladd "$HOME/.opam/default/bin"
path_ladd "$HOME/config/bin"
export PATH

# Script sourcing
function include() {
  [[ -f "$1" ]] && source "$1"
}
include "$HOME/.config/sensitive/secrets.sh"
include "$HOME/.asdf/asdf.sh"
include "$HOME/.ghcup/env"

# PS1: bash prompt
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
  git_status="$(git status 2> /dev/null)"
  branch="$(git rev-parse --abbrev-ref HEAD 2> /dev/null)"
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
PS1_END="\[$PS1_BOLD\]\[$PS1_COLOR_GREEN\]$ \[$PS1_COLOR_RESET\]"
PS1="${PS1_DIR} ${PS1_GIT} ${PS1_VIRTUAL_ENV}
${PS1_END}"

# }}}
# Aliases {{{

# Navigation
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
alias ls='ls -CF --color=auto'
alias sl='ls'
alias ll='ls -al'
alias d='cd'
alias gn='gio open'

# Files
alias f='nvim'
alias v='nvim -c "cd ~/.config/nvim" ~/.config/nvim/init.vim'
alias b='nvim ~/config/dotfiles/.bashrc'

# Copy/paste helpers: perl step removes the final newline from the output
alias pbcopy="perl -pe 'chomp if eof' | xsel --clipboard --input"
alias pbpaste='xsel --clipboard --output'

# Public IP
alias publicip='curl -s checkip.amazonaws.com'

# Git
alias g='git status || return 0'
alias gd='git diff'
alias gg='nvim -c "G | only"'
alias gl='git --no-pager branch --verbose --list'
alias gll='git --no-pager branch --verbose --remotes --list'
alias gm='git commit'
alias gma='git add --all && git commit'
alias gop='gh browse'
alias gp='git remote prune origin && git remote set-head origin -a'

# }}}
# Functions {{{

function deshake-video() {
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

function despace-filename() {
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

function t() {
  if [ -n "$TMUX" ]; then
    echo 'Cannot run t() in tmux session'
    return 1
  elif [[ $# -gt 0 ]]; then
    SESSION="$1"
  else
    SESSION=Main
  fi
  if tmux has-session -t "$SESSION" 2>/dev/null; then
    echo "session '$SESSION' already exists, attach with: tmux -2 attach -t $SESSION"
  else
    tmux -2 new-session -d -s "$SESSION"
    tmux -2 attach -t "$SESSION"
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

# Show which git files have been modified most recently
# Note: %ad means the modified date. I add .. because {} begins with a .
function git-mod() {
  if git branch &>/dev/null
  then
    fd --type f --exec git log -1 --format="/%ad..{}" --date=short {} \
      | tree --fromfile -rC . \
      | less -r
  else
    echo 'Not inside git project'
    return 1
  fi
}

# go to a Neovim plugin
function vplug() {
  cd "$HOME/.config/nvim/pack/packager/start/$1" || return
}

# get profiling information about neovim
function nvim-profiler() {
  nvim --startuptime nvim_startup.txt \
    --cmd 'profile start nvim_init_profile.txt' \
    --cmd 'profile! file ~/.config/nvim/init.vim' \
    "$@"
}

# }}}
# Functions: python {{{

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
  cat << EOF
[tool.black]
line-length = 79

[tool.isort]
profile = "black"
line_length = 79

[tool.mypy]
python_version = "3.11"
check_untyped_defs = true
disallow_untyped_defs = true
no_implicit_optional = true
warn_return_any = true
enable_error_code = [
  "ignore-without-code",
]

[tool.poetry.group.dev.dependencies]
black = "*"
docformatter = "*"
isort = "*"
mypy = "*"
pyright = "*"
ruff = "*"
toml-sort = "*"

[tool.ruff]
line-length = 79
select = ["ALL"]
ignore = ["D203", "D213"]

[tool.ruff.pylint]
max-statements = 20
max-returns = 3
EOF
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
  poetry install
  cat > main.py <<EOL
"""The main module"""

EOL
  git init
  git add .
  git commit -m "Initial commit"
}

# }}}
# Functions: upgrade/install {{{

function rustglobal-install() {
  rustup component add rust-analyzer
  rustup component add rust-src
  cargo install bat
  cargo install cargo-deb
  cargo install cargo-edit
  cargo install cargo-update
  cargo install csvlens
  cargo install fd-find
  cargo install git-delta
  cargo install ripgrep
  cargo install sd
  cargo install stylua --features lua52 --features luau
  asdf reshim rust
  cargo install-update -a
}

function rglobal-install() {
  R -e 'install.packages("languageserver", repos="https://ftp.osuosl.org/pub/cran/")'
  R -e 'install.packages("formatR", repos="https://ftp.osuosl.org/pub/cran/")'
}

function rubyglobal-install() {
  gem install license_finder
  asdf reshim ruby
}

function perlglobal-install() {
  cpanm -n App::cpanminus
  asdf reshim perl
}

function nodeglobal-install() {
  # Temporary removals: npm
  local env=(
    bash-language-server
    dockerfile-language-server-nodejs
    nginx-linter
    nginxbeautifier
    prettier
    prettier-plugin-prisma
    prettier-plugin-svelte
    svelte-language-server
    tree-sitter-cli
    write-good
    yaml-language-server
  )
  # shellcheck disable=SC2128,SC2086
  npm install --no-save -g $env
  asdf reshim nodejs
}

# install default python dependencies
function pydev-install() {
  local for_pip=(
    bpython
    ipython
    mypy
    pip
    pyright
    ruff
    wheel
  )
  # shellcheck disable=SC2128,SC2086
  pip install -U $for_pip
  asdf reshim python
}

# install global Python dependencies
function pyglobal-install() {
  pip install -U pipx
  pydev-install
}

# install global Python applications
function pipx-install() {
  local for_pipx=(
    black
    cookiecutter
    docformatter
    httpie
    isort
    nginx-language-server
    nginxfmt
    pgcli
    poetry
    pre-commit
    restview
    ruff
    toml-sort
  )
  if command -v pipx > /dev/null; then
    # shellcheck disable=SC2128
    for arg in $for_pipx; do
      # We avoid reinstall because it won't install uninstalled pacakges
      pipx uninstall "$arg"
      pipx install "$arg"
    done
    pipx inject poetry poetry-plugin-up
  else
    echo 'pipx not installed. Install with "pip install pipx"'
  fi
}

function goglobal-install() {
  go install github.com/jedib0t/go-wordle@latest
  go install github.com/nishanths/license/v5@latest
  go install github.com/jesseduffield/lazygit@latest
  asdf reshim golang
}

function global-install() {
  goglobal-install
  nodeglobal-install
  perlglobal-install
  pyglobal-install
  pipx-install
  rubyglobal-install
  rustglobal-install
}

function alacritty-install() {
  # Run this 5 times because, when dependencies update, require multiple builds
  cargo build --release
  cargo build --release
  cargo build --release
  cargo build --release
  cargo build --release

  # Install
  sudo cp target/release/alacritty /usr/local/bin # or anywhere else in $PATH
  sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
  sudo desktop-file-install extra/linux/Alacritty.desktop
  sudo update-desktop-database

  # terminfo
  sudo tic -xe alacritty,alacritty-direct extra/alacritty.info

  # man page
  sudo mkdir -p /usr/local/share/man/man1
  sudo mkdir -p /usr/local/share/man/man5
  scdoc < extra/man/alacritty.1.scd | gzip -c | sudo tee /usr/local/share/man/man1/alacritty.1.gz > /dev/null
  scdoc < extra/man/alacritty-msg.1.scd | gzip -c | sudo tee /usr/local/share/man/man1/alacritty-msg.1.gz > /dev/null
  scdoc < extra/man/alacritty.5.scd | gzip -c | sudo tee /usr/local/share/man/man5/alacritty.5.gz > /dev/null
  scdoc < extra/man/alacritty-bindings.5.scd | gzip -c | sudo tee /usr/local/share/man/man5/ala
}

function zoom-install() {
  sudo apt update
  curl -Lsf https://zoom.us/client/latest/zoom_amd64.deb -o /tmp/zoom_amd64.deb
  sudo apt install /tmp/zoom_amd64.deb
}

function asdfl() {  ## Install and set the latest version of asdf
  asdf install "$1" latest && asdf global "$1" latest
}

function asdfpurge() {  ## Purge every version from plugin except current
  if [ $# -ne 1 ]; then
    echo 'Usage: asdfpurge <plugin-name>'
    return 1
  fi
  local plugin_name="$1"
  for plugin_version in $(asdf list "$plugin_name" | grep -v '\*'); do
    echo "Uninstalling $plugin_name==$plugin_version..."
    asdf uninstall "$plugin_name" "$plugin_version"
  done
  echo "Reshiming $plugin_name..."
  asdf reshim "$plugin_name"
}

# upgrade relevant local systems
function upgrade() {
  sudo apt update
  sudo apt upgrade -y
  sudo apt autoremove -y
  asdf update
  asdf plugin-update --all
  pushd .
  cd ~/src/lib/alacritty || return
  git fetch origin
  if [[ $(git diff origin/master) ]]; then
    git merge origin/master
    alacritty-install
  else
    echo 'No Alacritty updates, skipping build...'
  fi
  popd || return
  asdf install neovim latest
  asdf uninstall neovim nightly && \
    asdf install neovim nightly && \
    asdf global neovim nightly
  if command -v zinit > /dev/null; then
    zinit self-update
    zinit update --all
  fi
  nvim -c 'PackagerClean | PackagerUpdate | TSUpdate | CocUpdate' ~/.config/nvim/init.vim
}

# }}}
# Runtime: executed commands for interactive shell {{{

# turn off ctrl-s and ctrl-q from freezing / unfreezing terminal
# Turned off for now, messes with powerlevel10k
# stty -ixon

# Assigns permissions so that only I have read/write access for files, and
# read/write/search for directories I own. All others have read access only
# to my files, and read/search access to my directories.
umask 022

# }}}
