#!/bin/bash

# Install graphics editors - weights about 25mb
sudo add-apt-repository ppa:otto-kesselgulasch/gimp
sudo apt-get update
sudo apt-get -yq install gimp icc-profiles #beware.  ppa currently at gimp-2.8~RC1

# Install compass (which needs ruby)
sudo apt-get -yq install ruby1.9.1
sudo gem1.9.1 install compass
