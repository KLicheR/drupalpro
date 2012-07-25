#!/bin/bash
set -e

#======================================| Import Variables
# Make sure you have edited this file
source "${HOME}/${DDD_PATH}/setup_scripts/config.ini"
if [[ ${DEBUG} == true ]]; then set -x -v; fi


cd ${HOME}/${DDD_PATH}
git pull
bash "setup_scripts/updates.inc"

stage_finished=0
exit "$stage_finished"
