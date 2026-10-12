# Ubuntu Scripts

Run `make gnome-settings` to apply GNOME shortcuts. `Ctrl+Alt+B/S/I/M` focuses an existing Firefox/Slack/kitty/Google Meet window across workspaces, or launches the app if closed, using GNOME's built-in Favorites shortcuts. `Ctrl+Shift+I` inside kitty opens a new window in the existing window's directory.

The script detects installed desktop launchers, pins available apps first in that order, and assigns shortcuts to their actual positions. It recognizes common native, Snap, and Flatpak IDs and detects Meet's Chrome app across profiles. Missing apps leave their shortcuts disabled. Other available Favorites are preserved after the managed apps; stale launcher IDs are removed. When multiple installations exist, an existing Favorite is preferred, followed by the native/Snap/Flatpak candidate order. Multiple Meet profiles require an existing Favorite or an explicit override.

These Favorites positions are managed configuration. Rerun after installing/removing an app or rearranging Favorites; until then, GNOME's positional bindings can point at a different app. To preview or update only the application shortcuts:

```bash
/usr/bin/python3 scripts/ubuntu/gnome-app-shortcuts.py --dry-run
/usr/bin/python3 scripts/ubuntu/gnome-app-shortcuts.py
```

For unusual launcher IDs or to select a particular installation/profile, create `~/.config/gnome-app-shortcuts.json` (or under `$XDG_CONFIG_HOME`). Only include overrides needed on that computer, for example:

```json
{
  "firefox": "org.mozilla.firefox.desktop",
  "meet": "chrome-kjgfgldnnfoeklkmfkjfagphfepbbdan-Profile_2.desktop"
}
```

Supported keys are `firefox`, `slack`, `kitty`, and `meet`. Overrides must name available, visible desktop launchers; invalid overrides stop the application-shortcut helper before it changes settings. Applications must be discoverable in the desktop session's XDG application directories. The helper uses the system Python's PyGObject/Gio bindings.

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
