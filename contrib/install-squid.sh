#!/bin/bash

# ################################################################################ Squid caching of ftp.drupal.org
# README:
#
# This script will install Squid for caching of ftp.drupal.org

HELP="

Squid installation is complete.

Squid: Optimising Web Delivery.
Squid is a caching proxy for the Web supporting HTTP, HTTPS, FTP, and more. It reduces bandwidth and improves response times by caching and reusing frequently-requested web pages. Squid has extensive access controls and makes a great server accelerator.

For mote information, visit: http://lmgtfy.com/?q=squid+cache+drupal
(yes, hopefully that is both helpful and humorous)


"
cd ~
sudo apt-get update

# Install caching proxy server
sudo apt-get -y install squid3

echo "http_proxy=\"http://localhost:3128\"" | sudo tee -a /etc/environment > /dev/null

echo "
# fix for git 417 errors
ignore_expect_100 on

# Quickstart
acl drushservers dstdomain ftp.drupal.org
cache allow drushservers
cache deny all

# don't wait to finish requests before shutting down.  Do it now!
shutdown_lifetime 0 seconds
" | sudo tee -a /etc/squid3/squid.conf

echo $HELP
echo "*** REBOOT TO TAKE EFFECT ***"

