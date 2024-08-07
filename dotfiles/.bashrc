#!/bin/bash
# Environment {{{

export TMUX_CONFIGURE_OPTIONS='--enable-sixel'
export ASDF_GOLANG_MOD_VERSION_ENABLED=true
export BROWSER='/usr/bin/firefox'
export EDITOR=nvim
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
export GDK_SCALE=0             # controls HI-DPI / Non HI_DPI, off because messes up pdf tooling
export HISTCONTROL=ignorespace # ignore leading space, where to save history to disk
export HISTFILE=~/.bash_history
export HISTSIZE=5000 # how many lines of history to keep in memory
export KUBECTL_EXTERNAL_DIFF="colordiff -N -u"
export LD_LIBRARY_PATH="$HOME/src/lib/nccl_2.18.3-1+cuda11.0_x86_64/lib:$LD_LIBRARY_PATH"
export LD_LIBRARY_PATH="/usr/local/cuda-11.7/lib64:$LD_LIBRARY_PATH"
export LESS='--ignore-case --status-column --LONG-PROMPT --RAW-CONTROL-CHARS --HILITE-UNREAD --tabs=4 --quit-if-one-screen --mouse --wheel-lines=3'
export LS_COLORS='di=1;34:fi=0:ln=1;36:pi=5:so=5:bd=5:cd=5:or=31:mi=0:ex=1;92:*.rpm=90'
export MANPAGER='nvim +Man!'
export MANWIDTH=79
export MESA_DEBUG=silent # silence mesa warnings: https://bugzilla.mozilla.org/show_bug.cgi?id=1744389
export PAGER='less -R'
export PROMPT_COMMAND='auto_venv_precmd'                         # commands to execute before a bash prompt.
export PYTHON_CONFIGURE_OPTS='--enable-shared'                   # For installing R through ASDF, need shared libraries in Python and R
export R_EXTRA_CONFIGURE_OPTIONS='--enable-R-shlib --with-cairo' # For installing R through ASDF, need shared libraries in Python and R
export SAVEHIST=5000                                             # how many lines of history to save to disk
export VIRTUAL_ENV_DISABLE_PROMPT=1                              # disable python venv prompt so I can configure myself

# shellcheck source=/dev/null
function include() { [[ -f "$1" ]] && source "$1"; }
include "$HOME/.config/sensitive/secrets.sh"
include "$HOME/.asdf/asdf.sh"
include "$HOME/.ghcup/env"
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
path_ladd "$HOME/.cargo/bin"
path_ladd "$HOME/bin"
path_ladd "$HOME/.bin"
path_ladd "$HOME/.local/bin"
path_ladd "$HOME/config/bin"
export PATH

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
function ps1_python_virtualenv() { if [[ -z $VIRTUAL_ENV ]]; then echo ""; else echo "($(basename "$VIRTUAL_ENV"))"; fi; }
PS1_DIR="\[$PS1_BOLD\]\[$PS1_COLOR_BRIGHT_BLUE\]\w"
PS1_GIT="\[\$(ps1_git_color)\]\[$PS1_BOLD\]\$(ps1_git_branch)\[$PS1_BOLD\]\[$PS1_COLOR_RESET\]"
PS1_VIRTUAL_ENV="\[$PS1_BOLD\]\$(ps1_python_virtualenv)\[$PS1_BOLD\]\[$PS1_COLOR_RESET\]"
PS1_END="\[$PS1_BOLD\]\[$PS1_COLOR_GREEN\]$ \[$PS1_COLOR_RESET\]"
PS1="${PS1_DIR} ${PS1_GIT} ${PS1_VIRTUAL_ENV}
${PS1_END}"

umask 022 # Default access: files (rw-r--r--) & dirs (rwxr-xr-x) with umask 022

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
alias ls='ls --color=auto'
alias sl='ls'
alias ll='ls -al'
alias d='cd'

# Neovim
alias f='nvim'
alias v='nvim -c "cd ~/.config/nvim" ~/.config/nvim/init.vim'
alias nvim-profiler='nvim --startuptime nvim_startup.txt --cmd "profile start nvim_init_profile.txt" --cmd "profile! file ~/.config/nvim/init.vim"'

# Git
alias g='git status'
alias gg='nvim -c "G | only"'
alias gl='git --no-pager branch --verbose --list'
alias gll='git --no-pager branch --verbose --remotes --list'
alias gp='git remote prune origin && git remote set-head origin -a'
alias push='git push -u origin "$(git rev-parse --abbrev-ref HEAD)"'
alias pull='git pull'
alias gm='git commit'
alias gmv='git commit --verbose'
alias gma='git add . && git commit'
alias gmav='git add . && git commit --verbose'
alias ghastatus="gh api -H 'Accept: application/vnd.github+json' -H 'X-GitHub-Api-Version: 2022-11-28' /orgs/keplergroup/actions/runners | jq -C '.runners[] | select(.status == \"online\") | {name, busy}'"

# General
alias gn='gio open'
alias pbcopy="perl -pe 'chomp if eof' | xsel --clipboard --input"
alias pbpaste='xsel --clipboard --output'
alias publicip='curl -s checkip.amazonaws.com'
alias m='make'
alias rg='rg --fixed-strings'

# }}}
# Functions {{{

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

function gdl() {
  if [ ! "$(git rev-parse --is-inside-work-tree 2>/dev/null)" ]; then
    return 1
  fi
  local branch_default
  if [[ $# -gt 0 ]]; then
    branch_default="$1"
  else
    branch_default=$(git remote show origin | grep 'HEAD branch' | cut -d ' ' -f 5)
    if [ -z "$branch_default" ]; then
      echo 'Cannot connect to remote repo. Check internet connection...' && return 2
    fi
  fi
  branch_current=$(git branch --show-current)
  git checkout "$branch_default" && git pull && git branch -d "$branch_current" && git remote prune origin && git remote set-head origin -a
}

function gop() {
  local giturl
  local return_result
  if [ ! "$(git rev-parse --is-inside-work-tree 2>/dev/null)" ]; then
    return 1
  elif ! giturl=$(gh browse --no-browser "$1"); then
    echo 'Error finding url'
    return 1
  fi
  (nohup firefox --new-window "$giturl" >/dev/null 2>&1 &) >/dev/null 2>&1
  return_result=$?
  if [ $return_result -ne 0 ]; then
    return $return_result
  fi
}

function gd() {
  if [[ "$ALACRITTY_TERM_BACKGROUND" == "light" ]]; then
    git diff "$@" | delta --light
  else
    git diff "$@" | delta --dark
  fi
}

export GITIGNORE_DIR="$HOME/src/lib/gitignore"
function gitignore() {
  if [ ! -d "$GITIGNORE_DIR" ]; then
    mkdir -p "$HOME/src/lib"
    git clone https://github.com/github/gitignore "$GITIGNORE_DIR" && return 1
  elif [ $# -eq 0 ]; then
    echo 'Usage: gitignore <file1> <file2> <file3> <file...n>' && return 1
  else
    # print all the files
    local count=0
    for filevalue in "$@"; do
      echo '#################################################################'
      echo "# $filevalue"
      echo '#################################################################'
      cat "$GITIGNORE_DIR/$filevalue"
      if [ $count -ne $# ]; then
        echo
      fi
      ((count++))
    done
  fi
}

function git-mod() {
  if git branch &>/dev/null; then
    fd --type f --exec git log -1 --format='/%ad..{}' --date=short {} | tree --fromfile -rC . | less -r
  else
    return 1
  fi
}

function vplug() {
  cd "$HOME/.config/nvim/pack/packager/start/$1" || return
}

VIRTUAL_ENV_DEFAULT=.venv
function va() {
  local venv_name="$VIRTUAL_ENV_DEFAULT"
  local slashes=${PWD//[^\/]/}
  local current_directory="$PWD"
  for ((n = ${#slashes}; n > 0; --n)); do
    if [ -d "$current_directory/$venv_name" ]; then
      # shellcheck source=/dev/null
      source "$current_directory/$venv_name/bin/activate" && return
    fi
    local current_directory="$current_directory/.."
  done
  if command -v deactivate >/dev/null; then
    deactivate
  fi
}

export AUTO_VIRTUALENV=1
function auto_venv_precmd() { if [ "$AUTO_VIRTUALENV" -eq '1' ]; then va; fi; }

function poetryinit() {
  if [ -f pyproject.toml ]; then
    echo 'pyproject.toml exists, aborting' && return 1
  fi
  poetry init --no-interaction &>/dev/null
  cat ~/config/docs/samples/base-pyproject.toml >>pyproject.toml
  toml-sort --in-place pyproject.toml
  touch README.md
}

function pyinit() {
  poetryinit || return 1
  gitignore Python.gitignore | grep -v instance/ >.gitignore
  python -m venv .venv && va && poetry install --no-root || return
  cp ~/config/docs/samples/base-main.py ./main.py
  cp ~/config/docs/samples/noxfile.py .
  cp ~/config/docs/samples/Makefile.python ./Makefile
}

function pynew() {
  if [ $# -ne 1 ]; then
    echo 'pynew <directory>' && return 1
  fi
  if [ -d "$1" ]; then
    echo "$1 already exists" && return 1
  fi
  mkdir "$1" && cd "$1" && pyinit || return
  git init && git add . && git commit -m 'Initial commit'
}

function info() { # https://github.com/HiPhish/info.vim
  if [ $# -eq 0 ]; then
    nvim -R -M -c 'Info' +only
    return 0
  elif [ $# -ne 1 ]; then
    echo 'Usage: info <node>. If options are needed, use /bin/info instead'
    return 1
  elif [[ "$1" =~ ^-.* ]]; then
    echo 'Usage: info <node>. If options are needed, use /bin/info instead'
    return 1
  fi
  local node_spaces
  # shellcheck disable=SC2001
  node_spaces="$(echo "$1" | sed 's/%20/ /g')"
  local file
  file=$(/bin/info --where "$node_spaces")
  if [[ "$file" == '' ]]; then
    echo 'Search node not found'
    return 2
  elif [[ "$file" == '*manpages*' ]]; then
    man "$1"
  else
    local infofile
    infofile=$(basename "$file" .info.gz)
    local nodelower
    nodelower=$(echo "$1" | tr '[:upper:]' '[:lower:]')
    if [[ "$infofile" == "$nodelower" ]]; then
      nvim -R -M -c "Info $infofile" +only
    elif [[ "$node_spaces" != "$1" ]]; then
      nvim -R -M -c "Info $infofile" +only
    else
      nvim -R -M -c "Info $infofile $1" +only
    fi
  fi
}

# Change background from current color to new color
function togglebackground() {
  local filename
  filename="$HOME/.config/alacritty/alacritty.toml"
  if ! sed -i --follow-symlinks '1{/^ *# /{s///;b};s/^/# /}' "$filename"; then
    return 1
  fi
  printf "(toggled-"
  if head -n 1 "$filename" | grep -q "^#"; then
    printf "dark) "
  else
    printf "light) "
  fi
  printf "restart alacritty for changes to take effect\n"
}

# }}}
# Installs {{{

function asdfl() { asdf install "$1" latest && asdf global "$1" latest; }

function languageserver-install() {
  npm install --no-save -g \
    @mdx-js/language-server \
    @prisma/language-server \
    bash-language-server \
    dockerfile-language-server-nodejs \
    graphql-language-service-cli \
    svelte-language-server \
    typescript \
    typescript-language-server \
    vim-language-server \
    vscode-langservers-extracted \
    yaml-language-server
  asdfl lua-language-server
  asdfl terraform-ls
  cargo install --features lsp --locked taplo-cli && cargo install-update taplo-cli
  go install golang.org/x/tools/gopls@latest && asdf reshim golang
  local for_pipx=(
    # jedi-language-server
    # nginx-language-server
    pyright
  )
  # shellcheck disable=SC2128
  for arg in $for_pipx; do
    pipx install "$arg"
    pipx upgrade "$arg"
  done
  # Manual installs (download files and bring locally)
  # https://github.com/artempyanykh/marksman/releases
}

function ltex-install() {
  curl -L https://github.com/valentjn/ltex-ls/releases/download/16.0.0/ltex-ls-16.0.0-linux-x64.tar.gz >./ltex.tar.gz
  tar -xf ./ltex.tar.gz && rm ./ltex.tar.gz && mv ./ltex-ls-16.0.0 ~/src/lib
}

function rustup-components() {
  rustup component add rust-analyzer
  rustup component add rust-src
}

function rustglobal-install() {
  rustup-components
  cargo install bat
  cargo install cargo-deb
  cargo install cargo-edit
  cargo install cargo-update
  cargo install csvlens
  cargo install fd-find
  cargo install git-delta
  cargo install leptosfmt
  cargo install mdbook
  cargo install ripgrep
  cargo install sd
  cargo install stylua --features lua52 --features luau
  cargo install --features lsp --locked taplo-cli
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
  npm install --no-save -g \
    @mermaid-js/mermaid-cli \
    nginx-linter \
    nginxbeautifier \
    prettier \
    prettier-plugin-prisma \
    prettier-plugin-svelte \
    tree-sitter-cli \
    write-good
}

function pydev-install() {
  pip install -U \
    bpython \
    ipython \
    mypy \
    pip \
    wheel &&
    asdf reshim python
}

function pyglobal-install() {
  pip install -U \
    argcomplete \
    pipx &&
    pydev-install
}

function pipx-install() {
  local for_pipx=(
    cookiecutter
    httpie
    nginxfmt
    pgcli
    poetry
    pre-commit
    restview
    ruff
    toml-sort
  )
  if command -v pipx >/dev/null; then
    # shellcheck disable=SC2128
    for arg in $for_pipx; do
      # We avoid reinstall because it won't install uninstalled pacakges
      pipx install "$arg"
      pipx upgrade "$arg"
    done
    pipx inject poetry poetry-plugin-up
    pipx inject poetry poetry-plugin-export
  else
    echo 'pipx not installed. Install with "pip install pipx"'
  fi
}

function goglobal-install() {
  go install github.com/google/osv-scanner/cmd/osv-scanner@v1
  go install github.com/jedib0t/go-wordle@latest
  go install github.com/jesseduffield/lazygit@latest
  go install github.com/nishanths/license/v5@latest
  go install mvdan.cc/sh/v3/cmd/shfmt@latest
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
  cargo build --release && cargo build --release && cargo build --release && cargo build --release && cargo build --release # 5 builds required

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
  scdoc <extra/man/alacritty.1.scd | gzip -c | sudo tee /usr/local/share/man/man1/alacritty.1.gz >/dev/null
  scdoc <extra/man/alacritty-msg.1.scd | gzip -c | sudo tee /usr/local/share/man/man1/alacritty-msg.1.gz >/dev/null
  scdoc <extra/man/alacritty.5.scd | gzip -c | sudo tee /usr/local/share/man/man5/alacritty.5.gz >/dev/null
  scdoc <extra/man/alacritty-bindings.5.scd | gzip -c | sudo tee /usr/local/share/man/man5/alacritty-bindings.5.gz >/dev/null
}

function zoom-install() { sudo apt update && curl -Lsf https://zoom.us/client/latest/zoom_amd64.deb -o /tmp/zoom_amd64.deb && sudo apt install /tmp/zoom_amd64.deb; }

function asdfpurge() {
  if [ $# -ne 1 ]; then
    echo 'Usage: asdfpurge <plugin-name>' && return 1
  fi
  local plugin_name="$1"
  for plugin_version in $(asdf list "$plugin_name" | grep -v '\*'); do
    echo "Uninstalling $plugin_name==$plugin_version..."
    asdf uninstall "$plugin_name" "$plugin_version"
  done
  echo "Reshiming $plugin_name..."
  asdf reshim "$plugin_name"
}

function upgrade() {
  sudo apt update
  sudo apt upgrade -y
  sudo apt autoremove -y
  asdf update
  asdf plugin-update --all
  # pin to commit: https://github.com/alacritty/alacritty/commit/a77f77c48fca298caab3a4834b2d7ab1a98cae88
  # don't install alacritty for now, it currently broke unicode
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
  asdf uninstall neovim nightly &&
    asdf install neovim nightly &&
    asdf global neovim nightly
  asdf install github-cli latest && asdf global github-cli latest
  languageserver-install
  nodeglobal-install
  # nvim +PackagerClean +PackagerUpdate ~/.config/nvim/init.vim &&
  #   nvim +TSUpdate ~/.config/nvim/init.vim
}

# }}}
