#!/bin/bash

# Purpose: Install programs using apt, but must manually type
# System: Linux Mint 19.2
#   Run this manually


sudo add-apt-repository -y ppa:git-core/ppa

sudo apt update
sudo apt install git
