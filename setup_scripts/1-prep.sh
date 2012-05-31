#!/bin/bash

if ! $(zenity --question --title "Are you Crazy?" --text="Danger!  Do you really want to continue?  Be aware this script destructively loosens permissions for the current user, changes system settings, uninstalls *many* applications, and installs *many* applications not supported by Cannonical (the makers of Ubuntu).

Are you really, really, ... and I mean *really* sure you want to do this?")
then
  echo "aborting";
  exit -1;
else
zenity --info --text="This script may take hours to run (depending on your hardware and internet bandwidth), plus multiple automated reboots.

Towards the end, the process requires some manual steps, guided by popups like this. \nThis script shouldn't be run more than once.  NOTE:  This script should be run by user: quickstart -- and should be setup to allow automatic login upon reboot";


## The last password you'll ever need.
# add current user to sudoers file - careful, this line could brick the box.
echo "$USER ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers.d/quickstart > /dev/null
sudo chmod 440 /etc/sudoers.d/quickstart

# Add current user to root 'group' to make it easier to edit config files
# note: seems unsafe for anyone unaware.
sudo adduser $USER root


## Disk size Accounting
# Starting size:
df -h -T > ~/quickstart/setup_scripts/logs/quickstart-size-start.txt


## Some configuration
# turn off screen saver
gconftool-2 -s /apps/gnome-screensaver/idle_activation_enabled --type=bool false

# Install virtual kernel.  Better performance.
sudo apt-get -yq update
sudo apt-get -yq purge linux-generic linux-headers-generic linux-image-generic linux-generic-pae  linux-image-generic-pae linux-headers-generic-pae linux-headers-3.2.0-23 linux-headers-3.2.0-23-generic-pae linux-image-3.2.0-23-generic-pae
sudo apt-get -yq install linux-virtual linux-headers-virtual linux-image-virtual

fi
