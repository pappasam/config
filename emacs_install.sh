#!/bin/bash

# Install dependencies
sudo apt-get install build-essential texinfo libx11-dev libxpm-dev libjpeg-dev libpng-dev libgif-dev libtiff-dev libgtk2.0-dev libncurses-dev checkinstall

# Install emacs
if [ ! -d "~/emacs-24.5" ]; then
  mkdir -p ~/src
  cd ~/src
  wget http://ftp.gnu.org/gnu/emacs/emacs-24.5.tar.gz
  tar xf emacs-24.5.tar.gz
  cd emacs-24.5
  ./configure
  make
  sudo checkinstall
fi

if [ -d "~/.emacs.d" ]; then
  cd ~
  mv .emacs.d .emacs.d.bak
  mv .emacs .emacs.bak
fi

git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
