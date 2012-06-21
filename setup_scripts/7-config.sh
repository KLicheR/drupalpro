#!/bin/bash
set -e

#======================================| Import Variables
# Make sure you have edited this file
source "${HOME}/${DDD}/setup_scripts/CONFIG"
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
sudo cp ${HOME}/${DDD}/config/index.php /var/www/index.php
sudo chmod -R u=rwX,g=rX,o= /var/www
sudo chown -R $USER:www-data /var/www

#======================================| Command line shortcuts (bash aliases)

# Don't sudo here...
cat ${HOME}/${DDD}/config/ddd_bash_aliases >> ${HOME}/.bash_aliases


#======================================| Desktop shortcuts

cat > ${HOME}/Desktop/README.desktop <<END
#!/usr/bin/env xdg-open
[Desktop Entry]
Type=Link
URL=http://localhost
Name=README
Icon=/usr/share/pixmaps/firefox.png
END

cat > ${HOME}/Desktop/gnome-terminal.desktop <<END
#!/usr/bin/env xdg-open
[Desktop Entry]
Type=Application
Name=Eclipse
Comment=Eclipse Integrated Development Environment
Icon=/usr/share/pixmaps/eclipse.xpm
Exec=${HOME}/eclipse/eclipse
Terminal=false
Categories=Development;IDE;Java;
END
chmod 750 ${HOME}/Desktop/gnome-terminal.desktop

ln -s "${WWW_ROOT}" ${HOME}/Desktop/websites




# final size
if [[ ${EXTRA_DEBUG_INFO} == true ]];
  df -h -T > ${HOME}/${DDD}/setup_scripts/logs/size-end.log
fi

