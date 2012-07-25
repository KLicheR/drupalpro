#!/bin/bash
set -e

#======================================| Import Variables
# Make sure you have edited this file
source "${HOME}/${DDD_PATH}/setup_scripts/config.ini"
if [[ ${DEBUG} == true ]]; then set -x -v; fi

# See also http://benhodge.wordpress.com/2008/02/17/cleaning-up-a-ubuntu-gnulinux-system/

# 0mb
sudo apt-get ${APTGET_VERBOSE} autoremove

if [ "${PURGE_OFFICE}" = true ]; then
  # 305mb - Libre Office
  sudo apt-get ${APTGET_VERBOSE} purge libreoffice-gnome  libreoffice-draw  libreoffice-help-en-us  libreoffice-style-tango  libreoffice-impress  libreoffice-math  libreoffice-gtk  libreoffice-common  uno-libs3  python-uno  libreoffice-style-human  ure  libreoffice-base-core  libreoffice-calc  libreoffice-emailmerge  libreoffice-core  libreoffice-writer
fi
if [ "${PURGE_GAMES}" = true ]; then
  #  18mb - Games
  sudo apt-get ${APTGET_VERBOSE} purge aisleriot gnome-sudoku mahjongg gnomine
fi
if [ "${PURGE_BLUETOOTH}" = true ]; then
  #   6mb - Bluetooth
  sudo apt-get ${APTGET_VERBOSE} purge bluez-alsa gir1.2-gnomebluetooth-1.0 bluez-gstreamer pulseaudio-module-bluetooth bluez-cups bluez gnome-bluetooth gnome-user-share
fi
if [ "${PURGE_MEDIA}" = true ]; then
  #  6.9mb - Shotwell photo manager
  sudo apt-get ${APTGET_VERBOSE} purge shotwell
  #   6mb - Example videos and stuff
  sudo apt-get ${APTGET_VERBOSE} purge example-content
  #   rhythymbox
  sudo apt-get ${APTGET_VERBOSE} purge rhythmbox rhythmbox-data rhythmbox-ubuntuone librhythmbox-core5 rhythmbox-plugin-magnatune gir1.2-rb-3.0 rhythmbox-mozilla rhythmbox-plugin-zeitgeist rhythmbox-plugin-cdrecorder rhythmbox-plugins
  #   Unity media lens
  sudo apt-get ${APTGET_VERBOSE} purge unity-lens-video unity-scope-video-remote unity-scope-musicstores unity-lens-music
fi
if [ "${PURGE_MISC}" = true ]; then
  #   422k - Screen savers
  sudo apt-get ${APTGET_VERBOSE} purge gnome-screensaver
  #  3.2mb - speech synthesis
  sudo apt-get ${APTGET_VERBOSE} purge espeak speech-dispatcher espeak-data libespeak1
  #   1.7mb - Bittorrent client
  sudo apt-get ${APTGET_VERBOSE} purge transmission-common transmission-gtk
  #   ubuntuone
  sudo apt-get ${APTGET_VERBOSE} purge ubuntuone-client-gnome ubuntuone-client-gnome gir1.2-ubuntuoneui-3.0 libsyncdaemon-1.0-1 ubuntuone-couch ubuntuone-control-panel libubuntuoneui-3.0-1
  #   remotedesktop
  sudo apt-get ${APTGET_VERBOSE} purge vino remmina-common remmina-plugin-rdp remmina-plugin-vnc remmina
  #   Etc
  sudo apt-get ${APTGET_VERBOSE} purge usb-creator-gtk checkbox-gtk jockey-common jockey-gtk #computer-janitor-gtk
fi
if [ "${PURGE_ASYNC_COMM}" = true ]; then
  #  Async communications: microblog client, email client
  sudo apt-get ${APTGET_VERBOSE} purge empathy empathy-common nautilus-sendto-empathy telepathy-indicator folks-common telepathy-logger telepathy-gabble telepathy-haze telepathy-idle telepathy-salut telepathy-mission-control-5
  sudo apt-get ${APTGET_VERBOSE} purge thunderbird thunderbird-globalmenu thunderbird-gnome-support evolution-data-server libfolks-eds25
fi
if [ "${PURGE_RT_COMM}" = true ]; then
  # Realtime Communications: IM, VOIP, & IRC
  sudo apt-get ${APTGET_VERBOSE} purge gwibber gwibber-service libgwibber-gtk2 gwibber-service-identica gwibber-service-twitter gwibber-service-facebook libgwibber2
fi
if [ "${PURGE_HELP}" = true ]; then
  # User guide
  sudo apt-get ${APTGET_VERBOSE} purge gnome-user-guide ubuntu-docs
fi
if [ "${PURGE_PRINT}" = true ]; then
  #  63mb - Printing
  sudo apt-get ${APTGET_VERBOSE} purge cups cups-bsd cups-client cups-common ghostscript ghostscript-x ghostscript-cups cups-driver-gutenprint python-cups system-config-printer-common system-config-printer-gnome system-config-printer-udev foo2zjs foomatic-db-engine foomatic-filters min12xxw openprinting-ppds pnm2ppa pxljr splix hplip-data hplip hpijs libcupsmime1 libcupsdriver1 libgutenprint2 libcupsppdc1
  # 15mb - Scanner drivers
  sudo apt-get ${APTGET_VERBOSE} purge sane-utils simple-scan libsane libsane-hpaio
fi
if [ "${PURGE_ACCESSIBILITY}" = true ]; then
  #  12MB - ACCESSIBILITY APPLICATIONS
  sudo apt-get ${APTGET_VERBOSE} purge gnome-orca gnome-accessibility-themes gnome-accessibility-themes-extras libgail-common qt-at-spi onboard
fi

sudo apt-get ${APTGET_VERBOSE} autoremove # autoremove is used to remove packages that were automatically installed to satisfy dependencies for other packages and are now no longer needed.
sudo apt-get ${APTGET_VERBOSE} clean # clean clears out the local repository of retrieved package files. It removes everything but the lock file from /var/cache/apt/archives/ and /var/cache/apt/archives/partial/.

# What's installed: slim-package-list.log
if [ "${EXTRA_DEBUG_INFO}" = true ]; then  # Slows setup.  Only need to do this in order to list installed packages and their size.
  for pkg in `dpkg --list | awk '/ii/ {print $2}'`; do echo -e "`dpkg --status $pkg | grep Installed-Size | awk '{print $2}'` \t\t $pkg" >> pkgs.tmp; done; sort -rg pkgs.tmp > ${HOME}/${DDD_PATH}/setup_scripts/slim-package-list.log; rm -f pkgs.tmp;
  echo "------------  -------------------" >> ${HOME}/${DDD_PATH}/setup_scripts/logs/slim-package-list.log
  echo "size(kb)         packagename" >> ${HOME}/${DDD_PATH}/setup_scripts/logs/slim-package-list.log


# Ending size
df -h -T > "${HOME}/${DDD_PATH}/setup_scripts/logs/size-slim.log"
fi

# To "unslim" try this (untested):
#   sudo apt-get -y --reinstall install ubuntu-desktop ubuntu-standard empathy bluez example-content
stage_finished=0
exit "$stage_finished"
