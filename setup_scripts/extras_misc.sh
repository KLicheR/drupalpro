#!/bin/bash

## Install java - 100mb
sudo apt-get -yq install default-jre

# Install some really useful utilities for developing & theming in Ubuntu
# Synaptic Xchat gnote compass guake (instant shell) gufw (GUI for firewall)
sudo apt-get install -yq synaptic xchat gnote geany guake gufw

# Install chrome browser (Webkit - fork of KHTML/Konquerer, also used by Safari)
sudo apt-get -yq install chromium-browser
sudo ln -s /usr/lib/flashplugin-installer/libflashplayer.so /usr/lib/chromium-browser/plugins/


# Install firefox browser (gecko)
sudo apt-get -yq install firefox flashplugin-installer

cd ~
wget -v http://dl.dropbox.com/u/6569361/quickstart/Quickstart1204.fbu
mv Quickstart1204.fbu profileFx4{default}.fbu

# Use firefox as default browser.  Chrome, I'm looking at you...
sudo update-alternatives --set gnome-www-browser /usr/bin/firefox
sudo update-alternatives --set x-www-browser /usr/bin/firefox
