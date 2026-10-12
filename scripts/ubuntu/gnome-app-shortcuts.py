#!/usr/bin/python3
"""Configure native GNOME focus-or-launch shortcuts for installed applications."""

import argparse
import json
import os
from pathlib import Path
import re
import sys


APPS = {
    "firefox": ("b", ("firefox.desktop", "firefox_firefox.desktop", "org.mozilla.firefox.desktop")),
    "slack": ("s", ("slack.desktop", "slack_slack.desktop", "com.slack.Slack.desktop")),
    "kitty": ("i", ("kitty.desktop", "net.kovidgoyal.kitty.desktop")),
    "meet": ("m", ()),
}
MEET_ID = re.compile(r"chrome-kjgfgldnnfoeklkmfkjfagphfepbbdan-.+\.desktop")
CUSTOM_BASE = "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings"
OLD_LAUNCHERS = ("custom0", "custom9", "custom10", "custom11")


def make_plan(installed, favorites, overrides):
    """Resolve desktop IDs before assigning contiguous Favorites positions."""
    unknown = overrides.keys() - APPS.keys()
    if unknown:
        raise ValueError(f"Unknown applications in overrides: {', '.join(sorted(unknown))}")
    selected = {}
    for name, (_, aliases) in APPS.items():
        if name in overrides:
            desktop_id = overrides[name]
            if not isinstance(desktop_id, str) or desktop_id not in installed:
                raise ValueError(f"{name}: override {desktop_id!r} is not an available launcher")
        else:
            candidates = [app for app in aliases if app in installed]
            if name == "meet":
                candidates = sorted(app for app in installed if MEET_ID.fullmatch(app))
            # Keep a previously chosen installation/profile when still available.
            desktop_id = next((app for app in favorites if app in candidates), None)
            if desktop_id is None and candidates:
                # Multiple Meet profiles need an explicit choice, not a guessed profile.
                if name != "meet" or len(candidates) == 1:
                    desktop_id = candidates[0]
        selected[name] = desktop_id

    pinned = [app for app in selected.values() if app is not None]
    if len(pinned) != len(set(pinned)):
        raise ValueError("Each application must use a different desktop ID")
    # Drop stale IDs so GNOME cannot silently collapse a slot in this layout.
    remaining = list(dict.fromkeys(app for app in favorites if app in installed and app not in pinned))
    bindings = {
        pinned.index(app) + 1: f"<Control><Alt>{APPS[name][0]}"
        for name, app in selected.items() if app is not None
    }
    return selected, pinned + remaining, bindings


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--dry-run", action="store_true", help="show the mapping without changing settings")
    args = parser.parse_args()
    config = Path(os.environ.get("XDG_CONFIG_HOME", str(Path.home() / ".config"))) / "gnome-app-shortcuts.json"
    try:
        overrides = json.loads(config.read_text()) if config.exists() else {}
        if not isinstance(overrides, dict):
            raise ValueError("Overrides must be a JSON object mapping application names to desktop IDs")

        import gi
        gi.require_version("Gio", "2.0")
        from gi.repository import Gio

        installed = {
            app.get_id() for app in Gio.AppInfo.get_all()
            if app.get_id() and app.should_show()
        }
        shell = Gio.Settings.new("org.gnome.shell")
        selected, favorites, bindings = make_plan(installed, shell.get_strv("favorite-apps"), overrides)
    except (OSError, ValueError) as error:
        parser.error(str(error))

    for name, desktop_id in selected.items():
        shortcut = f"Ctrl+Alt+{APPS[name][0].upper()}"
        if desktop_id is None:
            print(f"{shortcut}: disabled ({name}: no unique launcher found; override in {config})")
        else:
            print(f"{shortcut}: {desktop_id} (Favorites slot {favorites.index(desktop_id) + 1})")
    if args.dry_run:
        return

    keys = Gio.Settings.new("org.gnome.shell.keybindings")
    media = Gio.Settings.new("org.gnome.settings-daemon.plugins.media-keys")

    def set_strv(settings, key, value):
        if not settings.set_strv(key, value):
            raise RuntimeError(f"Could not set {key}")

    # Remove the previous positional mapping before changing the Favorites order.
    for slot in range(1, 5):
        set_strv(keys, f"switch-to-application-{slot}", [])
    old_paths = [f"{CUSTOM_BASE}/{slot}/" for slot in OLD_LAUNCHERS]
    set_strv(media, "custom-keybindings", [path for path in media.get_strv("custom-keybindings") if path not in old_paths])
    for path in old_paths:
        custom = Gio.Settings.new_with_path("org.gnome.settings-daemon.plugins.media-keys.custom-keybinding", path)
        for key in ("name", "command", "binding"):
            custom.reset(key)
    for key in ("www", "terminal"):
        if media.props.settings_schema.has_key(key):
            set_strv(media, key, [])
    Gio.Settings.sync()
    set_strv(shell, "favorite-apps", favorites)
    Gio.Settings.sync()
    for slot, binding in bindings.items():
        set_strv(keys, f"switch-to-application-{slot}", [binding])
    Gio.Settings.sync()


if __name__ == "__main__":
    sys.exit(main())
