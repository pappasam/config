#!/bin/bash

set -euo pipefail

function echo_bold_italic_underline() {
  echo -e "\e[3m\e[1m\e[4m$1\e[0m"
}

echo_bold_italic_underline 'Installing system dependencies with "apt install"'

sudo apt update
sudo apt upgrade -y

sudo apt install -y \
  apache2-utils \
  apt-transport-https \
  autoconf \
  automake \
  bison \
  bsdgames \
  bsdgames-nonfree \
  build-essential \
  ca-certificates \
  cmake \
  cmatrix \
  cmus \
  cmus-plugin-ffmpeg \
  colordiff \
  cowsay \
  cpanminus \
  curl \
  dict \
  dict-gcide \
  dict-wn \
  enscript \
  entr \
  expect \
  exuberant-ctags \
  flameshot \
  fortune-mod \
  fswatch \
  gettext \
  gfortran \
  gfortran-11 \
  gfortran-12 \
  git \
  gnupg-agent \
  graphicsmagick \
  graphviz \
  gthumb \
  htop \
  imagemagick \
  inkscape \
  less \
  libbz2-dev \
  libclang-14-dev \
  libcurl4-openssl-dev \
  libdb-dev \
  libedit-dev \
  libevent-dev \
  libffi-dev \
  libfreetype-dev \
  libgd-dev \
  libgdbm-dev \
  libgdbm6t64 \
  libgmp-dev \
  libgraphviz-dev \
  libicu-dev \
  libjpeg-dev \
  libldap2-dev \
  libldb-dev \
  liblzma-dev \
  libmagick++-dev \
  libmapnik-dev \
  libmysqlclient-dev \
  libncurses-dev \
  libncurses6 \
  libncurses-dev \
  libncursesw6 \
  libonig-dev \
  libpng-dev \
  libpq-dev \
  libreadline-dev \
  libreadline6-dev \
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
  libxslt1-dev \
  libyaml-dev \
  libzip-dev \
  llvm \
  make \
  manpages-dev \
  manpages-posix-dev \
  ncurses-doc \
  network-manager-openvpn \
  openssl \
  paprefs \
  patch \
  peek \
  perl \
  pkg-config \
  pulseaudio-module-gsettings \
  pulseaudio-module-raop \
  python3-openssl \
  qpdf \
  re2c \
  rustc \
  scdoc \
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
  uuid-dev \
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

echo_bold_italic_underline 'Done installing system tools!'
