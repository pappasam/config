# Install Firefox Beta on Ubuntu 18.2

sudo add-apt-repository ppa:mozillateam/firefox-next
sudo apt update
sudo apt upgrade

# Add text to file:
# /etc/apt/preferences.d/firefox.pref
# -----------------------------------
# Package: firefox
# Pin: origin ppa.launchpad.net
# Pin-Priority: 900
#
# Package: firefox
# Pin: release o=Ubuntu
# Pin-Priority: 900
# -----------------------------------
