#!/bin/bash

# See here for list of browsers and rendering engines http://en.wikipedia.org/wiki/List_of_web_browsers

# Use PPA's to get most recent versions of browsers on apt-get upgrade
## Chrome
#wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
#sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
#sudo apt-get install epiphany-browser


## Synaptic Xchat gnote compass guake (instant shell) gufw (GUI for firewall)
sudo apt-get install -yq synaptic xchat gnote ruby1.9.1 geany guake gufw
sudo gem1.9.1 install compass



## Firefox
# sudo add-apt-repository ppa:mozillateam/ppa #not working 2011-05-25


# Install chrome browser (Webkit - fork of KHTML/Konquerer, also used by Safari)
sudo apt-get -yq install chromium-browser
sudo ln -s /usr/lib/flashplugin-installer/libflashplayer.so /usr/lib/chromium-browser/plugins/


# Install firefox browser (gecko)
sudo apt-get -yq install firefox flashplugin-installer

cd ~
wget -nv http://dl.dropbox.com/u/6569361/quickstart/Quickstart1204.fbu
mv Quickstart1204.fbu profileFx4{default}.fbu

#zenity --info --text="Firefox will start (creating default profile).\n\nPlease CLOSE FIREFOX. " &
firefox

firefox -CreateProfile temp

#zenity --info --text="Firefox will start.\n\n1) Please install the FEBE backup extension.\n2) Then CLOSE FIREFOX." &
zenity --info --text="Firefox will start.\n\n1) Please install the FEBE backup extension.\n2) Tools -> FEBE -> Restore profile.\n3) Click 'default' in list (create if it's not there).\n4) Select button at bottom 'Restore local backup'.\n5) Choose file: ~/profileFx4{default}.fbu.\n6) Start profile restore.\n7) Ok, ok, then CLOSE FIREFOX" &

#firefox -P temp https://addons.mozilla.org/en-US/firefox/downloads/latest/2109/addon-2109-latest.xpi?src=addondetail
firefox -P temp http://softwarebychuck.com/xpis/FEBE7.0.3.3.xpi

zenity --info --text="Firefox profile manager will start.\n1) Delete temp profile.\n2) THEN CLOSE MANAGER." &
firefox -ProfileManager
rm profileFx4{default}.fbu

# Use firefox as default browser.  Chrome, I'm looking at you...
sudo update-alternatives --set gnome-www-browser /usr/bin/firefox
sudo update-alternatives --set x-www-browser /usr/bin/firefox
