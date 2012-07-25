#!/bin/bash
set -e

#======================================| Import Variables
# Make sure you have edited this file
source "${HOME}/${DDD_PATH}/setup_scripts/CONFIG"
if [[ ${DEBUG} == true ]]; then set -x -v; fi

## Some configuration
# turn off screen saver
gconftool-2 -s /apps/gnome-screensaver/idle_activation_enabled --type=bool false

# Use firefox as default browser.  Chrome, I'm looking at you...
sudo update-alternatives --set gnome-www-browser /usr/bin/firefox
sudo update-alternatives --set x-www-browser /usr/bin/firefox

# gnome terminal
gconftool-2 -s /apps/gnome-terminal/profiles/Default/scrollback_lines --type=int 8192

# Change default theme (due to Netbeans / java)
gconftool-2 -s /apps/metacity/general/theme --type=string Radiance
gconftool-2 -s /desktop/gnome/interface/gtk_theme --type=string Radiance
gconftool-2 -s /desktop/gnome/interface/icon_theme --type=string ubuntu-mono-light
gsettings set org.gnome.desktop.wm.preferences theme 'Radiance'
gsettings set org.gnome.desktop.interface gtk-theme 'Radiance'
gsettings set org.gnome.desktop.interface icon-theme 'ubuntu-mono-light'
gsettings set org.gnome.desktop.interface ubuntu-overlay-scrollbars true # change to false for oldstyle thick scrollbars

#setup nautilus
gconftool-2 --type=Boolean --set /apps/nautilus/preferences/always_use_location_entry true
gsettings set org.gnome.nautilus.preferences always-use-location-entry true

# automatic updates.  apply security.  download updates
echo "
APT::Periodic::Enable \"1\";
APT::Periodic::Update-Package-Lists \"1\";
APT::Periodic::Download-Upgradeable-Packages \"1\";
APT::Periodic::AutocleanInterval \"5\";
APT::Periodic::Unattended-Upgrade \"1\";
" | sudo tee /etc/apt/apt.conf.d/10periodic > /dev/null


#======================================| Replace localhost/index.html
# Add interesting default document for localhost
sudo rm /var/www/index.html
sudo cp "${HOME}/${DDD_PATH}/config/index.php" /var/www/index.php
sudo chmod -R u=rwX,g=rX,o= /var/www
sudo chown -R $USER:www-data /var/www

#======================================| Command line shortcuts (bash aliases)

# Don't sudo here...
cat "${HOME}/${DDD_PATH}/config/ddd_bash_aliases" >> ${HOME}/.bash_aliases


#======================================| Desktop shortcuts

cat > "${HOME}/Desktop/README.desktop" <<END
#!/usr/bin/env xdg-open
[Desktop Entry]
Type=Link
URL=http://localhost
Name=README
Icon=/usr/share/pixmaps/firefox.png
END
chmod 750 "${HOME}/Desktop/README.desktop"

cat > "${HOME}/Desktop/drupalpro-issues.desktop" <<END
#!/usr/bin/env xdg-open
[Desktop Entry]
Type=Link
URL=http://drupal.org/project/issues/drupalpro?categories=All
Name=DrupalPro Issues
Icon=${WWW_ROOT}/example7.dev/misc/powered-black-135x42.png
END
chmod 750 "${HOME}/Desktop/drupalpro-issues.desktop"

ln -s "${WWW_ROOT}" ${HOME}/Desktop/websites

#======================================| Add Nautilus Emblems
if [[ "${ADD_NAUTILUS_EMBLEMS}" == true ]]; then
  if [ -d "${APP_FOLDER}" ]; then gvfs-set-attribute -t stringv ${APP_FOLDER} metadata::emblems development; fi
  if [ -d "${HOME}/Desktop/${HOSTSHARE}" ]; then gvfs-set-attribute -t stringv ${HOME}/Desktop/${HOSTSHARE} metadata::emblems shared; fi
  if [ -d "${HOME}/${DDD_PATH}" ]; then gvfs-set-attribute -t stringv ${HOME}/${DDD_PATH} metadata::emblems development; fi
  if [ -d "${WWW_ROOT}" ]; then gvfs-set-attribute -t stringv ${WWW_ROOT} metadata::emblems web; fi
  if [ -d "${HOME}/Desktop/websites" ]; then gvfs-set-attribute -t stringv ${HOME}/Desktop/websites metadata::emblems web; fi
  if [ -d "${WWW_ROOT}/config" ]; then gvfs-set-attribute -t stringv ${WWW_ROOT}/config metadata::emblems system; fi
  if [ -d "${WWW_ROOT}/logs" ]; then gvfs-set-attribute -t stringv ${WWW_ROOT}/logs metadata::emblems documents; fi
fi
#======================================| Remove uneeded folders
if [[ "${REMOVE_DEFAULT_FOLDERS}" == true ]]; then
  if [ -d "$HOME/Music" ]; then rm -R "$HOME/Music"; fi
  if [ -d "$HOME/Pictures" ]; then rm -R "$HOME/Pictures"; fi
  if [ -d "$HOME/Public" ]; then rm -R "$HOME/Public"; fi
  if [ -d "$HOME/Templates" ]; then rm -R "$HOME/Templates"; fi
  if [ -d "$HOME/Videos" ]; then rm -R "$HOME/Videos"; fi
  if [ -f "$HOME/examples.desktop" ]; then rm "$HOME/examples.desktop"; fi
fi

# final size
if [[ ${EXTRA_DEBUG_INFO} == true ]]; then
  df -h -T > ${HOME}/${DDD_PATH}/setup_scripts/logs/size-end.log
fi

