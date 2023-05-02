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
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi
