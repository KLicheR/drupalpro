#!/bin/bash
set -e

#======================================| Import Variables
# Make sure you have edited this file
source "$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"/CONFIG
if [[ ${DEBUG} == true ]]; then set -x -v; fi

# dev and server

# Remove unneeded packages
sudo apt-get autoremove

# Clean out downloaded packages
sudo apt-get clean

# Clean up apt cache
sudo find /var/lib/apt/lists -type f -maxdepth 1 -exec rm {} \;
sudo find /var/lib/apt/lists/partial -type f -maxdepth 1 -exec rm {} \;

# empty trash
if [ -f "${HOME}"/profile*.fbu ]; then rm "${HOME}"/profile*.fbu; fi
sudo rm -rf ${HOME}/.local/share/Trash/files/*
sudo rm -rf ${HOME}/.local/share/Trash/info/*

#clear bash history
killall guake
killall gnome-terminal
killall x-terminal-emulator
cat /dev/null > ${HOME}/.bash_history
cat /dev/null > ${HOME}/.bash_eternal_history

#clear gnome history
cat /dev/null > ${HOME}/.local/share/recently-used.xbel

#clean cache
find ${HOME} -name "cache" -print0 | xargs -0 -I {} find {} -type f | xargs /bin/rm
#find ${HOME}/.cache -type f -exec rm '{}' \;


#clear logs
sudo logrotate -f -s ${HOME}/${DDD_PATH}/setup_scripts/logs/logrotate-status.log ${HOME}/${DDD_PATH}/resources/clear-all-logs.conf
sudo find /var/log/ -name '*.gz' -type f -print0 -exec rm '{}' \;

# Zero-fill unused sectors on vm disk
# Zero-filled sectors compress very nice :-)
# No need to export sectors for files that could be "undeleted"
sudo dd if=/dev/zero of=/zerofile; sudo rm /zerofile
