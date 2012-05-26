#!/bin/bash

# To install Quickstart Server:
#
# 1) Install server (e.g. AMI on Amazon)
#
#    Process:
#      http://www.ardentsoft.com/blog/2009/3/3/lamp-on-ec2-part-1-setting-up-amazon-web-services.html
#    AMI:
#      http://developer.amazonwebservices.com/connect/entry.jspa?externalID=3101
#      US West AMI ID:    ami-c997c68c
#        64-bit, ebs
#      Login user: ubuntu
#
# 2) bash ~/quickstart/install-quickstart-server.sh

cd ~

# bash -x ~/quickstart/setup_scripts/1-prep.sh
# bash -x ~/quickstart/setup_scripts/2-slim.sh
bash -x ~/quickstart/setup_scripts/3-lamp.sh
# bash -x ~/quickstart/setup_scripts/4-ides.sh
# bash -x ~/quickstart/setup_scripts/extras_misc.sh
# bash -x ~/quickstart/setup_scripts/extras_theming.sh
# bash -x ~/quickstart/setup_scripts/extras_development.sh
# bash -x ~/quickstart/setup_scripts/7-config.sh
# firefox ~/quickstart/config/manualconfig.txt

