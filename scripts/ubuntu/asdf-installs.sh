#!/bin/bash

set -euxo pipefail

# shellcheck disable=SC01091
source "${BASH_SOURCE%/*}/helpers.sh"

if ! command -v asdf; then
  echo_bold_italic_underline 'Please install "asdf" before proceeding...'
  exit 1
else
  echo_bold_italic_underline 'Installing asdf plugins & pulling latest.'
fi

asdf_setup() {
  local plugin="$1"
  local version="$2"
  asdf plugin add "$plugin"
  asdf install "$plugin" "$version" && asdf global "$plugin" "$version"
}

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
asdf_setup kubectl latest
asdf_setup minikube latest
