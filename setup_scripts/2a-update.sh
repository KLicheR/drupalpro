#!/bin/bash
set -e

# ################################################################################ Import Variables
# Make sure you have edited this file
source CONFIG
if [[ ${DEBUG} == TRUE ]]; then set -x; fi

## Upgrade

sudo apt-get -yq update
sudo apt-get -yq upgrade

