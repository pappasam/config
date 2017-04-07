#!/bin/bash

# install dependencies
sudo apt-get install \
  git python-pip make build-essential libssl-dev \
  zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev

# move pyenv into repository
git clone https://github.com/yyuu/pyenv.git ~/.pyenv

# example command to list all available python versions for pyenv
# pyenv global system 3.6.1
