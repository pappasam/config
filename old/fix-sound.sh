#!/bin/bash

# do funky stuff to reset the drivers
sudo alsa force-reload
sudo apt-get remove --purge alsa-base pulseaudio
sudo apt-get install alsa-base pulseaudio
sudo alsa force-reload

# Wait two seconds
sleep 2

# shutdown the computer
sudo shutdown now

# wait a minute, then reboot the computer
# IMPORTANT
#   after you plug in your headphone jack, open the "Sound"
#   window in Linux Mint's GUI and select "Headphones built-in audio"
#   the sound should now work
