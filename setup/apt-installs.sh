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
  bison \
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
  gettext \
  gnupg-agent \
  graphviz \
  gthumb \
  htop \
  libbz2-dev \
  libclang-6.0-dev \
  libcurl4-openssl-dev \
  libedit-dev \
  libevent-dev \
  libffi-dev \
  libicu-dev \
  libjpeg-dev \
  liblzma-dev \
  libmysqlclient-dev \
  libncurses-dev \
  libncurses5 \
  libncurses5-dev \
  libncursesw5 \
  libncursesw5-dev \
  libonig-dev \
  libpng-dev \
  libpq-dev \
  libreadline-dev \
  librsvg2-bin \
  libsqlite3-dev \
  libssl-dev \
  libtool \
  libx11-doc \
  libxcb-xfixes0-dev \
  libxml2-dev \
  libxslt-dev \
  libyaml-dev \
  libzip-dev \
  llvm \
  llvm-6.0 \
  llvm-6.0-dev \
  make \
  manpages-dev \
  manpages-posix-dev \
  ncurses-doc \
  neovim \
  network-manager-openvpn \
  openssl \
  peek \
  pkg-config \
  python-openssl \
  screenkey \
  shellcheck \
  snapd \
  software-properties-common \
  stow \
  texlive-full \
  tk-dev \
  tree \
  typespeed \
  unixodbc-dev \
  unzip \
  wget \
  xclip \
  xsel \
  xz-utils \
  xzdec \
  zathura \
  zlib1g-dev \
  zsh

sudo apt autoclean
sudo apt autoremove
