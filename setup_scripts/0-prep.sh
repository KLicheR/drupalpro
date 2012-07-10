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


#======================================| Update Zenity (12.04 has a bug)
sudo apt-get ${APTGET_VERBOSE} install zenity

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

zenity --info --text="This script can take a long time to run, plus multiple automated reboots. At the end there are some manual steps, guided by popups like this.

Note: This script shouldn't be run more than once." &

#======================================| Disk size Accounting
# Starting size:
if [[ ${EXTRA_DEBUG_INFO} == true ]]; then
  df -h -T > "${HOME}/${DDD}/setup_scripts/logs/size-start.log"
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
if [[ ${INSTALL_FIREWALL} == true ]]; then
  #======================================| Install and setup Firewall  @TODO: isolate samba ports for bridged subnet
  sudo apt-get ${APTGET_VERBOSE} install gufw
  sudo ufw enable
  sudo ufw allow in proto tcp from any to any port 443
  sudo ufw allow in proto tcp from any to any port 80
fi
if [[ ${OVERRIDE_UBUNTU_SECURITY} == true ]]; then
  #======================================| The last password you'll ever need.
  # add current user to sudoers file - careful, this line could brick the box.
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
