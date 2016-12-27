#!/bin/bash

# installs useful programs on system

set -e

INSTALL="apt-get install -y"

#######################################################################
# Build, version control, and getting code for elsewhere
#######################################################################
$INSTALL git
$INSTALL build-essential
$INSTALL curl

#######################################################################
# Vim
#######################################################################
$INSTALL vim
# vim-plug: the best vim plugin manager as of December 25, 2016
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim curl

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
# Nodejs
#######################################################################
$INSTALL python-software-properties
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
$INSTALL nodejs

#######################################################################
# Bluetooth
#######################################################################
$INSTALL blueman
