#!/bin/bash
set -e

#======================================| Import Variables
# Make sure you have edited this file
source "${HOME}/${DDD_PATH}/setup_scripts/config.ini"
if [[ ${DEBUG} == true ]]; then set -x -v; fi

#======================================| STAGE 10: FIX SUDOERS PERMISSIONS
sudo chmod 0440 "/etc/sudoers.d/${DDD}"
ERR=$?    # if ERR=0, then last command succeeded
if [[ "$ERR" != 0 ]]; then # Update log with results.  Write to log folder since files in there are ignored.
  echo "ERROR: $ERR -- Failed to update SUDOERS PERMISSIONS during update to 7.x-3.x-beta1-update10" | tee -a "${HOME}/${DDD_PATH}/setup_scripts/logs/update.log"
else
  echo "Successfully completed SUDOERS update 7.x-3.x-beta1-update10" | tee -a "${HOME}/${DDD_PATH}/setup_scripts/logs/update.log"
fi

#======================================| STAGE 20: FIX DRUSH SYMLINKS
#==========| Change working directory
cd "${HOME}/.drush"
ERR=$?    # if ERR=0, then last command succeeded
if [[ "$ERR" == 0 ]]; then
  #==========| Remove broken symlinks
  rm d6git.make d6.make d7git.make d7.make d8git.make default.make quickstart
  ERR=$?    # if ERR=0, then last command succeeded
  if [[ "$ERR" == 0 ]]; then
  #==========| Create symlinks to new location
    ln -s "${HOME}/${DDD_PATH}/drush_addons/make_templates/d6git.make" d6git.make
    ln -s "${HOME}/${DDD_PATH}/drush_addons/make_templates/d6.make" d6.make
    ln -s "${HOME}/${DDD_PATH}/drush_addons/make_templates/d7git.make" d7git.make
    ln -s "${HOME}/${DDD_PATH}/drush_addons/make_templates/d7.make" d7.make
    ln -s "${HOME}/${DDD_PATH}/drush_addons/make_templates/d8git.make" d8git.make
    ln -s "${HOME}/${DDD_PATH}/drush_addons/make_templates/default.make" default.make
    ln -s "${HOME}/${DDD_PATH}/drush_addons/" quickstart
    ERR=$?    # if ERR=0, then last command succeeded
  fi
fi

if [[ "$ERR" != 0 ]]; then # failed
  echo "ERROR: $ERR -- Failed to update SYMLINKS during update to 7.x-3.x-beta1-update20" | tee -a "${HOME}/${DDD_PATH}/setup_scripts/logs/update.log"
else
  echo "Successfully completed SYMLINKS update 7.x-3.x-beta1-update20" | tee -a "${HOME}/${DDD_PATH}/setup_scripts/logs/update.log"
fi

#======================================| STAGE 30: FIX SENDMAIL
# Ok, the original setup was really borked.  This update essentially does the same setup.
# ensure email collector path exists
mkdir -p "${LOGS}/mail"
ERR=$?    # if ERR=0, then last command succeeded
# ensure group is setup for apache (www-data)
sudo chown :www-data "${LOGS}"
  ERR=$((ERR+$?)); if [[ "$ERR" != 0 ]]; then ERRCMD="${ERRCMD}Step 1 ";fi # if ERR=0, then last command succeeded
sudo chown -R :www-data "${LOGS}/mail"
  ERR=$((ERR+$?)); if [[ "$ERR" != 0 ]]; then ERRCMD="${ERRCMD}Step 2 ";fi # if ERR=0, then last command succeeded
# setup permissions
sudo chmod -cR ug=rwX,o= "${LOGS}/mail"
  ERR=$((ERR+$?)); if [[ "$ERR" != 0 ]]; then ERRCMD="${ERRCMD}Step 3 ";fi # if ERR=0, then last command succeeded
# fix php.ini :: uncomment sendmail_path (in case its not already done)
sudo sed -i 's|'";.*sendmail_path.*="'|'"sendmail_path ="'|g' /etc/php5/apache2/php.ini /etc/php5/cli/php.ini
  ERR=$((ERR+$?)); if [[ "$ERR" != 0 ]]; then ERRCMD="${ERRCMD}Step 4 ";fi # if ERR=0, then last command succeeded
# fix php.ini :: replace any existing sendmail_path with path to drupalpro
sudo sed -i 's|'"sendmail_path =.*"'|'"sendmail_path = ${HOME}/${DDD_PATH}/resources/sendmail.php"'|g' /etc/php5/apache2/php.ini /etc/php5/cli/php.ini
  ERR=$((ERR+$?)); if [[ "$ERR" != 0 ]]; then ERRCMD="${ERRCMD}Step 5 ";fi # if ERR=0, then last command succeeded
# ensure its in apache groupERR=$((ERR+$?))    # if ERR=0, then last command succeeded
sudo chown -R :www-data "${HOME}/${DDD_PATH}/resources/sendmail.php"
  ERR=$((ERR+$?)); if [[ "$ERR" != 0 ]]; then ERRCMD="${ERRCMD}Step 6 ";fi # if ERR=0, then last command succeeded
# ensure its readable by apache
sudo chmod o=,ug+x ${HOME}/${DDD_PATH}/resources/sendmail.php
  ERR=$((ERR+$?)); if [[ "$ERR" != 0 ]]; then ERRCMD="${ERRCMD}Step 7 ";fi # if ERR=0, then last command succeeded
#restart apache to load changes
sudo service apache2 restart
  ERR=$((ERR+$?)); if [[ "$ERR" != 0 ]]; then ERRCMD="${ERRCMD}Step 8 ";fi # if ERR=0, then last command succeeded
if [[ "$ERR" != 0 ]]; then # failed
  echo "ERROR: $ERR -- Failed during $ERRCMD to update MAIL during update to 7.x-3.x-beta1-update30" | tee -a "${HOME}/${DDD_PATH}/setup_scripts/logs/update.log"
else
  echo "Successfully completed MAIL update 7.x-3.x-beta1-update30" | tee -a "${HOME}/${DDD_PATH}/setup_scripts/logs/update.log"
fi

stage_finished=0
exit "$stage_finished"
