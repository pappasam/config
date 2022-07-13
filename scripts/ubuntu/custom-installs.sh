#!/bin/bash

set -euxo pipefail

# shellcheck disable=SC01091
source "${BASH_SOURCE%/*}/helpers.sh"

github_install() {
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
