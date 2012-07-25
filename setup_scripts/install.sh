#!/bin/bash
set -e

# See README.txt for more information
#
#     To install Drupal Development Desktop:
#
#     1) Open a terminal window in the virtual machine (Applications->Accessories->Terminal)
#     2) bash ${HOME}/${DDD_PATH}/setup_scripts/install.sh
#


#======================================| Import Variables
# Make sure you have edited this file
# CWD based on http://stackoverflow.com/questions/59895/can-a-bash-script-tell-what-directory-its-stored-in
CWD="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "${CWD}"/CONFIG
if [[ ${DEBUG} == true ]]; then set -x -v; fi

#======================================| Error Checking
function check_errs() {
  # Parameter 1 is the return code
  # Parameter 2 is text to display on failure.
  if [ "${1}" -ne "0" ]; then
    echo "ERROR # ${1} : ${2}
    " | tee -a ${HOME}/${DDD_PATH}/setup_scripts/logs/install.log
    # as a bonus, return with the right error code.
    return ${1}
  else
    echo "STAGE $STAGE ${2} SUCCESSFUL.  Exit code: ${1}
    " | tee -a ${HOME}/${DDD_PATH}/setup_scripts/logs/install.log
    return 0
  fi
}

#======================================| Reboot functions
function reboot() {
  # update .profile file to continue the next step of the script.
  echo "gnome-terminal -x bash -c \"${HOME}/${DDD_PATH}/setup_scripts/install.sh $1\" &" >> ${HOME}/.profile
  echo "*** REBOOTING ***" | tee -a ${HOME}/${DDD_PATH}/setup_scripts/logs/install.log
  echo "

  *** START REBOOT CYCLE: $1 ***" | tee -a ${HOME}/${DDD_PATH}/setup_scripts/logs/install.log
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
  echo "Starting Stage: $1"
  sed -i 's/gnome-terminal -x bash -c/# deleteme /g' ${HOME}/.profile
fi

#======================================| Test for network
# if rebooting, short delay for environment to setup
# @FIXME: better to test, but this is poormans solution for now
if [ ! -z $1 ]; then sleep 15; fi

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



#======================================| Install it!
# This case statment handles reboots
cd
STAGE="$1"
case "$STAGE" in
"")
  ${HOME}/${DDD_PATH}/setup_scripts/0-prep.sh  2>&1 | tee -a ${HOME}/${DDD_PATH}/setup_scripts/logs/install.log
  check_errs "$?" "$_"
  EXIT_CODE=$?
  if [[ "$EXIT_CODE" -eq 1 ]] || [[ "$EXIT_CODE" -eq 3 ]] || [[ "$EXIT_CODE" -eq 5 ]]
  then  # if exit code not 0 then abort, otherwise continue and reboot
    zenity --info --text='Aborted.  Nothing was changed. '
    exit
  else
      ${HOME}/${DDD_PATH}/setup_scripts/0-slim.sh  2>&1 | tee -a ${HOME}/${DDD_PATH}/setup_scripts/logs/install.log
      check_errs "$?" "$_"
      reboot 10
  fi
  ;;
"10")
  ${HOME}/${DDD_PATH}/setup_scripts/1-update.sh  2>&1 | tee -a ${HOME}/${DDD_PATH}/setup_scripts/logs/install.log
  check_errs "$?" "$_"
  reboot 20
  ;;
"20")
  ${HOME}/${DDD_PATH}/setup_scripts/2-vbox-guest-additions.sh  2>&1 | tee -a ${HOME}/${DDD_PATH}/setup_scripts/logs/install.log
  check_errs "$?" "$_"
  reboot 30
  ;;
"30")
  ${HOME}/${DDD_PATH}/setup_scripts/3-lamp.sh  2>&1 | tee -a ${HOME}/${DDD_PATH}/setup_scripts/logs/install.log
  check_errs "$?" "$_ 3-lamp.sh"
  ${HOME}/${DDD_PATH}/setup_scripts/4-ides.sh  2>&1 | tee -a ${HOME}/${DDD_PATH}/setup_scripts/logs/install.log
  check_errs "$?" "$_ 4-ides.sh"
  reboot 40
  ;;
"40")
  ${HOME}/${DDD_PATH}/setup_scripts/extras_misc.sh  2>&1 | tee -a ${HOME}/${DDD_PATH}/setup_scripts/logs/install.log
  check_errs "$?" "$_ extras_misc.sh"
  ${HOME}/${DDD_PATH}/setup_scripts/extras_development.sh  2>&1 | tee -a ${HOME}/${DDD_PATH}/setup_scripts/logs/install.log
  check_errs "$?" "$_ extras_development.sh"
  reboot 50
  ;;
"50")
  ${HOME}/${DDD_PATH}/setup_scripts/7-config.sh  2>&1 | tee -a ${HOME}/${DDD_PATH}/setup_scripts/logs/install.log
  check_errs "$?" "$_ 7-config.sh"
  reboot 60
  ;;
"60")
  ${HOME}/${DDD_PATH}/setup_scripts/8-manualconfig.sh  2>&1 | tee -a ${HOME}/${DDD_PATH}/setup_scripts/logs/install.log
  check_errs "$?" "$_"
  ;;
*)
  echo " *** BAD BAD BAD SOMETHING WENT WRONG!  CALL A DOCTOR! *** "
  ;;
esac
