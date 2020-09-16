# !/bin/bash

# After getting ASDF installed, run this script...

###########################################################################
# Custom

asdf plugin-add nodejs
bash ~/.asdf/plugins/nodejs/bin/import-release-team-keyring
asdf install nodejs 14.4.0
asdf global nodejs 14.4.0

###########################################################################
# Generalized

asdf_setup() {
  asdf plugin-add "$1"
  asdf install "$1" "$2"
  asdf global "$1" "$2"
}

asdf_setup golang 1.14.4
asdf_setup java adopt-openjdk-13.0.2+8
asdf_setup neovim nightly
asdf_setup php 7.4.7
asdf_setup python 3.8.3
asdf_setup ruby 2.6.5
asdf_setup rust 1.43.1
asdf_setup tmux 3.1b
asdf_setup yarn 1.22.4
asdf_setup github-cli 0.9.0
asdf_setup gohugo extended_0.74.3
asdf_setup direnv 2.22.0

# kubernetes
asdf_setup minikube 1.11.0
asdf_setup kubectl 1.19.0-beta.2
asdf_setup skaffold 1.11.0
