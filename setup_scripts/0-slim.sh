#!/bin/bash
set -e

#======================================| Import Variables
# Make sure you have edited this file
source "${HOME}/${DDD_PATH}/setup_scripts/config.ini"
if [[ ${DEBUG} == true ]]; then set -x -v; fi

# See also http://benhodge.wordpress.com/2008/02/17/cleaning-up-a-ubuntu-gnulinux-system/

# 0mb
sudo apt-get ${APTGET_VERBOSE} autoremove # autoremove is used to remove packages that were automatically installed to satisfy dependencies for other packages and are now no longer needed.
sudo apt-get ${APTGET_VERBOSE} clean # clean clears out the local repository of retrieved package files. It removes everything but the lock file from /var/cache/apt/archives/ and /var/cache/apt/archives/partial/.

# What's installed: slim-package-list.log
if [ "${EXTRA_DEBUG_INFO}" = true ]; then  # Slows setup.  Only need to do this in order to list installed packages and their size.
  for pkg in `dpkg --list | awk '/ii/ {print $2}'`; do echo -e "`dpkg --status $pkg | grep Installed-Size | awk '{print $2}'` \t\t $pkg" >> pkgs.tmp; done; sort -rg pkgs.tmp > ${HOME}/${DDD_PATH}/setup_scripts/slim-package-list.log; rm -f pkgs.tmp;
  echo "------------  -------------------" >> ${HOME}/${DDD_PATH}/setup_scripts/logs/slim-package-list.log
  echo "size(kb)         packagename" >> ${HOME}/${DDD_PATH}/setup_scripts/logs/slim-package-list.log


# Ending size
df -h -T > "${HOME}/${DDD_PATH}/setup_scripts/logs/size-slim.log"
fi

stage_finished=0
exit "$stage_finished"
