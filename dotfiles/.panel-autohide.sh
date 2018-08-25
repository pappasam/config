#!/bin/bash

#######################################################################
# Script toggles whether panel is on or off

state=$(gsettings get org.cinnamon panels-autohide)
if [ $state = "['1:true']" ]; then
    gsettings set org.cinnamon panels-autohide "['1:false']"
else
    gsettings set org.cinnamon panels-autohide "['1:true']"
fi
