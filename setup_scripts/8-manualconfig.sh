#!/bin/bash

# Create example site.  This done after previous reboot to avoid error.
cd ~/websites
drush qc --domain=example7.dev
drush qc --domain=example6.dev --makefile=d6.make


firefox &
firefox -CreateProfile temp &
zenity --info --text="Firefox will start to create profiles.\n\nPlease CLOSE FIREFOX. "
#zenity --info --text="Firefox will start.\n\n1) Please install the FEBE backup extension.\n2) Tools -> FEBE -> Restore profile.\n3) Click 'default' in list (create if it's not there).\n4) Select button at bottom 'Restore local backup'.\n5) Choose file: ~/profileFx4{default}.fbu.\n6) Start profile restore.\n7) Ok, ok, then CLOSE FIREFOX" &
#firefox -P temp https://addons.mozilla.org/en-US/firefox/downloads/latest/2109/addon-2109-latest.xpi?src=addondetail
firefox -P temp http://softwarebychuck.com/xpis/FEBE7.0.3.3.xpi &
zenity --info --text="Firefox is starting in order to install FEBE.

1) Install the FEBE extention.
2) Once FEBE is installed, choose the option to RESTART Firefox.
3) Next, choose Tools > FEBE > Restore Profile to restore the default profile using the file: ~/profileFx4{default}.fbu.\n
4) Finally, close Firefox "

firefox -ProfileManager &
zenity --info --text="Firefox profile manager will start.\n1) Delete temp profile.\n2) THEN CLOSE MANAGER."
rm profileFx4{default}.fbu

# final size
df -h -T > ~/quickstart/setup_scripts/logs/quickstart-size-end.txt

# Manual config instructions.
firefox ~/quickstart/config/manualconfig.txt


