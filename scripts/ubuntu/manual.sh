#!/bin/bash

# Purpose: documents useful programs on system
# Instructions: execute each line individually
# Notes:
#   read document and type these commands yourself especially if you are using
#   one of the latest Linux distributions. Things may have changed on the
#   Internet between now and your runtime.

#######################################################################
# zshell
#######################################################################
chsh -s "$(which zsh)"

#######################################################################
# zplug
#######################################################################
curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh

#######################################################################
# tpm: install from source to get latest version
#######################################################################
git clone git@github.com:tmux-plugins/tpm.git ~/.tmux/plugins/tpm

#######################################################################
# ASDF
#######################################################################
git clone git@github.com:asdf-vm/asdf.git ~/.asdf --branch v0.10.2

#######################################################################
# Less
#######################################################################
# sudo apt remove less
# Download latest recommended version from:
# www.greenwoodsoftware.com/less/download.html
# Follow installation instructions to compile from source

#######################################################################
# vim-packager
#######################################################################
git clone git@github.com:kristijanhusak/vim-packager.git \
  ~/.vim/pack/packager/opt/vim-packager

#######################################################################
# keepass
#######################################################################
# Use: https://keeweb.info/

#######################################################################
# Fonts
#######################################################################

# Download relevant nerd fonts from here
# https://www.nerdfonts.com/font-downloads

# 1.) Download a Nerd Font
# 2.) Unzip and copy to ~/.fonts
# 3.) Run the command fc-cache -fv to manually rebuild the font cache

#######################################################################
# Diagramming
#######################################################################
# apt: gthumb graphviz

# plantuml

mkdir -p ~/java
wget -O ~/java/plantuml.jar \
  http://sourceforge.net/projects/plantuml/files/plantuml.jar/download
cd ~/bin

# ~/bin/plantuml
# #!/bin/bash
# java -jar ~/java/plantuml.jar ${@}

#######################################################################
# Pandoc
#######################################################################
# the available version in software repository is not latest
# build using the provided debian package under pandoc releases
# https://github.com/jgm/pandoc/releases

#######################################################################
# Docker
#######################################################################
# Follow instructions here:
# https://docs.docker.com/engine/install/ubuntu/
