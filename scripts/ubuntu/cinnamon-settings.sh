#!/usr/bin/env bash

set -euo pipefail

wm=org.cinnamon.desktop.keybindings.wm
keys=org.cinnamon.desktop.keybindings
media=org.cinnamon.desktop.keybindings.media-keys

# Mirror gnome-settings.sh where Cinnamon has an equivalent.
# Cinnamon's Super tap opens its menu; there is no GNOME overview/tray binding.

# Switch windows on the current workspace with either Alt+Tab or Super+Tab.
gsettings set "$wm" switch-windows "['<Alt>Tab', '<Super>Tab']"
gsettings set "$wm" switch-windows-backward "['<Shift><Alt>Tab', '<Shift><Super>Tab']"
gsettings set org.cinnamon alttab-switcher-show-all-workspaces false

# Window actions.
gsettings set "$wm" maximize "['<Super>m']"
gsettings set "$wm" unmaximize "['<Super>u']"
gsettings set "$wm" close "['<Alt>F4', '<Primary><Alt>d']"
gsettings set "$wm" minimize "['<Super>j']"
gsettings set "$wm" show-desktop "['<Primary><Super>d', '<Super>d']"

# Free Super+L from Looking Glass, Cinnamon's debugger.
gsettings set "$keys" looking-glass-keybinding '@as []'

# Cinnamon uses push-tile-* for native tiling.
gsettings set org.cinnamon.muffin edge-tiling true
gsettings set "$wm" push-tile-left "['<Super>Left', '<Super>KP_4', '<Super>h']"
gsettings set "$wm" push-tile-right "['<Super>Right', '<Super>KP_6', '<Super>l']"
# Clear the old home-row tiling overrides, especially Super+J (now minimize).
gsettings reset "$wm" push-tile-up
gsettings reset "$wm" push-tile-down
gsettings reset "$wm" move-to-side-w
gsettings reset "$wm" move-to-side-e

# Move windows between workspaces.
gsettings set "$wm" move-to-workspace-left "['<Super><Shift>Page_Up', '<Control><Shift><Alt>Left', '<Control><Shift><Alt>h']"
gsettings set "$wm" move-to-workspace-right "['<Super><Shift>Page_Down', '<Control><Shift><Alt>Right', '<Control><Shift><Alt>l']"

# Move windows between monitors.
gsettings set "$wm" move-to-monitor-left "['<Super><Shift>Left', '<Super><Shift>h']"
gsettings set "$wm" move-to-monitor-right "['<Super><Shift>Right', '<Super><Shift>l']"
gsettings set "$wm" move-to-monitor-up "['<Super><Shift>Up', '<Super><Shift>k']"
gsettings set "$wm" move-to-monitor-down "['<Super><Shift>Down', '<Super><Shift>j']"

# Navigate four fixed workspaces, matching GNOME's configured count.
gsettings set "$wm" switch-to-workspace-left "['<Super>Page_Up', '<Control><Alt>Left', '<Control><Alt>h']"
gsettings set "$wm" switch-to-workspace-right "['<Super>Page_Down', '<Control><Alt>Right', '<Control><Alt>l']"
gsettings set "$wm" switch-to-workspace-1 "['<Super>Home', '<Control><Alt>1']"
gsettings set "$wm" switch-to-workspace-2 "['<Control><Alt>2']"
gsettings set "$wm" switch-to-workspace-3 "['<Control><Alt>3']"
gsettings set "$wm" switch-to-workspace-4 "['<Control><Alt>4']"
gsettings set org.cinnamon.muffin dynamic-workspaces false
gsettings set org.cinnamon.desktop.wm.preferences num-workspaces 4

# System and launcher shortcuts.
gsettings set "$media" screensaver "['<Control><Alt>q']"
gsettings set "$media" www "['<Control><Alt>b']"
gsettings reset "$wm" switch-monitor

custom_schema=org.cinnamon.desktop.keybindings.custom-keybinding
custom_base=/org/cinnamon/desktop/keybindings/custom-keybindings

set_custom_shortcut() {
  local id=$1
  local name=$2
  local command=$3
  local binding=$4
  local path="$custom_base/$id/"

  gsettings set "$custom_schema:$path" name "$name"
  gsettings set "$custom_schema:$path" command "$command"
  # Unlike GNOME, Cinnamon stores custom bindings as arrays.
  gsettings set "$custom_schema:$path" binding "['$binding']"
}

set_custom_shortcut custom0 Kitty /home/sroeca/.local/bin/kitty '<Control><Alt>i'
set_custom_shortcut custom1 'Murmure Record Toggle' 'murmure --transcription' Scroll_Lock
set_custom_shortcut custom2 'Murmure Record Toggle2' 'murmure --transcription' XF86AudioMedia
set_custom_shortcut custom3 'Murmure Cancel' 'murmure --cancel' '<Control>Scroll_Lock'
set_custom_shortcut custom4 'Murmure Paste Last2' 'murmure --paste-last' '<Control>XF86AudioMedia'

# Reserve the media-player key for Murmure. Cinnamon has no media-static key.
gsettings set "$media" media '@as []'

# Cinnamon reloads custom commands only when this list changes. Clear it first
# so rerunning the script also refreshes existing shortcuts.
gsettings set "$keys" custom-list '@as []'
gsettings set "$keys" custom-list "['custom0', 'custom1', 'custom2', 'custom3', 'custom4']"
