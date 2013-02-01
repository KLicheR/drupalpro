#!/bin/bash
set -e

#======================================| Import Variables
# Make sure you have edited this file
source "${HOME}/${DDD_PATH}/setup_scripts/config.ini"
if [[ ${DEBUG} == true ]]; then set -x -v; fi

cd ~

#======================================| Drush
if [[ ${INSTALL_DRUSH} == true ]]; then
  sudo apt-get ${APTGET_VERBOSE} install php5-cli
  mkdir -p "${APP_FOLDER}"
  cd ${APP_FOLDER}
  git clone http://git.drupal.org/project/drush.git
  cd ${APP_FOLDER}/drush
  git checkout $DRUSH_VERSION

  #mdrmike @FIXME (don't need once pear install works):
  chmod u+x ${APP_FOLDER}/drush/drush
  sudo ln -s ${APP_FOLDER}/drush/drush /usr/local/bin/drush

  # Install drush make and drush site-install6
  mkdir ${HOME}/.drush
fi

stage_finished=0
exit "$stage_finished"
