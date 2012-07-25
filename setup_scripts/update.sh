#!/bin/bash
set -e

#======================================| Import Variables
# Make sure you have edited this file
source "${HOME}/${DDD_PATH}/setup_scripts/CONFIG"
if [[ ${DEBUG} == true ]]; then set -x -v; fi


cd ${HOME}/${DDD_PATH}
git pull
bash "setup_scripts/updates.inc"

