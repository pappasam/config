# Notes:
#
# This file runs for compatible login shells. Keep it fast and use portable
# shell syntax. Interactive, shell-specific configuration belongs in each
# shell's rc file.
#
# WARNING: Values defined here could cause poorly written applications to
# break. For example, an application that assumes the default Python is a
# system python might break when on the latest version from pyenv. I mention
# this to protect myself from any breakages; hopefully I'm wise enough to grep
# my dotfiles for "WARNING"

# Line necessary because I get an error on login on Ubuntu 24.04 without it
export TERM=xterm-256color

if [ -n "${BASH_VERSION-}" ] && [ -r "$HOME/.bashrc" ]; then
  . "$HOME/.bashrc"
fi
