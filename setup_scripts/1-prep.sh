#!/bin/bash
set -e
#======================================|
#
# THIS SCRIPT SETS UP ENVIRONMENT
#
# * Figure out environment
# * Update Zenity (due to bug in initial release of 12.04)
# * User:  What Type of Install? (Abort / Virtual Kernel / Standard Kernel)
# * Setup: $USER in sudoers and root group
# * Add: wget, git, and curl -- which are used by installation scripts
#
#======================================|

#======================================| Import Variables
# Make sure you have edited this file
source "${HOME}/${DDD}/setup_scripts/CONFIG"
if [[ ${DEBUG} == true ]]; then set -x -v; fi


c Update Zenity (12.04 has a bug)
sudo apt-get install zenity

################################################################################
# Prompt for installation type or to abort (to avoid borking system)
################################################################################
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
if [ "$INSTALLTYPE" == "abort" ]; then UserAbort=3; fi
if [ "$UserAbort" -eq 5 ]; then UserAbort=0; fi # @FIXME: reset to 0 because zenity has a bug & timeout disabled
if [ "$UserAbort" -ne 0 ]; then # if cancel button(1), choose abort(3), or timeout(5) then exit with code
  echo "Aborted: $UserAbort (key: cancel=1, abort=2, time out=5).  Nothing was changed."
  exit $UserAbort;
fi

#======================================| ok, lets do it
#======================================| SAVE INSTALLATION TYPE
echo "
# ################## START_USER_CONFIG
INSTALLTYPE=${INSTALLTYPE}" >> "${HOME}/${DDD}/setup_scripts/CONFIG"

zenity --info --text="This script may take hours to run (depending on your hardware and internet bandwidth), plus multiple automated reboots (which requires AUTOMATIC USER LOGIN for an unattended setup).

Towards the end, the process requires some manual steps, guided by popups like this. \nThis script shouldn't be run more than once.";

## The last password you'll ever need.
# add current user to sudoers file - careful, this line could brick the box.
echo "${USER} ALL=(ALL) NOPASSWD: ALL" | sudo tee -a "/etc/sudoers.d/${DDD}" > /dev/null
sudo chmod 440 "/etc/sudoers.d/${DDD}"

#======================================| Install/Update some basics
sudo apt-get "${APTGET_VERBOSE}" install git wget curl

# Add current user to root 'group' to make it easier to edit config files
# note: seems unsafe for anyone unaware.
sudo adduser $USER root

## Disk size Accounting
# Starting size:
if [[ ${EXTRA_DEBUG_INFO} == true ]]; then
  df -h -T > "${HOME}/${DDD}/setup_scripts/logs/size-start.log"
fi
