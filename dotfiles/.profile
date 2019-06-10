# Notes:
#
# This file runs on login. Commands that run here will be available for all
# shells. Only use simple shell syntax lest you incur the wrath of unwelcoming
# parsers. Put long running commands here that I want to be available for all
# of my shells.
#
# WARNING: Values defined here could cause poorly written applications to
# break. For example, an application that assumes the default Python is a
# system python might break when on the latest version from pyenv. I mention
# this to protect myself from any breakages; hopefully I'm wise enough to grep
# my dotfiles for "WARNING"

# Functions {{{

path_ladd() {
  # Takes 1 argument and adds it to the beginning of the PATH
  if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
    PATH="$1${PATH:+":$PATH"}"
  fi
}

path_radd() {
  # Takes 1 argument and adds it to the end of the PATH
  if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
    PATH="${PATH:+"$PATH:"}$1"
  fi
}

# }}}
# Path appends + Misc env setup {{{

PYENV_ROOT="$HOME/.pyenv"
if [ -d "$PYENV_ROOT" ]; then
  export PYENV_ROOT
  path_radd "$PYENV_ROOT/bin"
  eval "$(pyenv init -)"
  if [ -d "$PYENV_ROOT/plugins/pyenv-virtualenv" ]; then
    eval "$(pyenv virtualenv-init -)"
  fi
fi

SDKMAN_DIR="$HOME/.sdkman"
if [ -d "$SDKMAN_DIR" ]; then
  export SDKMAN_DIR
  [[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && \
    source "$SDKMAN_DIR/bin/sdkman-init.sh"
fi

NODENV_ROOT="$HOME/.nodenv"
if [ -d "$NODENV_ROOT" ]; then
  export NODENV_ROOT
  path_radd "$NODENV_ROOT/bin"
  eval "$(nodenv init -)"
fi

GOENV_ROOT="$HOME/.goenv"
if [ -d "$GOENV_ROOT" ]; then
  export GOENV_ROOT
  path_radd "$GOENV_ROOT/bin"
  eval "$(goenv init -)"
fi

RBENV_ROOT="$HOME/.rbenv"
if [ -d "$RBENV_ROOT" ]; then
  export RBENV_ROOT
  path_radd "$RBENV_ROOT/bin"
  eval "$(rbenv init -)"
fi

TFENV_ROOT="$HOME/.tfenv"
if [ -d "$TFENV_ROOT" ]; then
  export TFENV_ROOT
  path_radd "$TFENV_ROOT/bin"
fi

GOPATH="$HOME/go"
if [ -d "$GOPATH" ]; then
  export GOPATH
  path_ladd "$GOPATH/bin"
fi

RUST_CARGO="$HOME/.cargo/bin"
if [ -d "$RUST_CARGO" ]; then
  path_ladd "$RUST_CARGO"
fi

HOME_BIN="$HOME/bin"
if [ -d "$HOME_BIN" ]; then
  path_ladd "$HOME_BIN"
fi

STACK_LOC="$HOME/.local/bin"
if [ -d "$STACK_LOC" ]; then
  path_ladd "$STACK_LOC"
fi

POETRY_LOC="$HOME/.poetry/bin"
if [ -d "$POETRY_LOC" ]; then
  path_ladd "$POETRY_LOC"
  source $HOME/.poetry/env
fi

# EXPORT THE FINAL, MODIFIED PATH
export PATH

# }}}
