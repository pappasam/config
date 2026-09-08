#!/bin/bash

set -euo pipefail

# Official Linux release: https://get.vial.today/download/
version=0.7.5
data_dir="${XDG_DATA_HOME:-$HOME/.local/share}"
install_dir="$data_dir/vial/$version"

if [[ "$(uname -m)" != x86_64 ]]; then
  echo 'Vial only provides an x86_64 Linux AppImage.' >&2
  exit 1
fi

work_dir=$(mktemp -d)
trap 'rm -rf "$work_dir"' EXIT

if [[ ! -x "$install_dir/AppRun" ]]; then
  echo "INSTALLING: Vial $version"
  curl -fL --retry 3 \
    "https://github.com/vial-kb/vial-gui/releases/download/v$version/Vial-v$version-x86_64.AppImage" \
    -o "$work_dir/Vial.AppImage"
  chmod +x "$work_dir/Vial.AppImage"
  # Extract once so launching Vial does not require FUSE.
  (cd "$work_dir" && ./Vial.AppImage --appimage-extract >/dev/null)
  mkdir -p "$install_dir"
  cp -a "$work_dir/squashfs-root/." "$install_dir/"
fi

mkdir -p "$HOME/.local/bin" "$data_dir/applications"
ln -sfn "$install_dir/AppRun" "$HOME/.local/bin/vial"
cat >"$data_dir/applications/vial.desktop" <<EOF
[Desktop Entry]
Type=Application
Name=Vial
Comment=Configure your keyboard
Exec="$install_dir/AppRun"
Icon=$install_dir/Vial.png
Terminal=false
Categories=Utility;
EOF

# Allow access to Vial keyboards, preserving any existing custom rule.
# See: https://get.vial.today/manual/linux-udev.html
if [[ ! -f /etc/udev/rules.d/59-vial.rules ]]; then
  echo "KERNEL==\"hidraw*\", SUBSYSTEM==\"hidraw\", ATTRS{serial}==\"*vial:f64c2b3c*\", MODE=\"0660\", GROUP=\"$(id -g)\", TAG+=\"uaccess\", TAG+=\"udev-acl\"" >"$work_dir/59-vial.rules"
  sudo install -o root -g root -m 644 "$work_dir/59-vial.rules" /etc/udev/rules.d/59-vial.rules
  sudo udevadm control --reload-rules
  sudo udevadm trigger --subsystem-match=hidraw
fi

echo 'Vial is installed. Launch it from the app menu or run vial.'
