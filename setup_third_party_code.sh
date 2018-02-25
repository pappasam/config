#!/bin/bash

# installs useful programs on system
# assumes you are using Linux Mint
# RECOMMENDATION:
#   read document and type these commands yourself
#   especially if you are using one of the latest Linux distributions.
#   Things may have changed on the internet between now and your runtime.

set -e

#######################################################################
# Build, version control, and getting code for elsewhere
#######################################################################
apt install git
apt install build-essential
apt install curl

#######################################################################
# Vim 8
#######################################################################
if [ ! -f /usr/bin/vim ]; then
  apt remove vim
fi
add-apt-repository ppa:jonathonf/vim
apt update
apt install vim vim-nox
# vim-plug: the best vim plugin manager as of December 25, 2016
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim curl

#######################################################################
# NeoVim
#######################################################################
add-apt-repository ppa:neovim-ppa/stable
apt update
apt install neovim
apt install python-dev python-pip python3-dev python3-pip

# when creating a virtual environment, run the following to get autocompletion:
pip3 install --user --upgrade neovim

#######################################################################
# Vim dependencies
#######################################################################
apt install exuberant-ctags

#######################################################################
# Fonts
#######################################################################

# Installs the "Hack" font
apt install fonts-hack-ttf

#######################################################################
# Tmux
#######################################################################
apt install tmux

#######################################################################
# System monitoring
#######################################################################
apt install htop tree

#######################################################################
# Python 3
#######################################################################
apt install python3-dev
apt install python3-virtualenv

# enables pyenv to build with tkinter support
apt install tk-dev

#######################################################################
# MySQL
#######################################################################
apt install libmysqlclient-dev

#######################################################################
# Latex
#######################################################################
apt install texlive-full

#######################################################################
# Nodejs
#######################################################################
apt install python-software-properties
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
apt install nodejs

#######################################################################
# Bluetooth
#######################################################################
apt install blueman

#######################################################################
# Diagramming
#######################################################################
apt install graphviz
apt install gthumb

# graphy-easy
apt install libgraph-easy-perl

#######################################################################
# PDF Viewer with vi bindings
# uses zathura-pdf-mupdf as backend
#######################################################################
add-apt-repository ppa:spvkgn/zathura-mupdf
apt update
apt install mupdf
apt install zathura zathura-pdf-mupdf

#######################################################################
# PDF Viewer with vi bindings
#######################################################################
apt install python-pygments

#######################################################################
# PyEnv
#######################################################################

# dependencies for curses
apt install libncurses5 libncurses5-dev libncursesw5

#######################################################################
# Pandoc
#######################################################################
# the available version in software repository is not latest
# build using the provided debian package under pandoc releases
# https://github.com/jgm/pandoc/releases
