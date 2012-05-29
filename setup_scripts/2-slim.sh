#!/bin/bash

# See also http://benhodge.wordpress.com/2008/02/17/cleaning-up-a-ubuntu-gnulinux-system/

# 0mb
sudo apt-get -yq autoremove

# 305mb - Libre Office
sudo apt-get -yq purge libreoffice-gnome  libreoffice-draw  libreoffice-help-en-us  libreoffice-style-tango  libreoffice-impress  libreoffice-math  libreoffice-gtk  libreoffice-common  uno-libs3  python-uno  libreoffice-style-human  ure  libreoffice-base-core  libreoffice-calc  libreoffice-emailmerge  libreoffice-core  libreoffice-writer
#  18mb - Games
sudo apt-get -yq purge aisleriot gnome-sudoku mahjongg gnomine
#  12mb - Accessability
#mdrmike @FIXME:(purge) |seems wrong to remove sudo apt-get -yq purge gnome-orca gnome-mag brltty brltty-x11 onboard
#   422k - Screen savers
sudo apt-get -yq purge gnome-screensaver
# 61mb - User guide
#mdrmike @FIXME:(purge) |keep help sudo apt-get -yq purge gnome-user-guide ubuntu-docs
#   6mb - Bluetooth
sudo apt-get -yq purge bluez-alsa gir1.2-gnomebluetooth-1.0 bluez-gstreamer pulseaudio-module-bluetooth bluez-cups bluez gnome-bluetooth gnome-user-share
#  3.2mb - speech synthesis
sudo apt-get -yq purge espeak speech-dispatcher espeak-data libespeak1
#  67.5mb - social, IM, mail
sudo apt-get -yq purge telepathy-indicator folks-common telepathy-logger telepathy-gabble gwibber-service-identica thunderbird telepathy-haze empathy-common gwibber-service-twitter gwibber-service-facebook telepathy-idle empathy telepathy-salut libgwibber2 gwibber-service libfolks-eds25 thunderbird-globalmenu thunderbird-gnome-support gwibber libgwibber-gtk2 nautilus-sendto-empathy telepathy-mission-control-5
#  63mb - Printing
#mdrmike @FIXME:(purge) |too useful sudo apt-get -yq purge cups cups-bsd cups-client cups-common ghostscript ghostscript-x ghostscript-cups cups-driver-gutenprint python-cups system-config-printer-common system-config-printer-gnome system-config-printer-udev foo2zjs foomatic-db-engine foomatic-filters min12xxw openprinting-ppds pnm2ppa pxljr splix hplip-data hplip hpijs libcupsmime1 libcupsdriver1 libgutenprint2 libcupsppdc1
# 15mb - Scanner drivers
#mdrmike @FIXME:(purge) |too integrated with printing sudo apt-get -yq purge sane-utils simple-scan libsane libsane-hpaio
#  6.9mb - Shotwell photo manager
sudo apt-get -yq purge shotwell
#   8mb - Fancy GUI Compiz
#mdrmike @FIXME:(purge) |too entwined with unity sudo apt-get -yq purge compiz compiz-core compiz-gnome compiz-plugins compizconfig-backend-gconf libcompizconfig0 libdecoration0
#   6mb - Example videos and stuff
sudo apt-get -yq purge example-content
#   - Video drivers
#mdrmike @FIXME:(purge) |too entwined with unity sudo apt-get -yq purge nvidia-common libgl1-mesa-dri
  #removes ubuntu-desktop :(
#    - Video Drivers
#mdrmike @FIXME:(purge) |too entwined with unity sudo apt-get -yq purge xserver-xorg-video-all xserver-xorg-video-apm xserver-xorg-video-ark xserver-xorg-video-ati xserver-xorg-video-chips xserver-xorg-video-cirrus xserver-xorg-video-geode xserver-xorg-video-i128 xserver-xorg-video-i740 xserver-xorg-video-intel xserver-xorg-video-mach64 xserver-xorg-video-mga xserver-xorg-video-neomagic xserver-xorg-video-nv xserver-xorg-video-openchrome xserver-xorg-video-r128 xserver-xorg-video-radeon xserver-xorg-video-rendition xserver-xorg-video-s3 xserver-xorg-video-s3virge xserver-xorg-video-savage xserver-xorg-video-siliconmotion xserver-xorg-video-sis xserver-xorg-video-sisusb xserver-xorg-video-tdfx xserver-xorg-video-trident xserver-xorg-video-tseng xserver-xorg-video-vmware xserver-xorg-video-voodoo
#   1.7mb - Bittorrent client
sudo apt-get -yq purge transmission-common transmission-gtk
#   2mb - Laptop stuff
#mdrmike @FIXME:(purge) |not worth losing gnome-desktop sudo apt-get -yq purge gnome-power-manager wireless-tools
#   11mb - ubuntuone, rhythymbox, remotedesktop
sudo apt-get -yq purge gir1.2-rb-3.0 gir1.2-ubuntuoneui-3.0 rhythmbox-data ubuntuone-client ubuntuone-couch unity-lens-video ubuntuone-installer unity-scope-video-remote rhythmbox unity-scope-musicstores rhythmbox-plugin-magnatune ubuntuone-control-panel librhythmbox-core5 unity-lens-music rhythmbox-ubuntuone libsyncdaemon-1.0-1 vino remmina-common rhythmbox-mozilla libubuntuoneui-3.0-1 remmina-plugin-rdp rhythmbox-plugin-zeitgeist remmina-plugin-vnc ubuntuone-client-gnome rhythmbox-plugin-cdrecorder rhythmbox-plugins remmina
#   5mb - Etc
sudo apt-get -yq purge usb-creator-gtk checkbox-gtk ubuntuone-client-gnome jockey-gtk computer-janitor-gtk
#   2mb - Etc Etc
#mdrmike @FIXME:(purge) |sudo apt-get -yq purge xserver-xorg-input-all xserver-xorg-input-synaptics xserver-xorg-input-wacom #touchpad .5mb
#mdrmike @FIXME:(purge) |sudo apt-get -yq purge nvidia-96-modaliases nvidia-173-modaliases # graphics card detection .1mb
#mdrmike @FIXME:(purge) |sudo apt-get -yq purge eog #graphic viewer 1.6mb

# 0mb
sudo apt-get -yq autoremove
# Clean out downloaded packages
sudo apt-get -yq clean

# What's installed: look in file whats_installed.txt
for pkg in `dpkg --list | awk '/ii/ {print $2}'`; do echo -e "`dpkg --status $pkg | grep Installed-Size | awk '{print $2}'` \t\t $pkg" >> pkgs.tmp; done; sort -rg pkgs.tmp > ~/quickstart/setup_scripts/quickstart-slim-package-list.txt; rm -f pkgs.tmp;
echo "------------  -------------------" >> ~/quickstart/setup_scripts/logs/quickstart-slim-package-list.txt
echo "size(kb)         packagename" >> ~/quickstart/setup_scripts/logs/quickstart-slim-package-list.txt

# Ending size
df -h -T > ~/quickstart/setup_scripts/logs/quickstart-size-slim.txt

# 3.0gb -> 2.2gb

# To "unslim" try this (untested, and written for 9.04):
#   sudo apt-get -yq install ubuntu-desktop ubuntu-standard
#   sudo apt-get -yq install xserver-xorg-input-all xserver-xorg-video-all nvidia-common
#   sudo apt-get -yq install ubuntu-restricted-extras
