#!/bin/bash

# System install steps for display manager in Ubuntu 18.04. May work for more
# recent versions of Ubuntu, but I haven't tested on these versions.

set -euxo pipefail

# shellcheck disable=SC01091
source "${BASH_SOURCE%/*}/helpers.sh"

echo_bold_italic_underline 'When prompted, choose "lightdm" as display manager'

apt install \
  cinnamon-desktop-environment \
  lightdm \
  lightdm-gtk-greeter

echo_bold_italic_underline "writing /etc/lightdm/lightdm.conf"
echo -e "[SeatDefaults]\ngreeter-session=lightdm-gtk-greeter" > \
  /etc/lightdm/lightdm.conf
