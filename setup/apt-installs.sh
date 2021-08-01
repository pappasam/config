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
sudo add-apt-repository -y ppa:git-core/ppa

sudo apt update
sudo apt upgrade -y

# dict-moby-thesaurus : this doesn't appear to be available on ubuntu?

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
  cmus \
  cmus-plugin-ffmpeg \
  cowsay  \
  cpanminus \
  curl \
  dict \
  dict-gcide \
  dict-wn \
  entr \
  expect-dev \
  exuberant-ctags \
  flameshot \
  fortune \
  gettext \
  git \
  gnupg-agent \
  graphicsmagick \
  graphviz \
  gthumb \
  htop \
  imagemagick \
  libbz2-dev \
  libclang-6.0-dev \
  libcurl4-openssl-dev \
  libedit-dev \
  libevent-dev \
  libffi-dev \
  libfreetype6-dev \
  libgd-dev \
  libicu-dev \
  libjpeg-dev \
  libldap2-dev \
  libldb-dev \
  liblzma-dev \
  libmagick++-dev \
  libmapnik-dev \
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
  libsasl2-dev \
  libsqlite3-dev \
  libssl-dev \
  libtool \
  libtool-bin \
  libvips-tools \
  libx11-doc \
  libxcb-xfixes0-dev \
  libxml2-dev \
  libxpm-dev \
  libxslt-dev \
  libyaml-dev \
  libzip-dev \
  llvm \
  make \
  manpages-dev \
  manpages-posix-dev \
  ncurses-doc \
  network-manager-openvpn \
  openssl \
  peek \
  perl \
  pkg-config \
  python-openssl \
  re2c \
  screenkey \
  shellcheck \
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
