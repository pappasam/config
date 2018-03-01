#!/bin/bash

# Functions --- {{{

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
# Exported variable: LS_COLORS --- {{{

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
# Exported variables: General --- {{{

# React
export REACT_EDITOR='less'

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Configure less (de-initialization clears the screen)
export PAGER=less

# tmuxinator
export EDITOR=vim
export SHELL=bash

# environment variable controlling difference between HI-DPI / Non HI_DPI
# turn off because it messes up my pdf tooling
export GDK_SCALE=0

# Neovim does not change cursor shape if I set the below
# It seems to rely on underlying terminal being xterm-256
# and tmux being screen-256color.
# Weird bug, I'm making this note so I'm aware of it going forward
# export TERM="screen-256color"

# FZF
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*"'

# }}}
# Path appends + Misc env setup --- {{{

PYENV_ROOT="$HOME/.pyenv"
if [ -d "$PYENV_ROOT" ]
then
  export PYENV_ROOT
  path_radd "$PYENV_ROOT/bin"
  eval "$(pyenv init -)"
fi

NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ] && [ ! "$(whence -w __init_nvm)" = function ]; then
  export NVM_DIR
  export __node_commands=("nvm" "node" "npm" "yarn" "gulp" "grunt" "webpack")
  function __init_nvm() {
    # Defer initialization of nvm until nvm, node or a node-dependent command
    # is run. Ensure this block is only run once if .bashrc gets sourced
    # multiple times by checking whether __init_nvm is a function.
    for i in $__node_commands; do
      unalias $i
    done
    \. "$NVM_DIR"/nvm.sh
    unset __node_commands
    unset -f __init_nvm
  }
  for i in $__node_commands; do
    alias $i="__init_nvm && $i"
  done
fi

GOENV_ROOT="$HOME/.goenv"
if [ -d "$GOENV_ROOT" ]
then
  export GOENV_ROOT
  path_radd "$GOENV_ROOT/bin"
  eval "$(goenv init -)"
fi

RUST_CARGO="$HOME/.cargo/bin"
if [ -d "$RUST_CARGO" ]
then
  path_ladd "$RUST_CARGO"
fi

HOME_BIN="$HOME/bin"
if [ -d "$HOME_BIN" ]
then
  path_ladd "$HOME_BIN"
fi

# EXPORT THE FINAL, MODIFIED PATH
export PATH

# }}}
