#!/usr/bin/env bash

set -euo pipefail

wm=org.gnome.desktop.wm.keybindings
mutter=org.gnome.mutter.keybindings
shell=org.gnome.shell.keybindings
media=org.gnome.settings-daemon.plugins.media-keys
tiling_uuid='tiling-assistant@ubuntu.com'

# GNOME's Overview combines Cinnamon's window and workspace selection views.
gsettings set "$shell" toggle-overview \
  "['<Primary><Alt>j', '<Primary><Alt>k']"

# Window actions.
gsettings set "$wm" maximize "['<Super>m']"
gsettings set "$wm" unmaximize "['<Super>u']"
gsettings set "$wm" close "['<Alt>F4', '<Primary><Alt>d']"

# Remove conflicts with Super+H, Super+M, and Ctrl+Alt+D.
gsettings set "$wm" minimize '@as []'
gsettings set "$wm" show-desktop \
  "['<Primary><Super>d', '<Super>d']"
gsettings set "$shell" toggle-message-tray "['<Super>v']"

# Use GNOME's native half-screen tiling without an extension.
# GNOME 50 moved these bindings to Mutter and calls them "toggle-tiled-*".
# Disable Tiling Assistant so it cannot override the native bindings.
gnome-extensions disable "$tiling_uuid"
gsettings set org.gnome.mutter edge-tiling true
gsettings set "$mutter" toggle-tiled-left \
  "['<Super>Left', '<Super>KP_4', '<Super>h']"
gsettings set "$mutter" toggle-tiled-right \
  "['<Super>Right', '<Super>KP_6', '<Super>l']"

# Clear the non-resizing edge-push bindings.
gsettings set "$wm" move-to-side-w '@as []'
gsettings set "$wm" move-to-side-e '@as []'

# Move windows between workspaces.
gsettings set "$wm" move-to-workspace-left \
  "['<Super><Shift>Page_Up', '<Control><Shift><Alt>Left', '<Control><Shift><Alt>h']"
gsettings set "$wm" move-to-workspace-right \
  "['<Super><Shift>Page_Down', '<Control><Shift><Alt>Right', '<Control><Shift><Alt>l']"

# Move windows between monitors.
gsettings set "$wm" move-to-monitor-left \
  "['<Super><Shift>Left', '<Super><Shift>h']"
gsettings set "$wm" move-to-monitor-right \
  "['<Super><Shift>Right', '<Super><Shift>l']"
gsettings set "$wm" move-to-monitor-up \
  "['<Super><Shift>Up', '<Super><Shift>k']"
gsettings set "$wm" move-to-monitor-down \
  "['<Super><Shift>Down', '<Super><Shift>j']"

# Navigate workspaces.
gsettings set "$wm" switch-to-workspace-left \
  "['<Super>Page_Up', '<Control><Alt>Left', '<Control><Alt>h']"
gsettings set "$wm" switch-to-workspace-right \
  "['<Super>Page_Down', '<Control><Alt>Right', '<Control><Alt>l']"
gsettings set "$wm" switch-to-workspace-1 \
  "['<Super>Home', '<Control><Alt>1']"
gsettings set "$wm" switch-to-workspace-2 "['<Control><Alt>2']"
gsettings set "$wm" switch-to-workspace-3 "['<Control><Alt>3']"
gsettings set "$wm" switch-to-workspace-4 "['<Control><Alt>4']"

# Uncomment these if workspace 1-4 should always exist.
# gsettings set org.gnome.mutter dynamic-workspaces false
# gsettings set org.gnome.desktop.wm.preferences num-workspaces 4

# System and launcher shortcuts.
# Removing Super+L is necessary because it is used for tiling right.
gsettings set "$media" screensaver "['<Control><Alt>q']"
gsettings set "$media" www "['<Control><Alt>b']"

# Retain the monitor hardware key but remove Super+P.
gsettings set "$mutter" switch-monitor "['XF86Display']"

# Keyboard layout.
gsettings set org.gnome.desktop.input-sources xkb-options \
  "['ctrl:nocaps', 'compose:rwin']"

# Clock and privacy.
gsettings set org.gnome.desktop.interface clock-format 12h
gsettings set org.gnome.desktop.privacy remember-recent-files false

custom_schema=org.gnome.settings-daemon.plugins.media-keys.custom-keybinding
custom_base=/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings

set_custom_shortcut() {
  local id=$1
  local name=$2
  local command=$3
  local binding=$4
  local path="$custom_base/$id/"

  gsettings set "$custom_schema:$path" name "$name"
  gsettings set "$custom_schema:$path" command "$command"
  gsettings set "$custom_schema:$path" binding "$binding"
}

set_custom_shortcut \
  custom0 \
  Kitty \
  /home/sroeca/.local/bin/kitty \
  '<Control><Alt>i'

set_custom_shortcut \
  custom1 \
  'Murmure Record Toggle' \
  'murmure --transcription' \
  Scroll_Lock

set_custom_shortcut \
  custom2 \
  'Murmure Record Toggle2' \
  'murmure --transcription' \
  AudioMedia

gsettings set "$media" custom-keybindings \
  "['$custom_base/custom0/', '$custom_base/custom1/', '$custom_base/custom2/']"
