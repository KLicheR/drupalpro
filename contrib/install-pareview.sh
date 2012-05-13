#!/bin/bash

# ################################################################################ PAReview.sh

# README:
#
# This script will install PAReview.sh, a simple Bash script to automatically
# review Drupal.org project applications.
#
HELP="

PAReview.sh Installation complete.

PAReview is a simple Bash script to automatically review Drupal.org project
applications.

Usage:
cd /path/to/drupal
pareview.sh GIT-URL [BRANCH]
pareview.sh DIR-PATH

Examples:
pareview.sh http://git.drupal.org/project/rules.git
pareview.sh http://git.drupal.org/project/rules.git 6.x-1.x
pareview.sh sites/all/modules/rules

For details on using PAReview.sh, see the project page: http://drupal.org/project/pareviewsh
"

# Install PHP_CodeSniffer
sudo pear install PHP_CodeSniffer;

cd ~/quickstart/;

# Install Drupal Code Sniffer
git clone --branch 7.x-1.x http://git.drupal.org/project/drupalcs.git;
sudo ln -sv ~/quickstart/drupalcs/Drupal $(pear config-get php_dir)/PHP/CodeSniffer/Standards
echo "alias drupalcs='phpcs --standard=Drupal'" >> ~/.bash_aliases

# Install PAReview.sh
git clone --branch 7.x-1.x http://git.drupal.org/project/pareviewsh.git
sudo ln -s ~/quickstart/pareviewsh/pareview.sh /usr/local/bin

cd -;

echo "$HELP"

