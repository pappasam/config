#!/usr/bin/env bash

set -euo pipefail

# Reviewed release: https://extensions.gnome.org/extension/4105/notification-banner-position/
version=23
release_tag=70901
uuid='notification-position@drugo.dev'
schema=org.gnome.shell.extensions.notification-position
extension_dir="${XDG_DATA_HOME:-$HOME/.local/share}/gnome-shell/extensions/$uuid"

shell_version=$(gnome-shell --version)
case "$shell_version" in
  'GNOME Shell 45.'*|'GNOME Shell 46.'*|'GNOME Shell 47.'*|'GNOME Shell 48.'*|'GNOME Shell 49.'*|'GNOME Shell 50.'*) ;;
  *) echo "Notifications: no pinned release for $shell_version" >&2; exit 1 ;;
esac

installed_version=0
if [[ -f "$extension_dir/metadata.json" ]]; then
  installed_version=$(/usr/bin/python3 - "$extension_dir/metadata.json" <<'PY'
import json, sys
with open(sys.argv[1]) as metadata:
    print(json.load(metadata).get('version', 0))
PY
  )
fi
if ((installed_version < version)); then
  work_dir=$(mktemp -d)
  trap 'rm -rf "$work_dir"' EXIT
  curl -fL --retry 3 \
    "https://extensions.gnome.org/download-extension/$uuid.shell-extension.zip?version_tag=$release_tag" \
    -o "$work_dir/notification-position.zip"
  gnome-extensions install --force "$work_dir/notification-position.zip"
fi

glib-compile-schemas "$extension_dir/schemas"
gsettings --schemadir "$extension_dir/schemas" set "$schema" position top-right

if gnome-extensions info "$uuid" >/dev/null 2>&1; then
  gnome-extensions enable "$uuid"
else
  # GNOME discovers CLI-installed extensions at the next login. Queue activation
  # without replacing the user's other enabled extensions.
  /usr/bin/python3 - "$uuid" <<'PY'
import sys
from gi.repository import Gio

uuid = sys.argv[1]
settings = Gio.Settings.new('org.gnome.shell')
enabled = settings.get_strv('enabled-extensions')
if uuid not in enabled:
    settings.set_strv('enabled-extensions', enabled + [uuid])
disabled = settings.get_strv('disabled-extensions')
if uuid in disabled:
    settings.set_strv('disabled-extensions', [item for item in disabled if item != uuid])
Gio.Settings.sync()
PY
  echo 'Notifications configured for the top right. Log out and back in to activate the extension.'
fi
