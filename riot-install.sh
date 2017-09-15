#!/bin/bash

RELEASE=xenial

echo "deb https://riot.im/packages/debian/ $RELEASE main" | \
  sudo tee /etc/apt/sources.list.d/matrix-riot-im.list; \
  curl -L https://riot.im/packages/debian/repo-key.asc | \
  sudo apt-key add -; sudo apt-get update; sudo apt-get -y install riot-web
