#!/usr/bin/env bash

set -euo pipefail

# Reviewed GNOME Extensions releases: Dash to Panel 74 and ArcMenu 70.0.
# https://extensions.gnome.org/extension/1160/dash-to-panel/
# https://extensions.gnome.org/extension/3628/arcmenu/
panel_uuid='dash-to-panel@jderose9.github.com'
menu_uuid='arcmenu@arcmenu.com'
extensions_dir="${XDG_DATA_HOME:-$HOME/.local/share}/gnome-shell/extensions"
panel_schema=org.gnome.shell.extensions.dash-to-panel
menu_schema=org.gnome.shell.extensions.arcmenu

# ArcMenu needs GMenu; Python's GI bindings query this laptop's monitor layout.
missing_packages=()
for package in libgnome-menu-3-0 gir1.2-gmenu-3.0 python3-gi; do
  if [[ "$(dpkg-query -W -f='${Status}' "$package" 2>/dev/null || true)" != 'install ok installed' ]]; then
    missing_packages+=("$package")
  fi
done
if ((${#missing_packages[@]})); then
  sudo apt-get update
  sudo apt-get install -y "${missing_packages[@]}"
fi

install_extension() (
  local uuid=$1 version=$2 release_tag=$3 installed_version=0
  if [[ -f "$extensions_dir/$uuid/metadata.json" ]]; then
    installed_version=$(/usr/bin/python3 - "$extensions_dir/$uuid/metadata.json" <<'PY'
import json, sys
with open(sys.argv[1]) as metadata:
    print(json.load(metadata).get('version', 0))
PY
    )
  fi
  if ((installed_version < version)); then
    local work_dir
    work_dir=$(mktemp -d)
    trap 'rm -rf "$work_dir"' EXIT
    echo "INSTALLING: $uuid (extension version $version)"
    curl -fL --retry 3 \
      "https://extensions.gnome.org/download-extension/$uuid.shell-extension.zip?version_tag=$release_tag" \
      -o "$work_dir/extension.zip"
    gnome-extensions install --force "$work_dir/extension.zip"
  fi
  glib-compile-schemas "$extensions_dir/$uuid/schemas"
)

install_extension "$panel_uuid" 74 75054
# ArcMenu's GNOME Extensions version number differs from its release name.
install_extension "$menu_uuid" 74 75483

set_panel() {
  gsettings --schemadir "$extensions_dir/$panel_uuid/schemas" set "$panel_schema" "$1" "$2"
}
set_menu() {
  gsettings --schemadir "$extensions_dir/$menu_uuid/schemas" set "$menu_schema" "$1" "$2"
}

# Clear monitor-specific geometry so both laptops use the same full-width panel.
set_panel panel-positions '{}'
set_panel panel-position BOTTOM
set_panel panel-sizes '{}'
set_panel panel-size 48
set_panel panel-lengths '{}'
set_panel primary-monitor "''"
set_panel multi-monitors false
set_panel stockgs-keep-top-panel false
set_panel intellihide false
set_panel show-favorites true
set_panel show-running-apps true
set_panel isolate-workspaces true
# Avoid grabbing the Super+keypad shortcuts used for tiling.
set_panel hot-keys false

# Dash to Panel stores element order per monitor. Use this machine's indexes,
# not a monitor serial from one laptop. The extension migrates these to IDs.
panel_layout=$(/usr/bin/python3 - <<'PY'
import json
from gi.repository import Gio

bus = Gio.bus_get_sync(Gio.BusType.SESSION, None)
state = bus.call_sync(
    'org.gnome.Mutter.DisplayConfig', '/org/gnome/Mutter/DisplayConfig',
    'org.gnome.Mutter.DisplayConfig', 'GetCurrentState', None, None,
    Gio.DBusCallFlags.NONE, 5000, None,
).unpack()
layout = [
    {'element': name, 'visible': visible, 'position': position}
    for name, visible, position in [
        ('showAppsButton', False, 'stackedTL'),
        ('activitiesButton', False, 'stackedTL'),
        ('leftBox', True, 'stackedTL'),  # ArcMenu lives here.
        ('taskbar', True, 'stackedTL'),
        ('centerBox', True, 'stackedBR'),
        ('rightBox', True, 'stackedBR'),
        ('dateMenu', True, 'stackedBR'),
        ('systemMenu', True, 'stackedBR'),
        ('desktopButton', True, 'stackedBR'),
    ]
]
print(json.dumps({str(i): layout for i in range(len(state[2]))}))
PY
)
set_panel panel-element-positions "$panel_layout"

set_menu menu-layout mint
set_menu dash-to-panel-standalone false
set_menu multi-monitor false
set_menu position-in-panel Left
set_menu menu-button-position-offset 0
set_menu menu-button-appearance Icon_Text
set_menu menu-button-text Menu
set_menu show-activities-button false
# Open the Mint-style menu on left Super tap; right Super remains Compose.
set_menu arcmenu-hotkey-overlay-key-enabled true
set_menu arcmenu-hotkey "['Super_L']"

# Newly installed extensions need a Shell restart before the CLI can enable them.
if ! gnome-extensions info "$panel_uuid" >/dev/null 2>&1 ||
  ! gnome-extensions info "$menu_uuid" >/dev/null 2>&1; then
  echo 'Taskbar configured. Log out and back in, then rerun make gnome-settings to enable it.'
  exit 0
fi

gnome-extensions enable "$panel_uuid"
gnome-extensions enable "$menu_uuid"
if gnome-extensions info 'ubuntu-dock@ubuntu.com' >/dev/null 2>&1; then
  gnome-extensions disable 'ubuntu-dock@ubuntu.com'
fi
