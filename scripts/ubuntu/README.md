# Ubuntu Scripts

Run `make gnome-settings` to apply GNOME shortcuts. `Ctrl+Alt+B/S/I/M` launches Firefox/Slack/kitty/Google Meet by desktop ID using native custom shortcuts. Favorites can be reordered freely. Google Meet requires the installed Chrome app in Profile 6; missing launchers fail instead of opening another application.

Window reuse depends on the application: kitty opens a new window. Vanilla GNOME does not provide a general focus-existing-window command for custom shortcuts on Wayland. Use `Super+Tab` to switch between running applications across workspaces. `Ctrl+Shift+I` inside kitty opens a new window in the existing window's directory.

## Manual commands

This section of the README describes useful programs you will need to install - or configure - manually, when the time is right.

### Tux Guitar

For musical tab editing

<https://github.com/helge17/tuxguitar>

### Fonts

Download a relevant font, place in `~/src/lib/fonts`, and unzip. My favorite at the moment: <https://github.com/theleagueof/league-mono>

1. Copy relevant font files to `~/.local/share/fonts`. Prefer variable fonts, and use TTF (TrueType Font data).
2. Run `fc-cache -fv`.

I also suggest downloading "Symbols NERD Font" from here: <https://www.nerdfonts.com/font-downloads>
