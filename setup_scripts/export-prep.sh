#!/bin/bash
set -e

#======================================| Import Variables
# Make sure you have edited this file
source "$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"/config.ini
if [[ ${DEBUG} == true ]]; then set -x -v; fi

# dev and server

# Remove unneeded packages
sudo apt-get autoremove

# Clean out downloaded packages
sudo apt-get clean

# Clean up apt cache
sudo find /var/lib/apt/lists -type f -maxdepth 1 -exec rm {} \;
sudo find /var/lib/apt/lists/partial -type f -maxdepth 1 -exec rm {} \;

#clear bash history
cat /dev/null > ${HOME}/.bash_history
cat /dev/null > ${HOME}/.bash_eternal_history

#clear logs
sudo logrotate -f -s ${HOME}/${DDD_PATH}/setup_scripts/logs/logrotate-status.log ${HOME}/${DDD_PATH}/resources/clear-all-logs.conf
sudo find /var/log/ -name '*.gz' -type f -print0 -exec rm '{}' \;

# Zero-fill unused sectors on vm disk
# Zero-filled sectors compress very nice :-)
# No need to export sectors for files that could be "undeleted"
sudo dd if=/dev/zero of=/zerofile; sudo rm /zerofile

stage_finished=0
exit "$stage_finished"
