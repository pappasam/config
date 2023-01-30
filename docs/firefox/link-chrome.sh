#!/bin/bash

# Link the chrome directory in this directory to the firefox profile

if [ $# -ne 1 ]; then
  echo 'Usage: link-chrome <path-firefox-profile>'
  return 1
elif [ ! -d "$1" ]; then
  echo "$1 does not appear to be a directory, aborting"
  return 1
else
  ln -s "$PWD/chrome" "$1"
fi
