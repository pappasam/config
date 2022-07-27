#!/bin/bash

# System install steps for display manager in Ubuntu 18.04. May work for more
# recent versions of Ubuntu, but I haven't tested on these versions.

set -euo pipefail

function echo_bold_italic_underline() {
  echo -e "\e[3m\e[1m\e[4m$1\e[0m"
}

echo_bold_italic_underline 'When prompted, choose "lightdm" as display manager'

apt install \
  cinnamon-desktop-environment \
  lightdm \
  lightdm-gtk-greeter

echo_bold_italic_underline "writing /etc/lightdm/lightdm.conf"
echo -e "[SeatDefaults]\ngreeter-session=lightdm-gtk-greeter" > \
  /etc/lightdm/lightdm.conf
