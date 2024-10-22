#!/bin/bash

set -euo pipefail

sudo add-apt-repository --yes --no-update ppa:neovim-ppa/unstable

sudo apt update
sudo apt upgrade -y

sudo apt install -y \
  apache2-utils \
  apt-transport-https \
  autoconf \
  automake \
  biber \
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
  groff \
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
  libncurses-dev \
  libncurses6 \
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
  neovim \
  network-manager-openvpn \
  openssl \
  pandoc \
  paprefs \
  patch \
  peek \
  perl \
  php \
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
  texlive-fonts-recommended \
  texlive-lang-english \
  texlive-latex-base \
  texlive-latex-extra \
  texlive-latex-recommended \
  texlive-science \
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
