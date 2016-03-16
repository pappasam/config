#!/bin/bash

if [ -d "~/.emacs.d" ]; then
  cd ~
  mv .emacs.d .emacs.d.bak
  mv .emacs .emacs.bak
fi

git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
