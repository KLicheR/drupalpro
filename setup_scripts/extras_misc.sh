#!/bin/bash
set -e

# ################################################################################ Import Variables
# Make sure you have edited this file
source "${HOME}/${DDD}/setup_scripts/CONFIG"
if [[ ${DEBUG} == true ]]; then set -x -v; fi

# add some useful git tools
sudo apt-get "${APTGET_VERBOSE}" install gitg meld git-gui gitk
# configure some nice git settings
git config --global color.ui true
git config --global core.whitespace trailing-space,tab-in-indent

# Install some useful utilities for developing & theming in Ubuntu
# Synaptic Xchat gnote compass guake (instant shell) gufw (GUI for firewall)
sudo apt-get install -yq synaptic xchat gnote guake gufw p7zip autokey-gtk bleachbit ardesia

# Whitelist autokey for Unity panel
if grep -iq 'autokey-gtk' <(echo `gsettings get com.canonical.Unity.Panel systray-whitelist`); then
  echo "'Autokey' already exists in the Unity panel whitelist. Nothing to do here.";
else echo "Adding 'Autokey' to Unity panel whitelist." && gsettings set com.canonical.Unity.Panel systray-whitelist "`echo \`gsettings get com.canonical.Unity.Panel systray-whitelist | tr -d ]\`,\'autokey-gtk\']`"; fi

# Whitelist xchat for Unity panel
if grep -iq 'xchat' <(echo `gsettings get com.canonical.Unity.Panel systray-whitelist`); then
  echo "'xchat' already exists in the Unity panel whitelist. Nothing to do here.";
else echo "Adding 'xchat' to Unity panel whitelist." && gsettings set com.canonical.Unity.Panel systray-whitelist "`echo \`gsettings get com.canonical.Unity.Panel systray-whitelist | tr -d ]\`,\'xchat\']`"; fi

#Setup Firewall
sudo ufw enable
sudo ufw allow in proto tcp from any to any port 443
sudo ufw allow in proto tcp from any to any port 80

#Set default values for guake
gconftool -s /apps/guake/keybindings/global/show_hide --type=string "F4"
gconftool -s /apps/guake/general/history_size --type=int 8192
gconftool -s /apps/guake/style/background/transparency --type=int 10
gconftool -s /apps/guake/general/window_losefocus --type=bool true

# Install Cheatsheet Wallpaper
wget "${WGET_VERBOSE}" -O "${HOME}/Pictures/${CHEAT1##*/}" --referer="${REFERER}" --user-agent="${USERAGENT}" --header="${HEAD1}" --header="${HEAD2}" --header="${HEAD3}" --header="${HEAD4}" --header="${HEAD5}" "${CHEAT1}"
wget "${WGET_VERBOSE}" -O "${HOME}/Pictures/${CHEAT2##*/}" --referer="${REFERER}" --user-agent="${USERAGENT}" --header="${HEAD1}" --header="${HEAD2}" --header="${HEAD3}" --header="${HEAD4}" --header="${HEAD5}" "${CHEAT2}"
wget "${WGET_VERBOSE}" -O "${HOME}/Pictures/${CHEAT3##*/}" --referer="${REFERER}" --user-agent="${USERAGENT}" --header="${HEAD1}" --header="${HEAD2}" --header="${HEAD3}" --header="${HEAD4}" --header="${HEAD5}" "${CHEAT3}"
wget "${WGET_VERBOSE}" -O "${HOME}/Pictures/${CHEAT4##*/}" --referer="${REFERER}" --user-agent="${USERAGENT}" --header="${HEAD1}" --header="${HEAD2}" --header="${HEAD3}" --header="${HEAD4}" --header="${HEAD5}" "${CHEAT4}"
wget "${WGET_VERBOSE}" -O "${HOME}/Pictures/${CHEAT5##*/}" --referer="${REFERER}" --user-agent="${USERAGENT}" --header="${HEAD1}" --header="${HEAD2}" --header="${HEAD3}" --header="${HEAD4}" --header="${HEAD5}" "${CHEAT5}"

# Setup desktop
background_pic="${CHEAT1##*/}"
gconftool -s /desktop/gnome/background/picture_filename --type=string "${HOME}/Pictures/${background_pic}"
gsettings set org.gnome.desktop.background primary-color '#adad7f7fa8a7'
gsettings set org.gnome.desktop.background draw-background true
gsettings set org.gnome.desktop.background picture-opacity 100
gsettings set org.gnome.desktop.background picture-options 'stretched'
gsettings set org.gnome.desktop.background picture-uri "file:///${HOME}/Pictures/${background_pic}"
gsettings set org.gnome.desktop.background secondary-color '#201f4a4a8787'
gsettings set org.gnome.desktop.background color-shading-type 'horizontal'
# to monitor changes, use this:  gsettings monitor org.gnome.desktop.background


# Install flash-plugin browser
sudo apt-get "${APTGET_VERBOSE}" install flashplugin-installer

wget "${WGET_VERBOSE}" -O ${HOME}/profileFx4{ddd}.fbu --referer="${REFERER}" --user-agent="${USERAGENT}" --header="${HEAD1}" --header="${HEAD2}" --header="${HEAD3}" --header="${HEAD4}" --header="${HEAD5}" "${FEBE_URL}"
