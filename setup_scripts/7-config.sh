#!/bin/bash

# Remove fancy high-falutin new 3d-glasses scrollbars.  In my day we just had arrow keys!
#mdrmike sudo apt-get -y remove overlay-scrollbar liboverlay-scrollbar-0.1-0

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

# setup icons on top of screensyn
#mdrmike sudo apt-get -yq install netspeed
#mdrmike echo "#!/usr/bin/env xdg-open
#mdrmike
#mdrmike [Desktop Entry]
#mdrmike Version=1.0
#mdrmike Type=Application
#mdrmike Terminal=false
#mdrmike Icon[en_US]=/home/quickstart/eclipse/icon.xpm
#mdrmike Name[en_US]=Eclipse
#mdrmike Exec=/home/quickstart/eclipse/eclipse
#mdrmike Comment[en_US]=IDE
#mdrmike Name=Eclipse
#mdrmike Comment=IDE
#mdrmike Icon=/home/quickstart/eclipse/icon.xpm
#mdrmike " | tee /home/quickstart/.gnome2/panel2.d/default/launchers/eclipse.desktop > /dev/null
#mdrmike # created with: gconftool-2 --dump /apps/panel > my-panel-setup.entries
#mdrmike gconftool-2 --load ~/quickstart/config/my-panel-setup.entries
#mdrmike #killall gnome-panel  #this not working for some reason.  Just did a reboot after this script

#mdrmike # If the world was built by designers, it would be gorgeous, and noone could do anything.  Make windows edges dragable for resizing.
#mdrmike sudo cp ~/quickstart/config/radiance-metacity-theme-1.xml /usr/share/themes/Radiance/metacity-1/metacity-theme-1.xml

#mdrmike # get rid of subversion commit keyring.  Store passwords plain on disk
#mdrmike sudo sed -i 's/# password-stores = gnome-keyring,kwallet/password-stores = /g' ~/.subversion/config
#mdrmike sudo sed -i 's/# store-plaintext-passwords = no/store-plaintext-passwords = yes/g' ~/.subversion/servers

cd $HOME
sudo cp eclipse-php/configuration/org.eclipse.osgi/bundles/224/1/.cp/icons/eclipse48.png /usr/share/pixmaps/eclipse.png

# final size
df -h -T > ~/quickstart/setup_scripts/logs/quickstart-size-end.txt

