#! /bin/bash

set -euo pipefail

# Check the latest version at <https://github.com/curl/curl/releases>
VERSION=8.12.0
cd ~
sudo apt-get update -y
sudo apt-get install -y nghttp2 libnghttp2-dev libssl-dev build-essential wget
wget https://curl.haxx.se/download/curl-${VERSION}.tar.gz
tar -xzvf curl-${VERSION}.tar.gz
rm -f curl-${VERSION}.tar.gz
cd curl-${VERSION}
./configure --prefix="${HOME}/.local/opt/curl" --with-openssl --with-nghttp2
make -j4
make test
make install
