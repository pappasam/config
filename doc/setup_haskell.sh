#!/bin/bash

# Install stack
curl -sSL https://get.haskellstack.org/ | sh

# Create new stack sandbox project
cd ~/src/sandbox
stack new helloworld new-template
cd helloworld

# Build the basic project
# Today, uses GHC 8.4.3 if your resolver is lts-12.13
stack build --fast

# Clone haskell-ide-engine repo somewhere (like, in your src/libs)
cd ~/src/lib
git clone git@github.com:haskell/haskell-ide-engine.git
cd haskell-ide-engine

# Build the project for 8.4.3
sudo apt install libicu-dev libtinfo-dev
stack --stack-yaml=stack-8.4.3.yaml build --copy-compiler-tool cabal-install
stack --stack-yaml=stack-8.4.3.yaml build --copy-compiler-tool

# Build additional dev dependencies
cd ~/src/sandbox/helloworld
stack build --copy-compiler-tool hoogle hlint
stack build --copy-compiler-tool exec hoogle generate brittany

# With my current vimrc, the Haskell dev environment should just work
