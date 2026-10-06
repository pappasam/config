#!/usr/bin/env bash

set -euo pipefail

wm=org.gnome.desktop.wm.keybindings
mutter=org.gnome.mutter.keybindings
shell=org.gnome.shell.keybindings
media=org.gnome.settings-daemon.plugins.media-keys
tiling_uuid='tiling-assistant@ubuntu.com'

# Use GNOME's native overview and dash without taskbar or switcher extensions.
for uuid in 'advanced-alt-tab@G-dH.github.com' 'arcmenu@arcmenu.com' 'dash-to-panel@jderose9.github.com' 'ubuntu-dock@ubuntu.com'; do
  if gnome-extensions info "$uuid" >/dev/null 2>&1; then
    gnome-extensions disable "$uuid"
  fi
done

# Open the overview on Super tap explicitly: Dell's system defaults disable it.
gsettings set org.gnome.mutter overlay-key 'Super'
gsettings reset "$shell" toggle-overview

# Make Caps Lock an additional Control key; keep right Super as Compose.
gsettings set org.gnome.desktop.input-sources xkb-options "['ctrl:nocaps', 'compose:rwin']"

# Use Alt+Tab for individual windows; keep Super+Tab for applications.
gsettings set "$wm" switch-applications "['<Super>Tab']"
gsettings set "$wm" switch-applications-backward "['<Shift><Super>Tab']"
gsettings set "$wm" switch-windows "['<Alt>Tab']"
gsettings set "$wm" switch-windows-backward "['<Shift><Alt>Tab']"

# Show window thumbnails and app icons, limited to the current workspace.
gsettings set org.gnome.shell.window-switcher current-workspace-only true
gsettings set org.gnome.shell.window-switcher app-icon-mode 'both'

# Switch applications across all workspaces with Super+Tab.
gsettings set org.gnome.shell.app-switcher current-workspace-only false

# Window actions.
gsettings set "$wm" maximize "['<Super>m']"
gsettings set "$wm" unmaximize "['<Super>u']"
gsettings set "$wm" close "['<Alt>F4', '<Primary><Alt>d']"

# Keep hide on the home row; Super+H is used for tiling left.
gsettings set "$wm" minimize "['<Super>j']"

# Remove conflicts with Super+M and Ctrl+Alt+D.
gsettings set "$wm" show-desktop "['<Primary><Super>d', '<Super>d']"
gsettings set "$shell" toggle-message-tray "['<Super>v']"

# Use GNOME's native half-screen tiling without an extension.
# GNOME 50 moved these bindings to Mutter and calls them "toggle-tiled-*".
# Disable Tiling Assistant so it cannot override the native bindings.
gnome-extensions disable "$tiling_uuid"
gsettings set org.gnome.mutter edge-tiling true
gsettings set "$mutter" toggle-tiled-left "['<Super>Left', '<Super>KP_4', '<Super>h']"
gsettings set "$mutter" toggle-tiled-right "['<Super>Right', '<Super>KP_6', '<Super>l']"

# Restore the defaults (unbound) for the old non-resizing edge-push actions.
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

# Navigate workspaces.
# Dell defaults also bind Ctrl+Alt+1–4 to launching dock applications.
# Clear both GNOME Shell's binding and Ubuntu Dock's overlapping bindings.
for workspace in 1 2 3 4; do
  gsettings set "$shell" "switch-to-application-$workspace" '@as []'
  gsettings set org.gnome.shell.extensions.dash-to-dock "app-hotkey-$workspace" '@as []'
  gsettings set org.gnome.shell.extensions.dash-to-dock "app-ctrl-hotkey-$workspace" '@as []'
done
gsettings set "$wm" switch-to-workspace-left "['<Super>Page_Up', '<Control><Alt>Left', '<Control><Alt>h']"
gsettings set "$wm" switch-to-workspace-right "['<Super>Page_Down', '<Control><Alt>Right', '<Control><Alt>l']"
gsettings set "$wm" switch-to-workspace-1 "['<Super>Home', '<Control><Alt>1']"
gsettings set "$wm" switch-to-workspace-2 "['<Control><Alt>2']"
gsettings set "$wm" switch-to-workspace-3 "['<Control><Alt>3']"
gsettings set "$wm" switch-to-workspace-4 "['<Control><Alt>4']"

# Keep stable numbered destinations, using GNOME's default count of four.
gsettings set org.gnome.mutter dynamic-workspaces false
gsettings reset org.gnome.desktop.wm.preferences num-workspaces
gsettings set org.gnome.desktop.wm.preferences workspace-names "['Build', 'Communicate', 'Meet', 'Explore']"

# System and launcher shortcuts.
# Removing Super+L is necessary because it is used for tiling right.
gsettings set "$media" screensaver "['<Control><Alt>q']"
gsettings set "$media" www "['<Control><Alt>b']"

# Restore the default Super+P and monitor hardware key.
gsettings reset "$mutter" switch-monitor

# Match Appearance's Default style and preserve the selected GTK/accent theme.
gsettings set org.gnome.desktop.interface color-scheme default

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

set_custom_shortcut custom0 Kitty /home/sroeca/.local/bin/kitty '<Control><Alt>i'

set_custom_shortcut custom1 'Murmure Record Toggle' 'murmure --transcription' Scroll_Lock

# Reserve the media-player key for Murmure, including the static system binding.
gsettings set "$media" media '@as []'
gsettings set "$media" media-static '@as []'

set_custom_shortcut custom2 'Murmure Record Toggle2' 'murmure --transcription' XF86AudioMedia

set_custom_shortcut custom3 'Murmure Cancel' 'murmure --cancel' '<Control>Scroll_Lock'

set_custom_shortcut custom4 'Murmure Cancel (Media)' 'murmure --cancel' '<Control>XF86AudioMedia'

set_custom_shortcut custom5 'Flameshot to clipboard' 'flameshot gui --clipboard --accept-on-select' ''

set_custom_shortcut custom6 'Murmure Record Toggle (TouchpadOff)' 'murmure --transcription' '<Shift><Super>XF86TouchpadOff'
set_custom_shortcut custom7 'Murmure Cancel (TouchpadOff)' 'murmure --cancel' '<Control><Shift><Super>XF86TouchpadOff'
set_custom_shortcut custom8 'Shut Down' "\"$HOME/config/bin/confirm-shutdown\"" '<Control><Alt>End'

# Use GNOME's native screenshot UI on Wayland.
gsettings set "$shell" show-screenshot-ui "['Print']"

gsettings set "$media" custom-keybindings "['$custom_base/custom0/', '$custom_base/custom1/', '$custom_base/custom2/', '$custom_base/custom3/', '$custom_base/custom4/', '$custom_base/custom5/', '$custom_base/custom6/', '$custom_base/custom7/', '$custom_base/custom8/']"
