#!/bin/bash
set -e

#======================================| Import Variables
# Make sure you have edited this file
source "${HOME}/${DDD_PATH}/setup_scripts/config.ini"
if [[ ${DEBUG} == true ]]; then set -x -v; fi

cd ~

#======================================| Configure phpmyadmin
# show hex data on detail pages.
echo "
# Show 1000 rows instead of 30 by default
\$cfg['MaxRows'] = 1000;
# Show BLOB data as a string not hex.
\$cfg['DisplayBinaryAsHex'] = false;
# Show BLOB data in row detail pages.
\$cfg['ProtectBinary'] = false;
# Show BLOB data on table browse pages.  Hack to hardcode all requests.
\$_REQUEST['display_blob'] = true;
" | sudo tee -a /etc/phpmyadmin/config.inc.php

# never log me out!
echo "
/*
* Prevent timeout for a year at a time.
* (seconds * minutes * hours * days * weeks)
*/
\$cfg['LoginCookieValidity'] = 60*60*24*7*52;
ini_set('session.gc_maxlifetime', \$cfg['LoginCookieValidity']);
" | sudo tee -a /etc/phpmyadmin/config.inc.php


echo "This is where websites go.

Drupal Development Desktop includes some command line scripts to automate site creation.

To create a site (dns, apache, code, database, and install):

  1) Start a terminal (top left icon, click the black box with a [>_] )

  2) Paste in this command (don't include the $)
    $ drush quickstart-create --domain=newsite.dev
         or
    $ drush qc --domain=newsite.dev

To delete a site:
  $ drush quickstart-delete --domain=newsite.dev
         or
  $ drush qd --domain=newsite.dev

For more information:
  $ drush help quickstart-create
  $ drush help quickstart-destroy
  Or goto http://drupal.org/node/819398" > ${HOME}/websites/README.txt

#======================================| Drush
if [[ ${INSTALL_DRUSH} == true ]]; then
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

  # Setup Quickstart Drush addon
  ln -s ${HOME}/${DDD_PATH}/drush_addons/quickstart ${HOME}/.drush/quickstart   # Links allow a git pull to update
  ln -s ${HOME}/${DDD_PATH}/drush_addons/make_templates/*.make "${HOME}/.drush"
  if [ -e ${APP_FOLDER}/drush/examples/example.drushrc.php ];
    then cp ${APP_FOLDER}/drush/examples/example.drushrc.php ${HOME}/.drush/drushrc.php
    echo "\$command_specific['make']= array('working-copy' => TRUE);" >> "${HOME}/.drush/drushrc.php"
  fi

  # Install Feather (Drush addon)
  git clone --recursive --branch ${FEATHER} http://git.drupal.org/project/feather.git ${HOME}/.drush/feather
fi

#======================================| Email catcher
if [[ "${INSTALL_EMAIL_CATCHER}" == true ]]; then
  # Configure email collector
  mkdir -p "${LOGS}/mail"
  # change group to apache (www-data)
  sudo chown :www-data "${LOGS}"
  sudo chown -R :www-data "${LOGS}/mail"
  # setup permissions
  sudo chmod -R ug=rwX,o= "${LOGS}/mail"
  # uncomment sendmail_path in php.ini
  sudo sed -i 's|'";.*sendmail_path.*="'|'"sendmail_path ="'|g' /etc/php5/apache2/php.ini /etc/php5/cli/php.ini
  # replace any existing sendmail_path with path to drupalpro
  sudo sed -i 's|'"sendmail_path =.*"'|'"sendmail_path = ${HOME}/${DDD_PATH}/resources/sendmail.php"'|g' /etc/php5/apache2/php.ini /etc/php5/cli/php.ini
  # ensure its in apache group
  sudo chown -R :www-data "${HOME}/${DDD_PATH}/resources/sendmail.php"
  # ensure its readable by apache
  sudo chmod o=,ug+x ${HOME}/${DDD_PATH}/resources/sendmail.php
fi


#======================================| XDebug Debugger/Profiler
# Configure xdebug - installed 2.1 from apt
if [[ "${INSTALL_XDEBUG}" == true ]]; then
  echo "
  xdebug.remote_enable=on
  xdebug.remote_handler=dbgp
  xdebug.remote_host=localhost
  xdebug.remote_port=9000
  xdebug.profiler_enable=0
  xdebug.profiler_enable_trigger=1
  xdebug.profiler_output_dir=${LOGS}/profiler
  " | sudo tee -a /etc/php5/conf.d/xdebug.ini > /dev/null


  #======================================| Install a web-based profile viewer
  if [[ "${INSTALL_WEBGRIND}" == true ]]; then
    mkdir -p "${LOGS}/profiler"
    cd "${LOGS}/profiler"
    git clone https://github.com/jokkedk/webgrind.git webgrind
    chmod -R ug=rwX,o= "${LOGS}/profiler"

    # Setup Web server
    echo "127.0.0.1 webgrind

    " | sudo tee -a /etc/hosts > /dev/null

    echo "Alias /profiler ${LOGS}/profiler/webgrind

    <Directory ${LOGS}/profiler/webgrind>
      Allow from All
    </Directory>
    " | sudo tee /etc/apache2/conf.d/webgrind > /dev/null
  fi  # WEBGRIND
fi    # XDEBUG

#======================================| XHProf profiler (Devel Module)
# Adapted from: http://techportal.ibuildings.com/2009/12/01/profiling-with-xhprof/
if [[ "${INSTALL_XHPROF}" == true ]]; then

  # supporting packages
  sudo apt-get ${APTGET_VERBOSE} install graphviz

  # get it
  cd ~
  wget ${WGET_VERBOSE} --referer="${REFERER}" --user-agent="${USERAGENT}" --header="${HEAD1}" --header="${HEAD2}" --header="${HEAD3}" --header="${HEAD4}" --header="${HEAD5}" "${XHPROF_URL}"
  tar xvf xhprof-0.9.2.tgz
  mv xhprof-0.9.2 "${LOGS}/xhprof"
  rm xhprof-0.9.2.tgz
  rm package.xml

  # build and install it
  cd ${LOGS}/xhprof/extension/
  phpize
  ./configure
  make
  sudo make install

  # configure php
  echo "
  [xhprof]
  extension=xhprof.so
  xhprof.output_dir=\"${LOGS}/xhprof\"
  " | sudo tee /etc/php5/conf.d/xhprof.ini > /dev/null

  # configure apache
  echo "Alias /xhprof ${LOGS}/xhprof/xhprof_html

  <Directory ${LOGS}/profiler/xhprof/xhprof_html>
    Allow from All
  </Directory>
  " | sudo tee /etc/apache2/conf.d/xhprof > /dev/null

  chmod -R ug=rwX,o= "${LOGS}/xhprof"
fi

#======================================| Restart apache
sudo /etc/init.d/apache2 restart #use sysvinit scripts instead of upstart for more compatibility (debian, older ubuntu, etc)

#======================================| Fabric (and Pip)
if [[ "${INSTALL_FABRIC}" == true ]]; then
  # Install "pip" to facilitate the installation of "Fabric".
  sudo apt-get ${APTGET_VERBOSE} install python-pip
  # Install "Fabric".
  sudo pip install fabric
fi

stage_finished=0
exit "$stage_finished"
