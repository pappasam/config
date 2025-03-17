#!/bin/bash
# Environment {{{

# <https://chromium.googlesource.com/chromium/src/+/main/docs/security/apparmor-userns-restrictions.md#option-3_the-safest-way>
export CHROME_DEVEL_SANDBOX=/opt/google/chrome/chrome-sandbox
export ALACRITTY_BACKGROUND_CACHE_FILE="$HOME/.cache/alacritty/background.toml"
export TMUX_CONFIGURE_OPTIONS=--enable-sixel
export ASDF_GOLANG_MOD_VERSION_ENABLED=true
export BROWSER=/usr/bin/firefox
export CARAPACE_BRIDGES=zsh,fish,bash,inshellisense
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
export PROMPT_COMMAND='promptcmd'                                # commands to execute before a bash prompt.
export PYTHON_CONFIGURE_OPTS='--enable-shared'                   # For installing R through ASDF, need shared libraries in Python and R
export R_EXTRA_CONFIGURE_OPTIONS='--enable-R-shlib --with-cairo' # For installing R through ASDF, need shared libraries in Python and R
export SAVEHIST=5000                                             # how many lines of history to save to disk
export VIRTUAL_ENV_DISABLE_PROMPT=1                              # disable python venv prompt so I can configure myself

# shellcheck source=/dev/null
function include() { [[ -f "$1" ]] && source "$1"; }
include "$HOME/.config/sensitive/secrets.sh"
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
path_ladd "$HOME/.local/opt/curl/bin"
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
alias nvim-profiler='nvim --startuptime nvim_startup.txt --cmd "profile start nvim_init_profile.txt" --cmd "profile! file ~/.config/nvim/init.vim"'

# Git
alias g='git status'
alias gd='git diff'
alias gl='git --no-pager branch --verbose --list'
alias gll='git --no-pager branch --verbose --remotes --list'
alias gp='git remote prune origin && git remote set-head origin -a'
alias p='git pull'
alias push='git push -u origin "$(git rev-parse --abbrev-ref HEAD)"'
alias gm='git commit'
alias gmv='git commit --verbose'
alias gma='git add . && git commit'
alias gmav='git add . && git commit --verbose'
alias ghastatus="gh api -H 'Accept: application/vnd.github+json' -H 'X-GitHub-Api-Version: 2022-11-28' /orgs/keplergroup/actions/runners | jq -C '.runners[] | select(.status == \"online\") | {name, busy}'"
alias gop='gh browse'
alias aignore='echo ".aider.*" >> .git/info/exclude'

# Kitten
alias icat="kitten icat"

# Aider
alias aider-kip="aider --no-show-model-warnings --model kip"

# General
alias gn='gio open'
alias pbcopy="perl -pe 'chomp if eof' | xsel --clipboard --input"
alias pbpaste='xsel --clipboard --output'
alias publicip='curl -s checkip.amazonaws.com'
alias m='make'
alias rg='rg --fixed-strings'
alias k3='cd ~/src/KeplerGroup/KIP-3-MVP'

# }}}
# Functions {{{

function c() { cd "$HOME/config/$1" || return; }
function k() { cd "$HOME/src/KeplerGroup/$1" || return; }
function pp() { cd "$HOME/src/pappasam/$1" || return; }
function r() { cd "$HOME/src/KeplerGroup/KIP-Rocket/$1" || return; }
function vplug() { cd "$HOME/.config/nvim/pack/packager/start/$1" || return; }

function _mise_update_pattern() {
  local pattern
  if [[ $# -gt 0 ]]; then
    pattern="$1"
  else
    echo 'usage: mise-update-pattern <pattern>'
    return 1
  fi
  for i in $(mise ls | awk '{ print $1 }' | rg "$pattern"); do
    mise install --force "$i"
  done
}

function mise-update-pipx() {
  _mise_update_pattern 'pipx:'
}

function mise-update-npm() {
  _mise_update_pattern 'npm:'
}

function mise-update-go() {
  _mise_update_pattern 'go:'
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

function gg() {
  if [ ! "$(git rev-parse --is-inside-work-tree 2>/dev/null)" ]; then
    return 1
  fi
  nvim -c 'G' -c 'only'
}

# Git diff: pure diffs
function gdd() {
  if [ ! "$(git rev-parse --is-inside-work-tree 2>/dev/null)" ]; then
    return 1
  fi
  if [ $# -eq 0 ]; then
    if git diff --no-ext-diff --quiet --exit-code; then
      return
    else
      nvim -c 'DiffviewOpen' -c 'tabonly'
    fi
  else
    if git diff "$1" --no-ext-diff --quiet --exit-code; then
      return
    else
      nvim -c "DiffviewOpen $1" -c 'tabonly'
    fi
  fi
}

# Git diff: gh pull request diff
function gdp() {
  if [ ! "$(git rev-parse --is-inside-work-tree 2>/dev/null)" ]; then
    return 1
  fi
  if [[ $# -gt 0 ]]; then
    branch_base="$1"
  else
    branch_base=$(git remote show origin | grep 'HEAD branch' | cut -d ' ' -f 5)
    if [ -z "$branch_base" ]; then
      echo 'Cannot connect to remote repo. Check internet connection...'
      return 2
    fi
  fi
  # GH uses ... diff: https://stackoverflow.com/a/71741156
  nvim -c "DiffviewOpen $branch_base...HEAD" -c 'tabonly'
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

VIRTUAL_ENV_DEFAULT=.venv
function va() {
  local venv_name="$VIRTUAL_ENV_DEFAULT"
  local current_directory="$PWD"
  local actual_venv="${VIRTUAL_ENV:-nopath}"
  while [[ "$current_directory" != "$HOME" && "$current_directory" != "/" ]]; do
    if [[ -d "$current_directory/$venv_name" ]]; then
      # shellcheck source=/dev/null
      if [[ "$actual_venv" == "$current_directory/$venv_name" ]]; then
        return 0
      else
        if command -v deactivate >/dev/null; then
          deactivate
        fi
        # shellcheck source=/dev/null
        source "$current_directory/$venv_name/bin/activate" && return 0
      fi
    fi
    # -e checks if is file OR directory
    if [ -e "$current_directory/.git" ]; then
      break
    fi
    current_directory="$(dirname "$current_directory")"
  done
  if command -v deactivate >/dev/null; then
    deactivate
  fi
}

function promptcmd() { # PROMPT_COMMAND=promptcmd
  auto_venv_precmd
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

# Trace Python calls in current project
# Ignore everything in PYTHONPATH and only show lines from your cwd
function pytrace() {
  # shellcheck disable=SC2046
  python -m trace --trace $(python -c "import sys; print(' '.join(f'--ignore-dir={p}' for p in sys.path if p))") "$1"
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

# }}}
# Installs {{{

function ltex-ls-plus-install() {
  curl -L https://github.com/ltex-plus/ltex-ls-plus/releases/download/18.2.0/ltex-ls-plus-18.2.0-linux-x64.tar.gz >./ltex-ls-plus.tar.gz
  tar -xf ./ltex-ls-plus.tar.gz && rm ./ltex-ls-plus.tar.gz && mv ./ltex-ls-plus-18.2.0 ~/src/lib
}

function rustup-components() {
  rustup component add rust-analyzer rust-src
  rustup component add --toolchain nightly rust-analyzer rust-src
  rustup component add --toolchain stable rust-analyzer rust-src
  rustup component add --toolchain nightly rust-analyzer rust-src
}

function rglobal-install() {
  R -e 'install.packages("languageserver", repos="https://ftp.osuosl.org/pub/cran/")'
  R -e 'install.packages("formatR", repos="https://ftp.osuosl.org/pub/cran/")'
}

function perlglobal-install() {
  cpanm -n App::cpanminus
}

function pydev-install() {
  pip install -U \
    bpython \
    ipython \
    mypy \
    pip \
    wheel
}

function pyglobal-install() {
  pip install --user pipx
  pip install -U argcomplete && pydev-install
}

function nodeglobal-install() {
  npm install -g \
    prettier@latest \
    prettier-plugin-jinja-template@latest \
    prettier-plugin-prisma@latest \
    prettier-plugin-svelte@latest
}

function kitty-install() {
  # https://sw.kovidgoyal.net/kitty/binary/#binary-install
  curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
  ln -sf ~/.local/kitty.app/bin/kitty ~/.local/kitty.app/bin/kitten ~/.local/bin/
  cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
  cp ~/.local/kitty.app/share/applications/kitty-open.desktop ~/.local/share/applications/
  sed -i "s|Icon=kitty|Icon=$(readlink -f ~)/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty*.desktop
  sed -i "s|Exec=kitty|Exec=$(readlink -f ~)/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty*.desktop
  echo 'kitty.desktop' >~/.config/xdg-terminals.list
}

function zoom-install() { sudo apt update && curl -Lsf https://zoom.us/client/latest/zoom_amd64.deb -o /tmp/zoom_amd64.deb && sudo apt install /tmp/zoom_amd64.deb; }

function upgrade() {
  sudo apt update
  sudo apt upgrade -y
  sudo apt autoremove -y
  sudo snap refresh
  rustup update
  mise self-update -y
  mise upgrade -y
  mise install -y
  uv self update
  gh ext install meiji163/gh-notify
  gh ext upgrade meiji163/gh-notify
  kitty-install
}

# }}}
# Mise-en-place {{{

if [[ $- == *i* ]]; then # interactive shell
  if [ -e "$HOME/.local/bin/mise" ]; then
    if [[ "$SHELL" == "/usr/bin/zsh" ]]; then
      eval "$("$HOME/.local/bin/mise" activate zsh)"
      # https://mise.jdx.dev/dev-tools/shims.html#zshrc-bashrc-files
      eval "$(mise hook-env -s zsh)"
    else
      eval "$("$HOME/.local/bin/mise" activate bash)"
    fi
  else
    echo 'Mise not installed, please install. See:'
    echo 'https://mise.jdx.dev/getting-started.html'
  fi
fi

# }}}
