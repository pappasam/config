#!/bin/bash

set -euo pipefail

if test ! -d ~/.local/share/zinit/zinit.git; then
  echo 'INSTALLING: zinit'
  git clone https://github.com/zdharma-continuum/zinit.git ~/.local/share/zinit/zinit.git
fi

if test ! -d ~/.local/share/nvim/site/pack/paqs/start/paq-nvim; then
  git clone --depth=1 https://github.com/savq/paq-nvim.git \
    ~/.local/share/nvim/site/pack/paqs/start/paq-nvim
fi

if ! command -v docker >/dev/null; then
  # See: https://github.com/docker/docker-install
  echo 'INSTALLING: docker, follow prompted instructions'
  curl -fsSL https://get.docker.com -o /tmp/get-docker.sh
  sh /tmp/get-docker.sh
  sudo usermod -aG docker "$(whoami)"
fi

if ! command -v rustup >/dev/null; then
  echo 'INSTALLING: Rust'
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

if ! command -v ghcup >/dev/null; then
  echo 'INSTALLING: ghcup (haskell tooling)'
  curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
fi

if ! command -v mise >/dev/null; then
  echo 'INSTALLING: mise-en-place'
  curl https://mise.run | sh
fi

if ! command -v uv >/dev/null; then
  echo 'INSTALLING: uv'
  curl -LsSf https://astral.sh/uv/install.sh | sh
fi

if ! command -v zoom >/dev/null; then
  echo 'INSTALLING: zoom'
  sudo apt update
  curl -Lsf https://zoom.us/client/latest/zoom_amd64.deb -o /tmp/zoom_amd64.deb
  sudo apt install /tmp/zoom_amd64.deb
fi

if ! command -v carapace >/dev/null; then
  echo 'INSTALLING: carapace'
  LATEST_DEB=$(
    curl -s https://api.github.com/repos/carapace-sh/carapace-bin/releases/latest |
      grep "browser_download_url.*linux_amd64.deb" |
      cut -d '"' -f 4
  )
  if [ -n "$LATEST_DEB" ]; then
    curl -L -o /tmp/carapace-latest.deb "$LATEST_DEB"
    sudo apt install /tmp/carapace-latest.deb
  else
    echo "Error: Could not find linux_arm64.deb in the latest release"
  fi
fi

if ! command -v gh >/dev/null; then
  echo 'INSTALLING: github-cli'
  (type -p wget >/dev/null || (sudo apt update && sudo apt-get install wget -y)) &&
    sudo mkdir -p -m 755 /etc/apt/keyrings &&
    wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg >/dev/null &&
    sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg &&
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null &&
    sudo apt update &&
    sudo apt install gh -y
fi

if ! command -v op >/dev/null; then
  echo 'INSTALLING: 1password cli (op)'
  curl -sS https://downloads.1password.com/linux/keys/1password.asc |
    sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg &&
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/$(dpkg --print-architecture) stable main" |
    sudo tee /etc/apt/sources.list.d/1password.list &&
    sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/ &&
    curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol |
    sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol &&
    sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22 &&
    curl -sS https://downloads.1password.com/linux/keys/1password.asc |
    sudo gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg &&
    sudo apt update && sudo apt install 1password-cli
fi
