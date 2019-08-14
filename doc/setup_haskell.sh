#!/bin/bash

# Install stack
curl -sSL https://get.haskellstack.org/ | sh

# Create new stack sandbox project
cd ~/src/sandbox
stack new helloworld new-template
cd helloworld

# Build the basic project
stack build --fast

# Clone haskell-ide-engine repo somewhere (like, in your src/libs)
# Install using instructions here:
# https://github.com/haskell/haskell-ide-engine#install-specific-ghc-version

# Build additional dev dependencies
# Not sure if the below steps are still needed...
cd ~/src/sandbox/helloworld
stack build --copy-compiler-tool hoogle hlint
stack build --copy-compiler-tool exec hoogle generate brittany

# With my current vimrc, the Haskell dev environment should just work
