#!/usr/bin/env bash

set -euo pipefail

# Release and settings: https://github.com/G-dH/advanced-alttab-window-switcher
# AATWS 50.1 supports GNOME Shell 45–50 (including Ubuntu 24.04's GNOME 46).
version=50.1
uuid='advanced-alt-tab@G-dH.github.com'
schema=org.gnome.shell.extensions.advanced-alt-tab-window-switcher
extension_dir="${XDG_DATA_HOME:-$HOME/.local/share}/gnome-shell/extensions/$uuid"

if [[ ! -f "$extension_dir/metadata.json" ]]; then
  work_dir=$(mktemp -d)
  trap 'rm -rf "$work_dir"' EXIT
  echo "INSTALLING: AATWS $version"
  curl -fL --retry 3 \
    "https://github.com/G-dH/advanced-alttab-window-switcher/releases/download/v$version/advanced-alt-tab%40G-dH.github.com.zip" \
    -o "$work_dir/aatws.zip"
  gnome-extensions install "$work_dir/aatws.zip"
fi

# User extension schemas are not in the system GSettings search path.
glib-compile-schemas "$extension_dir/schemas"
set_aatws() {
  gsettings --schemadir "$extension_dir/schemas" set "$schema" "$1" "$2"
}

# Filter 2 = current workspace; disable Tab's automatic widening of the filter.
# AATWS still falls back to other workspaces when the current one is empty.
set_aatws win-switcher-popup-filter 2
set_aatws app-switcher-popup-filter 2
set_aatws switcher-popup-second-tab-switch-filter false
set_aatws win-switcher-popup-search-all false

# Preview 2 = full-size preview; position 3 = row at the bottom of the screen.
set_aatws switcher-popup-preview-selected 2
set_aatws switcher-popup-position 3
set_aatws win-switcher-popup-preview-size 128
set_aatws win-switcher-popup-icon-size 48

# Keep the switcher focused on open windows and leave Super for ArcMenu.
set_aatws switcher-popup-start-search false
set_aatws app-switcher-popup-fav-apps false
set_aatws switcher-popup-show-if-no-win false
set_aatws switcher-ws-thumbnails 0
set_aatws enable-super false

# GNOME only discovers extensions installed by the CLI after a Shell restart.
if gnome-extensions info "$uuid" >/dev/null 2>&1; then
  gnome-extensions enable "$uuid"
else
  echo 'AATWS configured. Log out and back in, then rerun make gnome-settings to enable it.'
fi
