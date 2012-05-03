#!/bin/bash

zenity --info --text="These install scripts take several hours, and a couple automated reboots.

Towards the end, the process requires some manual steps, guided by popups like this.

This script shouldn't be run more than once."



## The last password you'll ever need.

# add to sudoers file - careful, this line could brick the box.

echo "quickstart ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers.d/quickstart > /dev/null
sudo chmod 440 /etc/sudoers.d/quickstart

## Disk size Accounting

# Starting size:
df -h -T > ~/quickstart/logs/quickstart-size-start.txt


## Some configuration

# turn off screen saver
gconftool-2 -s /apps/gnome-screensaver/idle_activation_enabled --type=bool false

