#!/bin/bash

## Install java - 100mb
sudo apt-get -yq install default-jre

# Install some really useful utilities for developing & theming in Ubuntu
# Synaptic Xchat gnote compass guake (instant shell) gufw (GUI for firewall)
sudo apt-get install -yq synaptic xchat gnote guake gufw p7zip

# Install Cheatsheet Wallpaper
wget -nv -O $HOME/quickstart/config/wallpaper1920x1200.png http://media.smashingmagazine.com/wp-content/uploads/uploader/images/drupal-cheat-sheet-wallpaper/wallpaper1920x1200.png
gconftool-2 -s /desktop/gnome/background/picture_filename --type=string "$HOME/quickstart/config/wallpaper1920x1200.png"

# Install chrome browser (Webkit - fork of KHTML/Konquerer, also used by Safari)
sudo apt-get -yq install chromium-browser
sudo ln -s /usr/lib/flashplugin-installer/libflashplayer.so /usr/lib/chromium-browser/plugins/

# Install flash-plugin browser
sudo apt-get -yq install flashplugin-installer

cd ~
wget -nv http://dl.dropbox.com/u/6569361/quickstart/Quickstart1204.fbu
mv Quickstart1204.fbu profileFx4{default}.fbu

# Use firefox as default browser.  Chrome, I'm looking at you...
sudo update-alternatives --set gnome-www-browser /usr/bin/firefox
sudo update-alternatives --set x-www-browser /usr/bin/firefox

# gnome terminal
gconftool-2 -s /apps/gnome-terminal/profiles/Default/scrollback_lines --type=int 8192
