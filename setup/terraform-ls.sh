#!/bin/bash

VERSION="0.7.0"
DOWNLOAD_FILE="$HOME/Downloads/terraform.zip"

curl -o "$DOWNLOAD_FILE" \
  "https://releases.hashicorp.com/terraform-ls/$VERSION/terraform-ls_${VERSION}_linux_amd64.zip"

unzip -d "$HOME/bin" "$DOWNLOAD_FILE"
