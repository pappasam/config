# Linux Mint Configuration Notes

Parts of Linux Mint are configured manually through a GUI.
Since I cannot script these parts of setup, this document serves
as a reminder for those necessary manual steps.

## Themes

I currently use the Windows 10 Light Theme.
Below are the GUI configurations for my optimal config:

* Window borders: Windows 10
* Icons: Mint-X
* Controls: Windows 10
* Mouse Pointer: DMZ-White
* Desktop: Windows 10

## Effects

Turn off all effects other than "Overlay scroll bars"

## Keyboard

The following keyboard shortcuts and mappings make it easier
to do things without moving my hands from the home row.

### Shortcuts

1. **General**
  1. Main
    * Toggle Scale : Ctrl+Alt+J
    * Toggle Expo : Ctrl+Alt+K
  2. Troubleshooting
    * Toggle Looking Glass : REMOVE BINDING (conflicts with Shift+Super+L)
2. **System**
  1. Main
    * Lock screen : remove key shortcut
3. **Workspaces**
  1. Main
    * Switch to left workspace: Ctrl+Alt+H
    * Switch to right workspace: Ctrl+Alt+L
  2. Direct Navigation
    * Switch to workspace 1 : Ctrl+Alt+1
    * Switch to workspace 2 : Ctrl+Alt+2
    * Switch to workspace 3 : Ctrl+Alt+3
    * Switch to workspace 4 : Ctrl+Alt+4
4. **Windows**
  1. Main
    * Toggle fullscreen state : Super+F
    * Close window : Alt+Q
  2. Tiling and Snapping
    * Push tile left : Super+H
    * Push tile right : Super+L
    * Push tile up : Super+K
    * Push tile down : Super+J
  3. Inter-workspace
    * Move window to left workspace : Shift+Ctrl+Alt+H
    * Move window to right workspace : Shift+Ctrl+Alt+L
  4. Inter-monitor
    * Move window to left monitor: Shift+Super+H
    * Move window to right monitor: Shift+Super+L
    * Move window to up monitor: Shift+Super+K
    * Move window to down monitor: Shift+Super+J
5. **Launchers**
  * Launch terminal : Ctrl+Alt+i
  * Launch web browser : Ctrl+Alt+B
6. **System**
  1. Hardware
    * Re-detect display devices: remove the Super+P shortcut (easy to hit accidentailly)
7. **Custom**
  1. Panel Toggle
    * Command : ~/configsettings/panel-autohide.sh
    * Shortcut : Ctrl+Alt+P
  2. Screenshot Select Area
    * Shortcut: Ctrl+Alt+Y

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
