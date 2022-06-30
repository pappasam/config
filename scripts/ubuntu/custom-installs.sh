#!/bin/bash

source "${BASH_SOURCE%/*}/helpers.sh"

echo_bold_italic_underline 'Downloading https://github.com/asdf-vm/asdf'
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.10.2

echo_bold_italic_underline 'Downloading https://github.com/kristijanhusak/vim-packager'
git clone https://github.com/kristijanhusak/vim-packager \
  ~/.config/nvim/pack/packager/opt/vim-packager

echo_bold_italic_underline 'Downloading https://github.com/zplug/zplug'
curl -sL --proto-redir -all,https \
  https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh

echo_bold_italic_underline 'Dowloading https://github.com/tmux-plugins/tpm'
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

echo_bold_italic_underline 'Downloading https://plantuml.com/'
mkdir -p ~/java
wget -O ~/java/plantuml.jar \
  http://sourceforge.net/projects/plantuml/files/plantuml.jar/download
