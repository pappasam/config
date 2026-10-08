# Ubuntu Scripts

Run `make gnome-settings` to apply GNOME shortcuts. `Ctrl+Alt+B/S/I/M` focuses the most recently used Firefox/Slack/kitty/Google Meet window across workspaces, or launches the app if closed. These apps occupy the first four Favorites slots. Google Meet uses the installed Chrome app in Profile 6. Use `Ctrl+Shift+I` inside kitty to open a new window.

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
