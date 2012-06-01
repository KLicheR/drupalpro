#!/bin/bash

## Prompt to give user a chance to abort to avoid borking their system
INSTALLTYPE=$(zenity \
  --list \
  --radiolist  \
  --hide-column=2 \
  --column "" TRUE abort "Abort Installation" FALSE virtual "Install Virtual Kernel" FALSE standard "Install Standard Kernel (physical hardware)" \
  --column value \
  --column Description \
  --width=400 \
  --height=300 \
  --title="Danger!" \
  --text="\
Danger!  Do you really want to continue?  Be aware this script destructively
loosens permissions for the current user, changes system settings, uninstalls
*many* applications, and installs *many* applications not supported by Cannonical
(the makers of Ubuntu).

Are you really, really, ... and I mean *really* sure you want to do this?" \
)

UserAbort=$?
if [ "$INSTALLTYPE" == "abort" ]; then UserAbort=2; fi
if [ "$UserAbort" -eq 5 ]; then UserAbort=0; fi # reset to 0 because zenity has a bug & timeout disabled
if [ "$UserAbort" -ne 0 ]; then # if cancel button(1), choose abort(2), or timeout(5) then exit with code
  echo "Aborted: $UserAbort (key: cancel=1, abort=2, time out=5).  Nothing was changed."
  exit $UserAbort;
fi

# ok, lets do it
zenity --question --text="This script may take hours to run (depending on your hardware and internet bandwidth), plus multiple automated reboots (which requires AUTOMATIC USER LOGIN for an unattended setup).

Towards the end, the process requires some manual steps, guided by popups like this. \nThis script shouldn't be run more than once.";

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

if [ "$INSTALLTYPE" == "virtual" ]
then
  # Remove the standard Kernel and install virtual kernel.
  # Should be less overhead (aka better performance) in Virtual environment.
  sudo apt-get -yq update
  sudo apt-get -yq purge linux-generic linux-headers-generic linux-image-generic linux-generic-pae  linux-image-generic-pae linux-headers-generic-pae linux-headers-3.2.0-23 linux-headers-3.2.0-23-generic-pae linux-image-3.2.0-23-generic-pae
  sudo apt-get -yq install linux-virtual linux-headers-virtual linux-image-virtual
fi
