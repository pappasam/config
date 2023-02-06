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

github_install https://github.com/asdf-vm/asdf.git ~/.asdf
github_install https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
github_install https://github.com/zdharma-continuum/zinit.git ~/.local/share/zinit/zinit.git

if ! command -v docker > /dev/null; then
  # See: https://github.com/docker/docker-install
  echo_bold_italic_underline 'Installing docker, follow prompted instructions'
  curl -fsSL https://get.docker.com -o /tmp/get-docker.sh
  sh /tmp/get-docker.sh
  sudo usermod -aG docker "$(whoami)"
fi

if ! command -v zoom > /dev/null; then
  echo_bold_italic_underline 'Installing Zoom'
  sudo apt update
  curl -Lsf https://zoom.us/client/latest/zoom_amd64.deb -o /tmp/zoom_amd64.deb
  sudo apt install /tmp/zoom_amd64.deb
fi

if ! command -v slack > /dev/null; then
  echo_bold_italic_underline 'Installing Slack'
  sudo apt update
  SLACK_VERSION=4.27.156
  wget -O /tmp/slack-desktop.deb \
    "https://downloads.slack-edge.com/releases/linux/$SLACK_VERSION/prod/x64/slack-desktop-$SLACK_VERSION-amd64.deb"
  sudo apt install /tmp/slack-desktop.deb
  sudo apt update && sudo apt upgrade slack-desktop
fi

if ! command -v ghcup > /dev/null; then
  echo_bold_italic_underline 'Installing ghcup (haskell tooling)'
  curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
fi

echo_bold_italic_underline 'Installing'

echo_bold_italic_underline 'Done setting up custom software! Now:'
echo_bold_italic_underline '  1. Close your shell (<C-d>)'
echo_bold_italic_underline '  2. Re-open your shell'
echo_bold_italic_underline '  3. run "make setup-asdf"'
