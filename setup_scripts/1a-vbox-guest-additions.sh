#!/bin/bash
set -e

# ################################################################################ Import Variables
# Make sure you have edited this file
source ${HOME}/${DDD}/setup_scripts/CONFIG
if [[ ${DEBUG} == TRUE ]]; then set -x; fi

## install guest additions

# dkms recommended on virtualbox.org for upgrade compatibility
sudo apt-get -yq install build-essential
sudo apt-get -yq install virtualbox-ose-guest-x11 virtualbox-ose-guest-dkms virtualbox-ose-guest-source
#if that doesnt work, try manual install per http://www.webupd8.org/2012/02/virtualbox-ubuntu-1204-guest-fixes.html

## Shared folders

# Setup shared folders between virtualbox host and virtualbox guest
# Note difference between shared and vbox-shared.  That's important.  Requires reboot
sudo sed -i 's/# By default this script does nothing./mount -t vboxsf -o uid=1000,gid=1000 shared \/mnt\/vbox-shared/g'     /etc/rc.local
sudo mkdir /mnt/vbox-shared
sudo chmod 770 /mnt/vbox-shared
cat > /mnt/vbox-shared/readme.txt <<END
If you are seeing this file, then virtualbox's shared folders are not configured correctly.

1) Power down the Drupal Desktop virtual machine.
2) On the host computer, start the Virtualbox management UI.
3) right-click Drupal Desktop -> settings -> shared folders -> click the folder with the green plus on the right
4) Set the "Folder Path" to a path on the host computer.  Give full read/write access.
5) Set the "Folder Name" to "shared".  (lowercase.  no quotes. and not "vbox-shared")
6) Ok -> Ok -> start Druapl Desktop VM and this file should disappear,
and you should have access to files on the host.
END
