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
source "${HOME}/${DDD_PATH}/setup_scripts/config.ini"
if [[ ${DEBUG} == true ]]; then set -x -v; fi

################################################################################
# Prompt for installation type or to abort (to avoid borking system)
################################################################################
echo "Choose an option
-----------------------------
(1) abort:    Abort Installation
(2) virtual:  Install Virtual Kernel
(3) standard: Install Standard Kernel (physical hardware)

Danger!  Do you really want to continue?  Be aware this script destructively
loosens permissions for the current user, changes system settings, uninstalls
*many* applications, and installs *many* applications not supported by Cannonical
(the makers of Ubuntu).   This is much safer to do in a test environment (first),
such as a virtual machine (VM) inside VirtualBox.

Are you really, really, ... and I mean *really* sure you want to do this?"
INSTALLTYPE=

while [ "$INSTALLTYPE" != "abort" ] && [ "$INSTALLTYPE" != "virtual" ] && [ "$INSTALLTYPE" != "standard" ]; do
  read INSTALLTYPE
  case $INSTALLTYPE in
    "1" ) INSTALLTYPE="abort"
          ;;
    "2" ) INSTALLTYPE="virtual"
          ;;
    "3" ) INSTALLTYPE="standard"
          ;;
    * )   echo "\"$INSTALLTYPE\" is not a correct choice."
          ::
  esac
done

if [ "$INSTALLTYPE" == "abort" ]; then
  echo "Aborted. Nothing was changed."
  exit 1;
fi

#======================================| ok, lets do it
#======================================| SAVE INSTALLATION TYPE
echo "
# ################## START_USER_CONFIG
INSTALLTYPE=${INSTALLTYPE}" >> "${HOME}/${DDD_PATH}/setup_scripts/config.ini"

echo "This script can take a long time to run, plus multiple automated reboots.

Note: This script shouldn't be run more than once.

Press \"Enter\" to continue" &
read

#======================================| Disk size Accounting
# Starting size:
if [[ ${EXTRA_DEBUG_INFO} == true ]]; then
  df -h -T > "${HOME}/${DDD_PATH}/setup_scripts/logs/size-start.log"
fi
#======================================| Install/Update some basics
sudo apt-get ${APTGET_VERBOSE} install git wget curl

#======================================| Install Etckeeper to track config changes
if [[ "${INSTALL_ETCKEEPER}" == true ]]; then
  sudo apt-get ${APTGET_VERBOSE} install etckeeper
  #configure etckeeper to use git and avoid uneccesarry commits, then initialize
  sudo sed -i 's/#VCS="git"/VCS="git"/g'          /etc/etckeeper/etckeeper.conf
  sudo sed -i 's/VCS="bzr"/#VCS="bzr"/g'          /etc/etckeeper/etckeeper.conf
  sudo sed -i 's/#AVOID_DAILY_AUTOCOMMITS=1/AVOID_DAILY_AUTOCOMMITS=1/g'  /etc/etckeeper/etckeeper.conf
  sudo etckeeper init
fi
if [[ ${OVERRIDE_UBUNTU_SECURITY} == true ]]; then
  #======================================| The last password you'll ever need.
  # add current user to sudoers file - careful, this line could brick the box.
  clear
  echo "WARNING:  THIS WILL OVERRIDE DEFAULT UBUNTU SECURITY.  IF YOU DON'T WANT TO DO THIS, PRESS CTRL-C AND EDIT THE FILE: 'config.ini'

  THEN CHANGE
  from: OVERRIDE_UBUNTU_SECURITY=true
  to: OVERRIDE_UBUNTU_SECURITY=false

  Otherwise..."
  echo "${USER} ALL=(ALL) NOPASSWD: ALL" | sudo tee -a "/etc/sudoers.d/${DDD}" > /dev/null
  sudo chmod 0440 "/etc/sudoers.d/${DDD}"
  if [[ "${INSTALL_ETCKEEPER}" == true ]]; then
    sudo etckeeper commit "PERMISSIONS: ADD ${USER} to sudoers file - careful, this line could brick the box."
  fi

  # Add current user to root 'group' to make it easier to edit config files
  # note: seems unsafe for anyone unaware.
  sudo adduser $USER root
  if [[ "${INSTALL_ETCKEEPER}" == true ]]; then
    sudo etckeeper commit "PERMISSIONS: ADD ${USER} to group 'root' to make it easier to edit config files"
  fi
fi

stage_finished=0
exit "$stage_finished"
