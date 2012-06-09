#!/bin/bash

FEBE_URL="https://dl.dropbox.com/u/6569361/quickstart/Quickstart1204.fbu"
REFERER="http://www.drupal.org/project/quickstart"
USERAGENT="Mozilla/5.0 (compatible; Konqueror/4.4; Linux 2.6.32-22-generic; X11; en_US) KHTML/4.4.3 (like Gecko) Kubuntu"
HEAD1="Accept: text/xml,application/xml,application/xhtml+xml,text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5"
HEAD2="Accept-Language: en-us,en;q=0.5"
HEAD3="Accept-Encoding: gzip,deflate"
HEAD4="Accept-Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.7"
HEAD5="Keep-Alive: 300"

# ##### Install some basics
sudo apt-get -yq install git
sudo apt-get -yq install wget curl
# add some useful git tools
sudo apt-get -yq install gitg meld git-gui gitk
# configure some nice git settings
git config --global color.ui true
git config --global core.whitespace trailing-space,tab-in-indent

# Install some useful utilities for developing & theming in Ubuntu
# Synaptic Xchat gnote compass guake (instant shell) gufw (GUI for firewall)
sudo apt-get install -yq synaptic xchat gnote guake gufw p7zip autokey-gtk bleachbit

# Whitelist autokey for Unity panel
if grep -q 'Autokey' <(echo `gsettings get com.canonical.Unity.Panel systray-whitelist`); then
  echo "'Autokey' already exists in the Unity panel whitelist. Nothing to do here.";
else echo "Adding 'Autokey' to Unity panel whitelist." && gsettings set com.canonical.Unity.Panel systray-whitelist "`echo \`gsettings get com.canonical.Unity.Panel systray-whitelist | tr -d ]\`,\'Autokey\']`"; fi

# Whitelist xchat for Unity panel
if grep -q 'xchat' <(echo `gsettings get com.canonical.Unity.Panel systray-whitelist`); then
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
wget -nv -O $HOME/Pictures/wallpaper1920x1200.png http://media.smashingmagazine.com/wp-content/uploads/uploader/images/drupal-cheat-sheet-wallpaper/wallpaper1920x1200.png
wget -nv -O $HOME/Pictures/drupal7_1920x1200.jpg http://www.quicklycode.com/wp-content/files/drupal7_1920x1200.jpg
wget -nv -O $HOME/Pictures/HTML5_Canvas_Cheat_Sheet.png http://www.nihilogic.dk/labs/canvas_sheet/HTML5_Canvas_Cheat_Sheet.png
wget -nv -O $HOME/Pictures/VI-Help-Sheet-01-large2.jpg http://media.smashingmagazine.com/wp-content/uploads/2010/05/VI-Help-Sheet-01-large2.jpg
gconftool -s /desktop/gnome/background/picture_filename --type=string "$HOME/Pictures/wallpaper1920x1200.png"
gsettings set org.gnome.desktop.background draw-background true
gsettings set org.gnome.desktop.background picture-opacity 100
gsettings set org.gnome.desktop.background picture-options 'stretched'
gsettings set org.gnome.desktop.background picture-uri 'file:///$HOME/Pictures/wallpaper1920x1200.png'



# Install flash-plugin browser
sudo apt-get -yq install flashplugin-installer

cd ~
wget -O Quickstart1204.fbu --referer="$REFERER" --user-agent="$USERAGENT" --header="$HEAD1" --header="$HEAD2" --header="$HEAD3" --header="$HEAD4" --header="$HEAD5" -dv $FEBE_URL
mv Quickstart1204.fbu profileFx4{default}.fbu

# Use firefox as default browser.  Chrome, I'm looking at you...
sudo update-alternatives --set gnome-www-browser /usr/bin/firefox
sudo update-alternatives --set x-www-browser /usr/bin/firefox

# gnome terminal
gconftool-2 -s /apps/gnome-terminal/profiles/Default/scrollback_lines --type=int 8192
