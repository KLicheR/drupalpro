#!/bin/bash
set -e

# ################################################################################ Import Variables
# Make sure you have edited this file
source CONFIG
if [[ ${DEBUG} == TRUE ]]; then set -x; fi

# Change default theme (due to Netbeans / java)
gconftool-2 -s /apps/metacity/general/theme --type=string Radiance
gconftool-2 -s /desktop/gnome/interface/gtk_theme --type=string Radiance
gconftool-2 -s /desktop/gnome/interface/icon_theme --type=string ubuntu-mono-light

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

cd
sudo cp eclipse-php/configuration/org.eclipse.osgi/bundles/224/1/.cp/icons/eclipse48.png /usr/share/pixmaps/eclipse.png

# final size
df -h -T > ~/$DDD/setup_scripts/logs/size-end.log

