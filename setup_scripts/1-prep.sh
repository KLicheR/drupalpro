#!/bin/bash

zenity --info --text="These install scripts may take several hours, and some automated reboots.

Towards the end, the process requires some manual steps, guided by popups like this.

This script shouldn't be run more than once.

NOTE:  This script should be run by user: quickstart -- and should be setup to allow automatic login upon reboot"



## The last password you'll ever need.

# add to sudoers file - careful, this line could brick the box.

echo "quickstart ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers.d/quickstart > /dev/null
sudo chmod 440 /etc/sudoers.d/quickstart

# Make quickstart a user of group root to edit config files
# note: seems unsafe for anyone unaware.  @FIXME -- add note to documentation
sudo adduser quickstart root


## Disk size Accounting

# Starting size:
df -h -T > ~/quickstart/setup_scripts/logs/quickstart-size-start.txt


## Some configuration

# turn off screen saver
gconftool-2 -s /apps/gnome-screensaver/idle_activation_enabled --type=bool false

# Install virtual kernel.  Better performance.
sudo apt-get -y remove linux-generic linux-headers-generic linux-generic-pae linux-headers-generic-pae
sudo apt-get -yq install linux-virtual linux-headers-virtual

