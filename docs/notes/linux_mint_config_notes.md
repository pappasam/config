# Cinnamon Configuration Notes

Cinnamon is configured manually, through a GUI. This documents the required manual steps for a new setup.

## Shortcuts

| Action           | Command               |
| ---------------- | --------------------- |
| Restart cinnamon | `<A-F2>`, `r`, `<CR>` |

## Themes

I'm using Jade-1 + Mint-Y. Jade-1 provides window borders that make the currently active window easy to identify.

| Section        | Setting   |
| -------------- | --------- |
| Window borders | Jade-1    |
| Icons          | Mint-Y    |
| Controls       | Mint-Y    |
| Mouse Pointer  | DMZ-White |
| Desktop        | Mint-Y    |

## Effects

Turn off all effects other than "Overlay scroll bars"

## Keyboard

The following keyboard shortcuts and mappings make it easier to do things without moving my hands from the home row.

### Shortcuts

- General
  - Main
    - Show the window selection screen : `Ctrl+Alt+J`
    - Show the workspace selection screen : `Ctrl+Alt+K`
- Workspaces
  - Main
    - Switch to left workspace: `Ctrl+Alt+H`
    - Switch to right workspace: `Ctrl+Alt+L`
  - Direct Navigation
    - Switch to workspace 1 : `Ctrl+Alt+1`
    - Switch to workspace 2 : `Ctrl+Alt+2`
    - Switch to workspace 3 : `Ctrl+Alt+3`
    - Switch to workspace 4 : `Ctrl+Alt+4`
- Windows
  - Main
    - Maximize Window : `Super+F` and `Super+M`
    - Unmaximize Window: `Super+U`
    - Close window : `Ctrl+Alt+D`
  - Tiling and Snapping
    - Push tile left : `Super+H`
    - Push tile right : `Super+L`
    - Push tile up : `Super+K`
    - Push tile down : `Super+J`
  - Inter-workspace
    - Move window to left workspace : `Shift+Ctrl+Alt+H`
    - Move window to right workspace : `Shift+Ctrl+Alt+L`
  - Inter-monitor
    - Move window to left monitor: `Shift+Super+H`
    - Move window to right monitor: `Shift+Super+L`
    - Move window to up monitor: `Shift+Super+K`
    - Move window to down monitor: `Shift+Super+J`
- System
  - Main
    - Lock screen: `Ctrl+Q`
  - Hardware
    - Re-detect display devices: remove `Super+P` (easy to hit accidentailly)
- Custom
  - Alacritty: `/usr/bin/alacritty`, `Ctrl+Alt+i`
  - Firefox: `firefox`, `Ctrl+Alt+b`

### Layouts

- Options
  - Ctrl position: Caps Lock as Ctrl
  - Position of Compose key: Right Win

## Windows

- Titlebar
  - Left side title bar buttons: `[Close]`, `[]`, `[]`, `[]`
  - Right side title bar buttons: `[Minimize]`, `[Maximize]`
- Behavior
  - "Special Key to move and resize windows": change to "Super"
    - Necessary to enable important Inkscape shortcut
  - Edge resistance with other windows: uncheck
    - Moving windows with mouse increases CPU usage a lot
- `Alt-Tab`
  - `Alt-Tab` switcher style: Icons and window preview

## Date and Time

All options off except for "Display the date"

## Applets

Some system configurations must be configured within the `applets` menu.

### Main cinnamon menu

1. Menu
1. Chrome Apps
   - disable all of them, pinning necessary ones to panel before
   - necessary because chrome apps are annoyingly searched when "chrome" is typed

## Workspaces

- OSD
  - Uncheck "Enable workspace OSD". Don't want people seeing my silly workspace names

## Headphone jack stops working

Sometimes the headphone jack randomly stops working. To fix this, perform the following steps (in order):

```bash
# do funky stuff to reset the drivers
sudo alsa force-reload
sudo apt-get remove --purge alsa-base pulseaudio
sudo apt-get install alsa-base pulseaudio
sudo alsa force-reload

# shutdown the computer
sudo shutdown now

# wait a minute, then reboot the computer
# IMPORTANT
#   after you plug in your headphone jack, open the "Sound"
#   window in the GUI and select "Headphones built-in audio"
#   the sound should now work

## Foreign language keys

- Compose Key, Shift + ^ + s = ŝ
- Compose Key, Shift + ^ + g = ĝ
- Compose Key, Shift + ^ + j = ĵ
- Compose Key, Shift + u + u = ŭ

## Fix Nvidia Performance

- To make video performance good, enable FXAA in Nvidia settings
- Disable this when using Alacritty for now (2018-08-25)
```
