#!/bin/bash
set -e

#======================================| Import Variables
# Make sure you have edited this file
source "${HOME}/${DDD_PATH}/setup_scripts/config.ini"
if [[ ${DEBUG} == true ]]; then set -x -v; fi

sudo chmod 0440 "/etc/sudoers.d/${DDD}"
SETPERM=$?
if [[ "$SETPERM" -gt 0 ]]; then # Update log with results.  Write to log folder since files in there are ignored.
  echo "ERROR: Failed to update 7.x-3.x-beta1-update10" | tee -a ${HOME}/${DDD_PATH}/setup_scripts/logs/update.log
else
  echo "Successfully completed updated 7.x-3.x-beta1-update10" | tee -a ${HOME}/${DDD_PATH}/logs/update.log
fi

stage_finished=0
exit "$stage_finished"
