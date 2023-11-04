#!/bin/bash

set -euo pipefail

function echo_bold_italic_underline() {
  echo -e "\e[3m\e[1m\e[4m$1\e[0m"
}

if ! command -v asdf > /dev/null; then
  echo_bold_italic_underline 'Please install "asdf" before proceeding...'
  exit 1
else
  echo_bold_italic_underline 'Installing asdf plugins & pulling latest.'
  asdf_plugins=$(asdf plugin list)
fi

asdf_setup() {
  local plugin="$1"
  local version="$2"
  if ! echo "$asdf_plugins" | grep "$plugin"; then
    asdf plugin add "$plugin"
  fi
  asdf install "$plugin" "$version" && asdf global "$plugin" "$version"
}

asdf_setup act latest
asdf_setup awscli latest
asdf_setup direnv latest
asdf_setup fzf latest
asdf_setup github-cli latest
asdf_setup golang latest
asdf_setup java adopt-openjdk-13.0.2+8
asdf_setup lua-language-server latest
asdf_setup neovim nightly
asdf_setup nodejs latest
asdf_setup perl latest
asdf_setup php latest
asdf_setup R latest
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
asdf_setup kubectl latest
asdf_setup k9s 0.26.7
asdf_setup minikube latest

echo_bold_italic_underline 'Done installing tools with asdf! To install tools in your asdf-managed tools, run:'
echo_bold_italic_underline '$ global-install'
