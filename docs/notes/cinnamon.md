# Cinnamon Configuration

Run `make cinnamon-settings` from the repository root to apply [Cinnamon keybindings](../../scripts/ubuntu/cinnamon-settings.sh), mirroring the GNOME script where applicable. The script manages the custom shortcut list. The remaining GUI settings below were documented for Cinnamon `6.0.4`.

## Keyboard

The script configures window actions, tiling, workspace and monitor navigation, screen locking, browser launch, Kitty, Murmure, and Flameshot. `Super+H/L` tiles left/right, `Super+K/J` tiles up/down, and `Super+P` switches monitor configurations.

### Shortcuts

- Murmure Record Toggle: `murmure --transcription`, `ScrollLock` or `Media`
- Murmure Cancel: `murmure --cancel`, `Ctrl+ScrollLock`
- Murmure Paste Last: `murmure --paste-last`, `Ctrl+Media`
- Flameshot to clipboard: `flameshot gui --clipboard --accept-on-select`, `PrintScrn` (the script disables the built-in screenshot shortcut)

Cinnamon keeps its menu on Super tap and uses its window switcher for both `Alt+Tab` and `Super+Tab`. GNOME's overview and message-tray shortcuts have no direct equivalent in this script.

Optional Cinnamon-only shortcuts to configure through the GUI after running the script:

- Show the window selection screen: `Ctrl+Alt+J`
- Show the workspace selection screen: `Ctrl+Alt+K`

### Layouts

- Options
    - Ctrl position: Caps Lock as Ctrl
    - Position of Compose key: Right Win

## Windows

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
