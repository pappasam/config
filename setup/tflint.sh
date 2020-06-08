#!/bin/bash

DOWNLOAD_FILE="$HOME/Downloads/tflint.zip"

curl -L \
  "$(curl -Ls https://api.github.com/repos/terraform-linters/tflint/releases/latest | grep -o -E "https://.+?_linux_amd64.zip")" \
  -o "$DOWNLOAD_FILE"

unzip -d "$HOME/bin" "$DOWNLOAD_FILE"
