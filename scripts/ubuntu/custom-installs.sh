#!/bin/bash

set -euo pipefail

function echo_bold_italic_underline() {
  echo -e "\e[3m\e[1m\e[4m$1\e[0m"
}

function github_install() {
  local git_remote_url="$1"
  local local_path="$2"
  if [ ! -d "$local_path" ]; then
    echo_bold_italic_underline "Downloading $git_remote_url"
    git clone "$git_remote_url" "$local_path"
  fi
}

github_install https://github.com/zdharma-continuum/zinit.git ~/.local/share/zinit/zinit.git

if ! command -v docker > /dev/null; then
  # See: https://github.com/docker/docker-install
  echo_bold_italic_underline 'Installing docker, follow prompted instructions'
  curl -fsSL https://get.docker.com -o /tmp/get-docker.sh
  sh /tmp/get-docker.sh
  sudo usermod -aG docker "$(whoami)"
fi

if ! command -v rustup > /dev/null; then
  echo_bold_italic_underline 'Installing Rust'
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

if ! command -v ghcup > /dev/null; then
  echo_bold_italic_underline 'Installing ghcup (haskell tooling)'
  curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
fi

# install mise
curl https://mise.run | sh
echo 'now run "mise install"'
