#!/bin/bash
set -e

# ################################################################################ Import Variables
# Make sure you have edited this file
source "${HOME}/${DDD}/setup_scripts/CONFIG"
if [[ ${DEBUG} == true ]]; then set -x; fi

## Upgrade

sudo apt-get "${APTGET_VERBOSE}" update
sudo apt-get "${APTGET_VERBOSE}" upgrade

