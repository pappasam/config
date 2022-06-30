#!/bin/bash

# After getting ASDF installed, run this script...

source "${BASH_SOURCE%/*}/helpers.sh"

asdf_setup() {
  local plugin="$1"
  local version="$2"
  asdf plugin add "$plugin"
  asdf install "$plugin" "$version" && asdf global "$plugin" "$version"
}

echo_bold_italic_underline 'Installing asdf plugins & pulling latest versions.'

asdf_setup act latest
asdf_setup awscli latest
asdf_setup direnv latest
asdf_setup fzf latest
asdf_setup github-cli latest
asdf_setup golang latest
asdf_setup java adopt-openjdk-13.0.2+8
asdf_setup neovim nightly
asdf_setup nodejs latest
asdf_setup perl latest
asdf_setup php latest
asdf_setup poetry latest
asdf_setup postgres 13.0
asdf_setup python latest
asdf_setup ruby latest
asdf_setup rust latest
asdf_setup shellcheck latest
asdf_setup shfmt latest
asdf_setup sqlite latest
asdf_setup terraform latest
asdf_setup terraform-ls latest
asdf_setup tflint latest
asdf_setup tfsec latest
asdf_setup tmux latest
asdf_setup vim latest
asdf_setup yarn latest

# kubernetes
asdf_setup kubectl 1.19.4
asdf_setup minikube 1.15.1
