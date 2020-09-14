#!/bin/bash

VERSION="0.0.11-beta2"
DOWNLOAD_FILE="$HOME/Downloads/terraform-lsp.tar.gz"


wget --output-document="$DOWNLOAD_FILE" \
  "https://github.com/juliosueiras/terraform-lsp/releases/download/v${VERSION}/terraform-lsp_${VERSION}_linux_amd64.tar.gz"

tar -xzf "$DOWNLOAD_FILE" --directory="$HOME/bin"
