#!/usr/bin/env bash

set -euo pipefail

# Reviewed releases: https://extensions.gnome.org/extension/1485/workspace-matrix/
uuid='wsmatrix@martin.zurowietz.de'
schema=org.gnome.shell.extensions.wsmatrix-settings
keys=org.gnome.shell.extensions.wsmatrix-keybindings
extension_dir="${XDG_DATA_HOME:-$HOME/.local/share}/gnome-shell/extensions/$uuid"
shell_version=$(gnome-shell --version)
case "$shell_version" in
  'GNOME Shell 46.'*) version=50; release_tag=62683 ;;
  'GNOME Shell 48.'*|'GNOME Shell 49.'*|'GNOME Shell 50.'*) version=53; release_tag=69239 ;;
  *) echo "Workspace picker: no pinned release for $shell_version" >&2; exit 1 ;;
esac

installed_version=0
if [[ -f "$extension_dir/metadata.json" ]]; then
  installed_version=$(/usr/bin/python3 - "$extension_dir/metadata.json" <<'PY'
import json, sys
with open(sys.argv[1]) as metadata:
    print(json.load(metadata).get('version', 0))
PY
  )
fi
if ((installed_version < version)); then
  work_dir=$(mktemp -d)
  trap 'rm -rf "$work_dir"' EXIT
  curl -fL --retry 3 \
    "https://extensions.gnome.org/download-extension/$uuid.shell-extension.zip?version_tag=$release_tag" \
    -o "$work_dir/workspace-matrix.zip"
  gnome-extensions install --force "$work_dir/workspace-matrix.zip"
fi

glib-compile-schemas "$extension_dir/schemas"
set_matrix() {
  gsettings --schemadir "$extension_dir/schemas" set "$schema" "$1" "$2"
}

# Preserve the existing four-workspace horizontal navigation and window overview.
set_matrix num-rows 1
set_matrix num-columns 4
set_matrix wraparound-mode none
set_matrix show-overview-grid false
set_matrix show-popup true
set_matrix show-thumbnails true
set_matrix show-workspace-names false
set_matrix multi-monitor false

gsettings set org.gnome.shell.keybindings toggle-overview "['<Control><Alt>j']"
gsettings --schemadir "$extension_dir/schemas" set "$keys" \
  workspace-overview-toggle "['<Control><Alt>k']"
# Choose with arrows and Enter; Escape closes the picker.
gsettings --schemadir "$extension_dir/schemas" set "$keys" \
  workspace-overview-confirm "['Return', 'Escape']"

if gnome-extensions info "$uuid" >/dev/null 2>&1; then
  gnome-extensions enable "$uuid"
else
  echo 'Workspace picker configured. Log out and back in, then run bash scripts/ubuntu/gnome-workspace-picker.sh to enable it.'
fi
