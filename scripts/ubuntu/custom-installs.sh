#!/bin/bash

set -euo pipefail

if ! command -v zinit >/dev/null; then
  echo 'Installing zinit'
  git clone https://github.com/zdharma-continuum/zinit.git ~/.local/share/zinit/zinit.git
fi

if ! command -v docker >/dev/null; then
  # See: https://github.com/docker/docker-install
  echo 'Installing docker, follow prompted instructions'
  curl -fsSL https://get.docker.com -o /tmp/get-docker.sh
  sh /tmp/get-docker.sh
  sudo usermod -aG docker "$(whoami)"
fi

if ! command -v rustup >/dev/null; then
  echo 'Installing Rust'
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

if ! command -v ghcup >/dev/null; then
  echo 'Installing ghcup (haskell tooling)'
  curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
fi

if ! command -v mise >/dev/null; then
  echo 'Installing mise'
  curl https://mise.run | sh
fi
