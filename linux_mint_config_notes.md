# Linux Mint Configuration Notes

Parts of Linux Mint are configured manually through a GUI.
Since I cannot script these parts of setup, this document serves
as a reminder for those necessary manual steps.

## Themes

* Window borders
    * Esco
* Icons
    * Mint-Y
* Controls
    * Mint-Y-Dark
* Mouse Pointer
    * DMZ-White
* Desktop
    * Mint-Y-Dark

## Effects

Turn off all effects other than "Overlay scroll bars"

## Keyboard

The following keyboard shortcuts and mappings make it easier
to do things without moving my hands from the home row.

### Shortcuts

* **General**
    * Main
        * Toggle Scale : Ctrl+Alt+J
        * Toggle Expo : Ctrl+Alt+K
* **Workspaces**
    * Main
        * Switch to left workspace: Ctrl+Alt+H
        * Switch to right workspace: Ctrl+Alt+L
    * Direct Navigation
        * Switch to workspace 1 : Ctrl+Alt+1
        * Switch to workspace 2 : Ctrl+Alt+2
        * Switch to workspace 3 : Ctrl+Alt+3
        * Switch to workspace 4 : Ctrl+Alt+4
* **Windows**
    * Main
        * Maximize Window : Super+M
        * Unmaximize Window: Super+U
        * Toggle fullscreen state : Super+F
        * Close window : Alt+Q
    * Tiling and Snapping
        * Push tile left : Super+H
        * Push tile right : Super+L
        * Push tile up : Super+K
        * Push tile down : Super+J
    * Inter-workspace
        * Move window to left workspace : Shift+Ctrl+Alt+H
        * Move window to right workspace : Shift+Ctrl+Alt+L
    * Inter-monitor
        * Move window to left monitor: Shift+Super+H
        * Move window to right monitor: Shift+Super+L
        * Move window to up monitor: Shift+Super+K
        * Move window to down monitor: Shift+Super+J
* **Launchers**
    * Launch web browser : Ctrl+Alt+B
* **System**
    * Hardware
        * Re-detect display devices: remove the Super+P shortcut (easy to hit accidentailly)
        * Toggle touchpad state: Ctrl+Alt+T
    * Screenshots and recording
        * Take a screenshot of an area: Ctrl+Alt+Y
        * Copy a screenshot of an area to a clipboard: Shift+Ctrl+Alt+Y
* **Custom**
    * Panel Toggle
        * Command : ~/configsettings/panel-autohide.sh
        * Shortcut : Ctrl+Alt+P
    * Terminal Maxsize
        * Command : /usr/bin/gnome-terminal --maximize
        * Shortcut : Ctrl+Alt+i

### Layouts

* Options
  * Ctrl key position: Caps Lock as Ctrl

## Date and Time

All options off except for "Display the date"

## Applets

Some system configurations must be configured within the applets menu.

### Main cinnamon menu

1. Menu
1. Chrome Apps
    * disable all of them, pinning necessary ones to panel before
    * necessary because chrome apps are annoyingly searched when "chrome" is typed

## Workspaces

* OSD
    * Uncheck "Enable workspace OSD". Don't want people seeing my silly workspace names
