#!/bin/bash

# Install graphics editors - weights about 25mb
# sudo add-apt-repository ppa:otto-kesselgulasch/gimp
# setup gimp ppa
echo 'deb http://ppa.launchpad.net/otto-kesselgulasch/gimp/ubuntu precise main' | sudo tee -a /etc/apt/sources.list.d/otto-kesselgulasch-gimp-precise.list > /dev/null
echo 'deb-src http://ppa.launchpad.net/otto-kesselgulasch/gimp/ubuntu precise main' | sudo tee -a /etc/apt/sources.list.d/otto-kesselgulasch-gimp-precise.list > /dev/null
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 614C4B38
sudo apt-get update
sudo apt-get -yq install inkscape icc-profiles #install inkscape, + icc profiles

# Install compass (which needs ruby)
sudo apt-get -yq install ruby1.9.1
sudo gem1.9.1 install compass

# Install chrome browser (Webkit - fork of KHTML/Konquerer, also used by Safari)
# sudo apt-get -yq install chromium-browser
# sudo ln -s /usr/lib/flashplugin-installer/libflashplayer.so /usr/lib/chromium-browser/plugins/
