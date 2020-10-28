# !/bin/bash

# After getting ASDF installed, run this script...

###########################################################################
# Custom

asdf_setup_nodejs() {
  asdf plugin-add nodejs
  bash ~/.asdf/plugins/nodejs/bin/import-release-team-keyring
  asdf install nodejs "$1"
  asdf global nodejs "$1"
}

asdf_setup_nodejs 14.12.0

###########################################################################
# Generalized

asdf_setup() {
  asdf plugin-add "$1"
  asdf install "$1" "$2"
  asdf global "$1" "$2"
}

asdf_setup direnv 2.22.0
asdf_setup fzf 0.24.0
asdf_setup github-cli 0.9.0
asdf_setup gohugo extended_0.74.3
asdf_setup golang 1.14.4
asdf_setup java adopt-openjdk-13.0.2+8
asdf_setup neovim nightly
asdf_setup php 7.4.7
asdf_setup postgres 13.0
asdf_setup python 3.8.6
asdf_setup ruby 2.6.5
asdf_setup rust 1.43.1
asdf_setup shellcheck 0.7.1
asdf_setup shfmt 3.1.2
asdf_setup sqlite 3.33.0
asdf_setup terraform-lsp 0.0.10
asdf_setup tflint 0.20.2
asdf_setup tfsec 0.27.0
asdf_setup tmux 3.2-rc
asdf_setup yarn 1.22.4

# kubernetes
asdf_setup kubectl 1.19.0-beta.2
asdf_setup minikube 1.11.0
asdf_setup skaffold 1.11.0
