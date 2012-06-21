#!/bin/bash
set -e

# See README.txt for more information
#
#     To install Drupal Development Desktop:
#
#     1) Open a terminal window in the virtual machine (Applications->Accessories->Terminal)
#     2) bash ${HOME}/${DDD}/setup_scripts/install.sh
#


# ################################################################################ Import Variables
# Make sure you have edited this file
# CWD based on http://stackoverflow.com/questions/59895/can-a-bash-script-tell-what-directory-its-stored-in
CWD="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "${CWD}"/CONFIG
if [[ ${DEBUG} == true ]]; then set -x -v; fi


# ################################################################################ Reboot functions
function reboot {
  # update .profile file to continue the next step of the script.
  echo "gnome-terminal -x bash -c \"${HOME}/${DDD}/setup_scripts/install.sh $1\" &" >> ${HOME}/.profile
  echo "*** REBOOTING ***" | tee -a ${HOME}/${DDD}/setup_scripts/logs/install.log
  echo "

  *** START REBOOT CYCLE: $1 ***" | tee -a ${HOME}/${DDD}/setup_scripts/logs/install.log
  if [[ ${AUTOREBOOT} == true ]]; then
    if [[ ${DEBUG} == true ]]; then
      echo "Allow time to interrupt reboot"
      sleep 10
    fi
  sudo reboot now
  fi
  exit
}

# Undo any previous reboot script
if [ -n "$1" ] ; then  # sleep if rebooted
  echo "Reboot stage: $1"
  sed -i 's/gnome-terminal -x bash -c/# deleteme /g' ${HOME}/.profile
fi

# ################################################################################ Test for network
# if rebooting, short delay for environment to setup
# @FIXME: better to test, but this is poormans solution for now
if [ ! -z $1 ]; then sleep 5; fi

# Test for connection
echo -n "`date +"%Y/%m/%d %H:%M:%S"`: testing for internet connection."
until [  ${PINGRESULTS} -lt 1 ]; do
  if ((ping -w5 -c2 ${PINGHOST1} || ping -w5 -c2 ${PINGHOST2}) > /dev/null 2>&1);
  then
    echo "

We are soooo connected!"
    PINGRESULTS=0
  else
    echo -n "."
    sleep 4
  fi
done



# ################################################################################ Install it!
# this switch statement handles reboots.
cd

case "$1" in
"")
  ${HOME}/${DDD}/setup_scripts/1-prep.sh  2>&1 | tee -a ${HOME}/${DDD}/setup_scripts/logs/install.log
  LAST_CMD=$_
  EXIT_CODE=$?
  ((if [[ "$EXIT_CODE" -eq 1 ]]; then echo "ERROR: Last command: $LAST_CMD"; echo "Error Code: $EXIT_CODE"; fi) 2>&1 ) | tee -a ${HOME}/${DDD}/setup_scripts/logs/install.log
  if [[ "$EXIT_CODE" -eq 1 ]] || [[ "$EXIT_CODE" -eq 3 ]] || [[ "$EXIT_CODE" -eq 5 ]]
  then  # if exit code not 0 then abort, otherwise continue and reboot
    zenity --info --text='Aborted.  Nothing was changed. '

    exit
  else
      ${HOME}/${DDD}/setup_scripts/2-slim.sh  2>&1 | tee -a ${HOME}/${DDD}/setup_scripts/logs/install.log
      LAST_CMD=$_
      EXIT_CODE=$?
      ((if [[ "$EXIT_CODE" -eq 1 ]]; then echo "ERROR: Last command: $LAST_CMD"; echo "Error Code: $EXIT_CODE"; fi) 2>&1 ) | tee -a ${HOME}/${DDD}/setup_scripts/logs/install.log
      reboot 10
  fi
  ;;
"10")
  ${HOME}/${DDD}/setup_scripts/1a-vbox-guest-additions.sh  2>&1 | tee -a ${HOME}/${DDD}/setup_scripts/logs/install.log
  LAST_CMD=$_
  EXIT_CODE=$?
  ((if [[ "$EXIT_CODE" -eq 1 ]]; then echo "ERROR: Last command: $LAST_CMD"; echo "Error Code: $EXIT_CODE"; fi) 2>&1 ) | tee -a ${HOME}/${DDD}/setup_scripts/logs/install.log
  reboot 20
  ;;
"20")
  ${HOME}/${DDD}/setup_scripts/2a-update.sh  2>&1 | tee -a ${HOME}/${DDD}/setup_scripts/logs/install.log
  LAST_CMD=$_
  EXIT_CODE=$?
  ((if [[ "$EXIT_CODE" -eq 1 ]]; then echo "ERROR: Last command: $LAST_CMD"; echo "Error Code: $EXIT_CODE"; fi) 2>&1 ) | tee -a ${HOME}/${DDD}/setup_scripts/logs/install.log
  reboot 30
  ;;
"30")
  ${HOME}/${DDD}/setup_scripts/3-lamp.sh  2>&1 | tee -a ${HOME}/${DDD}/setup_scripts/logs/install.log
  LAST_CMD=$_
  EXIT_CODE=$?
  ((if [[ "$EXIT_CODE" -eq 1 ]]; then echo "ERROR: Last command: $LAST_CMD"; echo "Error Code: $EXIT_CODE"; fi) 2>&1 ) | tee -a ${HOME}/${DDD}/setup_scripts/logs/install.log
  ${HOME}/${DDD}/setup_scripts/4-ides.sh  2>&1 | tee -a ${HOME}/${DDD}/setup_scripts/logs/install.log
  LAST_CMD=$_
  EXIT_CODE=$?
  ((if [[ "$EXIT_CODE" -eq 1 ]]; then echo "ERROR: Last command: $LAST_CMD"; echo "Error Code: $EXIT_CODE"; fi) 2>&1 ) | tee -a ${HOME}/${DDD}/setup_scripts/logs/install.log
  reboot 40
  ;;
"40")
  ${HOME}/${DDD}/setup_scripts/extras_misc.sh  2>&1 | tee -a ${HOME}/${DDD}/setup_scripts/logs/install.log
  LAST_CMD=$_
  EXIT_CODE=$?
  ((if [[ "$EXIT_CODE" -eq 1 ]]; then echo "ERROR: Last command: $LAST_CMD"; echo "Error Code: $EXIT_CODE"; fi) 2>&1 ) | tee -a ${HOME}/${DDD}/setup_scripts/logs/install.log
  ${HOME}/${DDD}/setup_scripts/extras_development.sh  2>&1 | tee -a ${HOME}/${DDD}/setup_scripts/logs/install.log
  LAST_CMD=$_
  EXIT_CODE=$?
  ((if [[ "$EXIT_CODE" -eq 1 ]]; then echo "ERROR: Last command: $LAST_CMD"; echo "Error Code: $EXIT_CODE"; fi) 2>&1 ) | tee -a ${HOME}/${DDD}/setup_scripts/logs/install.log
  reboot 50
  ;;
"50")
  ${HOME}/${DDD}/setup_scripts/extras_theming.sh  2>&1 | tee -a ${HOME}/${DDD}/setup_scripts/logs/install.log
  LAST_CMD=$_
  EXIT_CODE=$?
  ((if [[ "$EXIT_CODE" -eq 1 ]]; then echo "ERROR: Last command: $LAST_CMD"; echo "Error Code: $EXIT_CODE"; fi) 2>&1 ) | tee -a ${HOME}/${DDD}/setup_scripts/logs/install.log
  ${HOME}/${DDD}/setup_scripts/7-config.sh  2>&1 | tee -a ${HOME}/${DDD}/setup_scripts/logs/install.log
  LAST_CMD=$_
  EXIT_CODE=$?
  ((if [[ "$EXIT_CODE" -eq 1 ]]; then echo "ERROR: Last command: $LAST_CMD"; echo "Error Code: $EXIT_CODE"; fi) 2>&1 ) | tee -a ${HOME}/${DDD}/setup_scripts/logs/install.log
  reboot 60
  ;;
"60")
  ${HOME}/${DDD}/setup_scripts/8-manualconfig.sh  2>&1 | tee -a ${HOME}/${DDD}/setup_scripts/logs/install.log
  LAST_CMD=$_
  EXIT_CODE=$?
  ((if [[ "$EXIT_CODE" -eq 1 ]]; then echo "ERROR: Last command: $LAST_CMD"; echo "Error Code: $EXIT_CODE"; fi) 2>&1 ) | tee -a ${HOME}/${DDD}/setup_scripts/logs/install.log
  ;;
*)
  echo " *** BAD BAD BAD SOMETHING WENT WRONG!  CALL A DOCTOR! *** "
  ;;
esac


