#!/bin/bash
set -e

# ################################################################################ Import Variables
# Make sure you have edited this file
source "${HOME}/${DDD}/setup_scripts/CONFIG"
if [[ ${DEBUG} == TRUE ]]; then set -x; fi

# ################################################################################ SETUP KERNEL
if [ "${INSTALLTYPE}" == "virtual" ]
then
  # Remove the standard Kernel and install virtual kernel.
  # Should be less overhead (aka better performance) in Virtual environment.
  sudo apt-get -yq update
  sudo apt-get -yq purge linux-generic linux-headers-generic linux-image-generic linux-generic-pae  linux-image-generic-pae linux-headers-generic-pae linux-headers-3.2.0-23 linux-headers-3.2.0-23-generic-pae linux-image-3.2.0-23-generic-pae
  sudo apt-get -yq install linux-virtual linux-headers-virtual linux-image-virtual linux-image-extra-virtual
fi

## install guest additions

# dkms recommended on virtualbox.org for upgrade compatibility
sudo apt-get -yq install build-essential
sudo apt-get -yq install virtualbox-ose-guest-x11 virtualbox-ose-guest-dkms virtualbox-ose-guest-source
#if that doesnt work, try manual install per http://www.webupd8.org/2012/02/virtualbox-ubuntu-1204-guest-fixes.html

## Shared folders

# Setup shared folders between virtualbox host and virtualbox guest
# Note difference between shared and vbox-host.  That's important.  Requires reboot
sudo sed -i s|"# By default this script does nothing."|"mount -t vboxsf -o uid=1000,gid=1000 ${HOSTSHARE} /mnt/vbox-host"g  /etc/rc.local
sudo mkdir /mnt/vbox-host
sudo chmod ug=rwX,o= /mnt/vbox-host
cat > /mnt/vbox-host/readme.txt <<END
If you are seeing this file, then virtualbox's shared folders are not configured correctly.

1) Power down the Drupal Desktop virtual machine.
2) On the host computer, start the Virtualbox management UI.
3) right-click Drupal Desktop -> settings -> shared folders -> click the folder with the green plus on the right
4) Set the "Folder Path" to a path on the host computer.  Give full read/write access.
5) Set the "Folder Name" to "${HOSTSHARE}".  (lowercase.  no quotes. and not "vbox-host")
6) Ok -> Ok -> start Druapl Desktop VM and this file should disappear,
and you should have access to files on the host.
END
