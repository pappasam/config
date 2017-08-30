#!/bin/bash

# installs useful programs on system

set -e

INSTALL="apt install -y"
REMOVE="apt remove -y"

#######################################################################
# Build, version control, and getting code for elsewhere
#######################################################################
$INSTALL git
$INSTALL build-essential
$INSTALL curl

#######################################################################
# Vim 8
#######################################################################
if [ ! -f /usr/bin/vim ]; then
  $REMOVE vim
fi
add-apt-repository ppa:jonathonf/vim
apt update
$INSTALL vim vim-nox
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
$INSTALL exuberant-ctags

#######################################################################
# Tmux
#######################################################################
$INSTALL tmux

#######################################################################
# System monitoring
#######################################################################
$INSTALL htop tree

#######################################################################
# Python 3
#######################################################################
$INSTALL python3-dev
$INSTALL python3-virtualenv

#######################################################################
# MySQL
#######################################################################
$INSTALL libmysqlclient-dev

#######################################################################
# Latex
#######################################################################
$INSTALL texlive-full

#######################################################################
# Nodejs
#######################################################################
$INSTALL python-software-properties
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
$INSTALL nodejs

#######################################################################
# Bluetooth
#######################################################################
$INSTALL blueman

#######################################################################
# Diagramming
#######################################################################
$INSTALL graphviz

#######################################################################
# Diagramming
#######################################################################
$INSTALL gthumb

#######################################################################
# PDF Viewer with vi bindings
# uses zathura-pdf-mupdf as backend
#######################################################################
add-apt-repository ppa:spvkgn/zathura-mupdf
apt update
$INSTALL mupdf
$INSTALL zathura zathura-pdf-mupdf

#######################################################################
# PDF Viewer with vi bindings
#######################################################################
$INSTALL python-pygments

#######################################################################
# PyEnv
#######################################################################

# dependencies for curses
apt install libncurses5 libncurses5-dev libncursesw5
