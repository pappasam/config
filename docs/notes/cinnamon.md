# Cinnamon Configuration

Cinnamon is configured manually, through a GUI. This documents the required manual steps for a new setup for Cinnamon `6.0.4`.

## Keyboard

The following keyboard shortcuts and mappings make it easier to do things without moving my hands from the home row.

### Shortcuts

- General
  - Main
    - Show the window selection screen : `Ctrl+Alt+J`
    - Show the workspace selection screen : `Ctrl+Alt+K`
- Windows
  - Main
    - Maximize Window : `Super+M`
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
- Workspaces
  - Main
    - Switch to left workspace: `Ctrl+Alt+H`
    - Switch to right workspace: `Ctrl+Alt+L`
  - Direct Navigation
    - Switch to workspace 1 : `Ctrl+Alt+1`
    - Switch to workspace 2 : `Ctrl+Alt+2`
    - Switch to workspace 3 : `Ctrl+Alt+3`
    - Switch to workspace 4 : `Ctrl+Alt+4`
- System
  - Main
    - Lock screen: `Ctrl+Alt+Q`
  - Hardware
    - Switch monitor configurations: unassign `Super+P`
- Custom
  - Alacritty: `/usr/local/bin/alacritty`, `Ctrl+Alt+i`
  - Firefox: `firefox`, `Ctrl+Alt+b`

### Layouts

- Options
  - Ctrl position: Caps Lock as Ctrl
  - Position of Compose key: Right Win

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

Turn off all effects.

## Windows

- Titlebar
  - Buttons
    - Buttons layout: `Left`
- Behavior
  - "Special Key to move and resize windows": change to "Super"
    - Necessary to enable important Inkscape shortcut
- `Alt-Tab`
  - `Alt-Tab` switcher style: Icons and window preview

## Date and Time

All options off except for "Display the date"

## Workspaces

- OSD
  - Uncheck "Enable workspace OSD". Don't want people seeing my silly workspace names

## Privacy

- Remember recently accessed files: uncheck
