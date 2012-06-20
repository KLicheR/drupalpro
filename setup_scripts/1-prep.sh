#!/bin/bash
set -e

# ################################################################################ Import Variables
# Make sure you have edited this file
source "${HOME}/${DDD}/setup_scripts/CONFIG"
if [[ ${DEBUG} == true ]]; then set -x; fi


# ################################################################################ Update Zenity (12.04 from debian has a bug)
sudo apt-get install zenity

# ################################################################################
# Prompt to give user a chance to abort to avoid accidentally borking their system
# ################################################################################
INSTALLTYPE=$(zenity \
  --list \
  --radiolist  \
  --hide-column=2 \
  --column "" true abort "Abort Installation" false virtual "Install Virtual Kernel" false standard "Install Standard Kernel (physical hardware)" \
  --column value \
  --column Description \
  --width=400 \
  --height=300 \
  --title="Danger!" \
  --text="\
Danger!  Do you really want to continue?  Be aware this script destructively
loosens permissions for the current user, changes system settings, uninstalls
*many* applications, and installs *many* applications not supported by Cannonical
(the makers of Ubuntu).   This is much safer to do in a test environment (first),
such as a virtual machine (VM) inside VirtualBox.

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
# SAVE INSTALLATION TYPE
echo "
# ################## START_USER_CONFIG
INSTALLTYPE=${INSTALLTYPE}" >> "${HOME}/${DDD}/setup_scripts/CONFIG"

zenity --info --text="This script may take hours to run (depending on your hardware and internet bandwidth), plus multiple automated reboots (which requires AUTOMATIC USER LOGIN for an unattended setup).

Towards the end, the process requires some manual steps, guided by popups like this. \nThis script shouldn't be run more than once.";

## The last password you'll ever need.
# add current user to sudoers file - careful, this line could brick the box.
echo "${USER} ALL=(ALL) NOPASSWD: ALL" | sudo tee -a "/etc/sudoers.d/${DDD}" > /dev/null
sudo chmod 440 "/etc/sudoers.d/${DDD}"

# ################################################################################ Install/Update some basics
sudo apt-get "${APTGET_VERBOSE}" install git wget curl

# Add current user to root 'group' to make it easier to edit config files
# note: seems unsafe for anyone unaware.
sudo adduser $USER root

## Disk size Accounting
# Starting size:
df -h -T > "~/${DDD}/setup_scripts/logs/size-start.log"
