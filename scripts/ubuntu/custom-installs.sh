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
github_install https://github.com/kristijanhusak/vim-packager \
  ~/.config/nvim/pack/packager/opt/vim-packager
github_install https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

echo_bold_italic_underline 'Downloading https://plantuml.com/'
mkdir -p ~/java
wget -O ~/java/plantuml.jar \
  http://sourceforge.net/projects/plantuml/files/plantuml.jar/download

if [ ! -d "$HOME/.zplug" ]; then
  echo_bold_italic_underline 'Downloading https://github.com/zplug/zplug'
  curl -sL --proto-redir -all,https \
    https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | \
    zsh
fi

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

echo_bold_italic_underline 'Done setting up custom software! Now:'
echo_bold_italic_underline '  1. Close your shell (<C-d>)'
echo_bold_italic_underline '  2. Re-open your shell'
echo_bold_italic_underline '  3. run "make setup-asdf"'
