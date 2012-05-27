#!/bin/bash

# Install graphics editors - weights about 25mb
sudo apt-get update
sudo apt-get -yq install gimp inkscape icc-profiles #install gimp, inkscape, + icc profiles

# Install compass (which needs ruby)
sudo apt-get -yq install ruby1.9.1
sudo gem1.9.1 install compass

# Install chrome browser (Webkit - fork of KHTML/Konquerer, also used by Safari)
# sudo apt-get -yq install chromium-browser
# sudo ln -s /usr/lib/flashplugin-installer/libflashplayer.so /usr/lib/chromium-browser/plugins/
