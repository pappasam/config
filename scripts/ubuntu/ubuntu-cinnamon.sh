#!/bin/bash

# System install steps for display manager in Ubuntu 18.04

set -e

echo 'When prompted, choose "lightdm" as display manager'

apt install \
  cinnamon-desktop-environment \
  lightdm \
  lightdm-gtk-greeter

echo "writing /etc/lightdm/lightdm.conf"
echo -e "[SeatDefaults]\ngreeter-session=lightdm-gtk-greeter" > /etc/lightdm/lightdm.conf
