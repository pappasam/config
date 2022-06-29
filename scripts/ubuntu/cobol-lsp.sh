#!/bin/bash

set -e

# from: https://github.com/mattn/vim-lsp-settings

version="0.11.0"
url="https://github.com/eclipse/che-che4z-lsp-for-cobol/releases/download/$version/cobol-language-support-$version.vsix"
filename="cobol-language-support-$version.vsix"
bin_path="$HOME/bin/cobol-language-server"
java_path="$HOME/java/cobol-lsp"
curl -L "$url" -o "$filename"
unzip "$filename"
rm "$filename" \[Content_Types\].xml extension.vsixmanifest
mv extension "$java_path"

cat <<EOF >$bin_path
#!/usr/bin/env bash

java "-Dline.speparator=\r\n" -jar "$java_path/server/lsp-service-cobol-$version.jar" pipeEnabled
EOF

chmod +x "$bin_path"
