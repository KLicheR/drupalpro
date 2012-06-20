#!/bin/bash
set -e

# ################################################################################ Import Variables
# Make sure you have edited this file
source "${HOME}/${DDD}/setup_scripts/CONFIG"
if [[ ${DEBUG} == true ]]; then set -x; fi

# See also http://benhodge.wordpress.com/2008/02/17/cleaning-up-a-ubuntu-gnulinux-system/

# 0mb
sudo apt-get "${APTGET_VERBOSE}" autoremove

# 305mb - Libre Office
sudo apt-get "${APTGET_VERBOSE}" purge libreoffice-gnome  libreoffice-draw  libreoffice-help-en-us  libreoffice-style-tango  libreoffice-impress  libreoffice-math  libreoffice-gtk  libreoffice-common  uno-libs3  python-uno  libreoffice-style-human  ure  libreoffice-base-core  libreoffice-calc  libreoffice-emailmerge  libreoffice-core  libreoffice-writer
#  18mb - Games
sudo apt-get "${APTGET_VERBOSE}" purge aisleriot gnome-sudoku mahjongg gnomine
#   422k - Screen savers
sudo apt-get "${APTGET_VERBOSE}" purge gnome-screensaver
# 61mb - User guide
#mdrmike @FIXME:(purge) |keep help sudo apt-get "${APTGET_VERBOSE}" purge gnome-user-guide ubuntu-docs
#   6mb - Bluetooth
sudo apt-get "${APTGET_VERBOSE}" purge bluez-alsa gir1.2-gnomebluetooth-1.0 bluez-gstreamer pulseaudio-module-bluetooth bluez-cups bluez gnome-bluetooth gnome-user-share
#  3.2mb - speech synthesis
sudo apt-get "${APTGET_VERBOSE}" purge espeak speech-dispatcher espeak-data libespeak1
#  67.5mb - social, IM, mail
sudo apt-get "${APTGET_VERBOSE}" purge telepathy-indicator folks-common telepathy-logger telepathy-gabble gwibber-service-identica thunderbird telepathy-haze empathy-common gwibber-service-twitter gwibber-service-facebook telepathy-idle empathy telepathy-salut libgwibber2 gwibber-service libfolks-eds25 thunderbird-globalmenu thunderbird-gnome-support gwibber libgwibber-gtk2 nautilus-sendto-empathy telepathy-mission-control-5
#  63mb - Printing
#mdrmike @FIXME:(purge) |too useful sudo apt-get "${APTGET_VERBOSE}" purge cups cups-bsd cups-client cups-common ghostscript ghostscript-x ghostscript-cups cups-driver-gutenprint python-cups system-config-printer-common system-config-printer-gnome system-config-printer-udev foo2zjs foomatic-db-engine foomatic-filters min12xxw openprinting-ppds pnm2ppa pxljr splix hplip-data hplip hpijs libcupsmime1 libcupsdriver1 libgutenprint2 libcupsppdc1
# 15mb - Scanner drivers
#mdrmike @FIXME:(purge) |too integrated with printing sudo apt-get "${APTGET_VERBOSE}" purge sane-utils simple-scan libsane libsane-hpaio
#  6.9mb - Shotwell photo manager
sudo apt-get "${APTGET_VERBOSE}" purge shotwell
#   8mb - Fancy GUI Compiz
#mdrmike @FIXME:(purge) |too entwined with unity sudo apt-get "${APTGET_VERBOSE}" purge compiz compiz-core compiz-gnome compiz-plugins compizconfig-backend-gconf libcompizconfig0 libdecoration0
#   6mb - Example videos and stuff
sudo apt-get "${APTGET_VERBOSE}" purge example-content
#   1.7mb - Bittorrent client
sudo apt-get "${APTGET_VERBOSE}" purge transmission-common transmission-gtk
#   11mb - ubuntuone, rhythymbox, remotedesktop
sudo apt-get "${APTGET_VERBOSE}" purge gir1.2-rb-3.0 gir1.2-ubuntuoneui-3.0 rhythmbox-data ubuntuone-couch unity-lens-video ubuntuone-installer unity-scope-video-remote rhythmbox unity-scope-musicstores rhythmbox-plugin-magnatune ubuntuone-control-panel librhythmbox-core5 unity-lens-music rhythmbox-ubuntuone libsyncdaemon-1.0-1 vino remmina-common rhythmbox-mozilla libubuntuoneui-3.0-1 remmina-plugin-rdp rhythmbox-plugin-zeitgeist remmina-plugin-vnc ubuntuone-client-gnome rhythmbox-plugin-cdrecorder rhythmbox-plugins remmina
#   5mb - Etc
sudo apt-get "${APTGET_VERBOSE}" purge usb-creator-gtk checkbox-gtk ubuntuone-client-gnome jockey-gtk #computer-janitor-gtk

# 0mb
sudo apt-get "${APTGET_VERBOSE}" autoremove # autoremove is used to remove packages that were automatically installed to satisfy dependencies for other packages and are now no longer needed.
sudo apt-get "${APTGET_VERBOSE}" clean # clean clears out the local repository of retrieved package files. It removes everything but the lock file from /var/cache/apt/archives/ and /var/cache/apt/archives/partial/.

# What's installed: slim-package-list.log
if [ "${EXTRAINFO}" = true ]; then  # Slows setup.  Only need to do this in order to list installed packages and their size.
  for pkg in `dpkg --list | awk '/ii/ {print $2}'`; do echo -e "`dpkg --status $pkg | grep Installed-Size | awk '{print $2}'` \t\t $pkg" >> pkgs.tmp; done; sort -rg pkgs.tmp > ~/$DDD/setup_scripts/slim-package-list.log; rm -f pkgs.tmp;
  echo "------------  -------------------" >> ~/$DDD/setup_scripts/logs/slim-package-list.log
  echo "size(kb)         packagename" >> ~/$DDD/setup_scripts/logs/slim-package-list.log
fi

# Ending size
df -h -T > "${HOME}/${DDD}/setup_scripts/logs/size-slim.log"

# 3.0gb -> 2.2gb

# To "unslim" try this (untested, and written for 9.04):
#   sudo apt-get "${APTGET_VERBOSE}" install ubuntu-desktop ubuntu-standard
#   sudo apt-get "${APTGET_VERBOSE}" install xserver-xorg-input-all xserver-xorg-video-all nvidia-common
#   sudo apt-get "${APTGET_VERBOSE}" install ubuntu-restricted-extras
