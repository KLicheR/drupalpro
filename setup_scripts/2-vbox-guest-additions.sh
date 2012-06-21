#!/bin/bash
set -e

#======================================| Import Variables
# Make sure you have edited this file
source "${HOME}/${DDD}/setup_scripts/CONFIG"
if [[ ${DEBUG} == true ]]; then set -x -v; fi

#======================================| SETUP KERNEL
if [ "${INSTALLTYPE}" == "virtual" ]
then
  # Remove the standard Kernel and install virtual kernel.
  # Should be less overhead (aka better performance) in Virtual environment.
  sudo apt-get "${APTGET_VERBOSE}" update
  sudo apt-get "${APTGET_VERBOSE}" purge linux-generic linux-headers-generic linux-image-generic linux-generic-pae  linux-image-generic-pae linux-headers-generic-pae linux-headers-3.2.0-23 linux-headers-3.2.0-23-generic-pae linux-image-3.2.0-23-generic-pae
  sudo apt-get "${APTGET_VERBOSE}" install linux-virtual linux-headers-virtual linux-image-virtual linux-image-extra-virtual
fi

## install guest additions

# dkms recommended on virtualbox.org for upgrade compatibility
sudo apt-get "${APTGET_VERBOSE}" install build-essential
sudo apt-get "${APTGET_VERBOSE}" install virtualbox-ose-guest-x11 virtualbox-ose-guest-dkms virtualbox-ose-guest-source
#if that doesnt work, try manual install per http://www.webupd8.org/2012/02/virtualbox-ubuntu-1204-guest-fixes.html

## Shared folders

# Setup shared folders between virtualbox host and virtualbox guest
# Note difference between shared and vbox-host.  That's important.  Requires reboot
sudo sed -i 's|# By default this script does nothing.|mount -t vboxsf -o uid=1000,gid=1000 '"${HOSTSHARE} \/mnt\/${HOSTSHARE}"'|g'  /etc/rc.local
sudo mkdir /mnt/"${HOSTSHARE}"
sudo chmod ug=rwX,o= /mnt/"${HOSTSHARE}"
ln -s "/mnt/${HOSTSHARE}" ${HOME}/Desktop/shared
cat > "/mnt/${HOSTSHARE}/readme.txt" <<END
If you are seeing this file, then Virtualbox shared folders are not setup correctly.

1) Open the Devices menu (Virtualbox), and choose "Shared Folders..."
2) Choose: Add Shared folder.  (Insert key)
3) FOLDER PATH: Browse for a folder you'd like to access on the host.
4) FOLDER NAME: ${HOSTSHARE}
5) MAKE PERMANENT: checked, otherwise it'll create a transient folder and it won't work.
6) Choose Ok > Choose Ok > Finally, reboot the virtual machine

When completed correctly, this file will disappear and you'll have access to files on the host.
END
