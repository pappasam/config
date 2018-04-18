#!/bin/bash

git clone https://github.com/nodenv/nodenv.git ~/.nodenv

# optionally compile source
cd ~/.nodenv && src/configure && make -C src

# install node-build as nodenv plugin
git clone https://github.com/nodenv/node-build.git $(nodenv root)/plugins/node-build

# install nodeenv-package-rehash (so I don't need to run rehash manually)
git clone https://github.com/nodenv/nodenv-package-rehash.git "$(nodenv root)"/plugins/nodenv-package-rehash
nodenv package-hooks install --all

# DOCUMENTATION:
# Refer to the github repo installed locally in ~/.nodenv/README.md
