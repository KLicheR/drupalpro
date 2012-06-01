#!/bin/bash

# To install Quickstart Development Environment:
#
# 1) Open a terminal window in the virtual machine (Applications->Accessories->Terminal)
#
# 2) bash ~/quickstart/setup_scripts/install-quickstart.sh


# ################################################################################ Shorten prompt and set version
# echo "qs1204" | sudo tee /etc/hostname

# ################################################################################ Reboot functions
function reboot {
  # update .profile file to continue the next step of the script.
  echo "gnome-terminal -x bash -c \"~/quickstart/setup_scripts/install-quickstart.sh $1\" &" >> ~/.profile
  echo "*** REBOOTING ***" | tee -a ~/quickstart/setup_scripts/logs/quickstart-install.log
  echo "\n\n\n*** START REBOOT CYCLE: $1 ***" | tee -a ~/quickstart/setup_scripts/logs/quickstart-install.log
  sleep 2
  sudo reboot now
  exit
}

# Undo any previous reboot script
if [ -n "$1" ] ; then  # sleep if rebooted
  # @FIXME: change 'sleep 15' to actually test for active network connection before continuing
  echo "Reboot stage: $1  ... sleeping 15"; sleep 15
  sed -i 's/gnome-terminal -x bash -c/# deleteme /g' ~/.profile
fi

# ################################################################################ Install it!
# this switch statement handles reboots.
cd ~

case "$1" in
"")
  bash -x ~/quickstart/setup_scripts/1-prep.sh  2>&1 | tee -a ~/quickstart/setup_scripts/logs/quickstart-install.log
  UserAbort="$?"
  if [ "$UserAbort" -ne 0 ]; then  # if exit code not 0 then abort, otherwise continue and reboot
    zenity --info --text="Aborted.  Nothing was changed."
    exit
  else
      reboot 10
  fi
  ;;
"10")
  bash -x ~/quickstart/setup_scripts/1a-vbox-guest-additions.sh  2>&1 | tee -a ~/quickstart/setup_scripts/logs/quickstart-install.log
  reboot 20
  ;;
"20")
  bash -x ~/quickstart/setup_scripts/2-slim.sh  2>&1 | tee -a ~/quickstart/setup_scripts/logs/quickstart-install.log
  reboot 30
  ;;
"30")
  bash -x ~/quickstart/setup_scripts/2a-update.sh  2>&1 | tee -a ~/quickstart/setup_scripts/logs/quickstart-install.log
  reboot 40
  ;;
"40")
  bash -x ~/quickstart/setup_scripts/3-lamp.sh  2>&1 | tee -a ~/quickstart/setup_scripts/logs/quickstart-install.log
  bash -x ~/quickstart/setup_scripts/4-ides.sh  2>&1 | tee -a ~/quickstart/setup_scripts/logs/quickstart-install.log
  reboot 50
  ;;
"50")
  bash -x ~/quickstart/setup_scripts/extras_misc.sh  2>&1 | tee -a ~/quickstart/setup_scripts/logs/quickstart-install.log
  bash -x ~/quickstart/setup_scripts/extras_development.sh  2>&1 | tee -a ~/quickstart/setup_scripts/logs/quickstart-install.log
  bash -x ~/quickstart/setup_scripts/extras_theming.sh  2>&1 | tee -a ~/quickstart/setup_scripts/logs/quickstart-install.log
  reboot 70
  ;;
"70")
  bash -x ~/quickstart/setup_scripts/7-config.sh  2>&1 | tee -a ~/quickstart/setup_scripts/logs/quickstart-install.log
  bash -x ~/quickstart/setup_scripts/8-manualconfig.sh  2>&1 | tee -a ~/quickstart/setup_scripts/logs/quickstart-install.log
  ;;
*)
  echo " *** BAD BAD BAD SOMETHING WENT WRONG!  CALL A DOCTOR! *** "
  ;;
esac


