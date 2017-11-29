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
#   fi 	File
#   ln 	Symbolic Link
#   pi 	Fifo file
#   so 	Socket file
#   bd 	Block (buffered) special file
#   cd 	Character (unbuffered) special file
#   or 	Symbolic Link pointing to a non-existent file (orphan)
#   mi 	Non-existent file pointed to by a symbolic link (visible with ls -l)
#   ex 	File which is executable (ie. has 'x' set in permissions).
LS_COLORS="di=1;34:"
LS_COLORS+="fi=0:"
LS_COLORS+="ln=1;36:"
LS_COLORS+="pi=5:"
LS_COLORS+="so=5:"
LS_COLORS+="bd=5:"
LS_COLORS+="cd=5:"
LS_COLORS+="or=31:"
LS_COLORS+="mi=0:"
LS_COLORS+="ex=1;92:"
LS_COLORS+="*.rpm=90"
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

# }}}
# Path appends --- {{{

PYENV_ROOT="$HOME/.pyenv"
if [ -d "$PYENV_ROOT" ]
then
  export PYENV_ROOT
  path_radd "$PYENV_ROOT/bin"
  eval "$(pyenv init -)"
fi

NODENV_ROOT="$HOME/.nodenv"
if [ -d "$NODENV_ROOT" ]
then
  export NODENV_ROOT
  path_radd "$NODENV_ROOT/bin"
  eval "$(nodenv init -)"
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
