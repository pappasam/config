# !/bin/bash

# After getting ASDF installed, run this script...

###########################################################################
# Custom

asdf plugin-add nodejs
bash ~/.asdf/plugins/nodejs/bin/import-release-team-keyring
asdf install nodejs 14.0.0
asdf global nodejs 14.0.0

###########################################################################
# Generalized

asdf_setup() {
  asdf plugin-add "$1"
  asdf install "$1" "$2"
  asdf global "$1" "$2"
}

asdf_setup golang 1.13.4
asdf_setup java adopt-openjdk-13.0.2+8
asdf_setup neovim nightly
asdf_setup php 7.4.5
asdf_setup python 3.8.2
asdf_setup ruby 2.6.5
asdf_setup rust 1.43.1
asdf_setup tmux 3.1b
asdf_setup yarn 1.19.1
asdf_setup github-cli 0.6.4
