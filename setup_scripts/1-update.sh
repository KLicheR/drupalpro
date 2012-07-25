#!/bin/bash
set -e

#======================================| Import Variables
# Make sure you have edited this file
source "${HOME}/${DDD_PATH}/setup_scripts/config.ini"
if [[ ${DEBUG} == true ]]; then set -x -v; fi

## Upgrade
sudo apt-get -yq update
sudo apt-get -yq upgrade

stage_finished=0
exit "$stage_finished"
