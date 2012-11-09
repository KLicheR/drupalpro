#!/bin/bash
set -e

#======================================| Import Variables
# Make sure you have edited this file
source "${HOME}/${DDD_PATH}/setup_scripts/config.ini"
if [[ ${DEBUG} == true ]]; then set -x -v; fi

## Some configuration
# automatic updates.  apply security.  download updates
echo "
APT::Periodic::Enable \"1\";
APT::Periodic::Update-Package-Lists \"1\";
APT::Periodic::Download-Upgradeable-Packages \"1\";
APT::Periodic::AutocleanInterval \"5\";
APT::Periodic::Unattended-Upgrade \"1\";
" | sudo tee /etc/apt/apt.conf.d/10periodic > /dev/null

#======================================| Config /etc/ssh/ssh_config: http://drupal.org/node/1829126
sudo sed -i 's/#   GSSAPIAuthentication no/GSSAPIAuthentication no/g' /etc/ssh/ssh_config

#======================================| Replace localhost/index.html
# Add interesting default document for localhost
sudo rm /var/www/index.html
sudo cp "${HOME}/${DDD_PATH}/resources/index.php" /var/www/index.php
sudo chmod -R u=rwX,g=rX,o= /var/www
sudo chown -R $USER:www-data /var/www

#======================================| Command line shortcuts (bash aliases)
# Don't sudo here...
cat "${HOME}/${DDD_PATH}/resources/ddd_bash_aliases" >> ${HOME}/.bash_aliases

# final size
if [[ ${EXTRA_DEBUG_INFO} == true ]]; then
  df -h -T > ${HOME}/${DDD_PATH}/setup_scripts/logs/size-end.log
fi

stage_finished=0
exit "$stage_finished"
