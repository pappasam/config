#!/bin/bash

# Purpose: Install programs using apt
# System: Linux Mint 19.2
# Instructions: ./manual.sh
# Post-run:
#   Reference "manual.sh" to learn meaning behind package names.
#   Run individual lines in "manual.sh" after running this script.
# Notes:
#   When adding a program here, document its purpose in "manual.sh"

set -e

sudo add-apt-repository -y ppa:peek-developers/stable
sudo add-apt-repository -y ppa:neovim-ppa/unstable

sudo apt update
sudo apt upgrade -y

sudo apt install -y \
  apache2-utils \
  apt-transport-https \
  autoconf \
  automake \
  bsdgames  \
  bsdgames-nonfree \
  build-essential \
  ca-certificates \
  cmake \
  cowsay  \
  curl \
  dict \
  dict-gcide \
  dict-moby-thesaurus \
  entr \
  expect-dev \
  exuberant-ctags \
  flameshot \
  fortune \
  gnupg-agent \
  graphviz \
  gthumb \
  htop \
  libclang-6.0-dev \
  libevent-dev \
  libffi-dev \
  libmysqlclient-dev \
  libncurses-dev \
  libncurses5 \
  libncurses5-dev \
  libncursesw5 \
  libreadline-dev \
  librsvg2-bin \
  libssl-dev \
  libtool \
  libx11-doc \
  libxcb-xfixes0-dev \
  libxslt-dev \
  libyaml-dev \
  llvm-6.0 \
  llvm-6.0-dev \
  manpages-dev \
  manpages-posix-dev \
  ncurses-doc \
  neovim \
  peek \
  pkg-config \
  screenkey \
  shellcheck \
  snapd \
  software-properties-common \
  stow \
  texlive-full \
  tree \
  typespeed \
  unixodbc-dev \
  unzip \
  xclip \
  xsel \
  xzdec \
  zathura \
  zsh

sudo apt autoclean
sudo apt autoremove
