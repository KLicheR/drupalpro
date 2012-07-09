#!/bin/bash
set -e

#======================================| Import Variables
# Make sure you have edited this file
source "${HOME}/${DDD}/setup_scripts/CONFIG"
if [[ ${DEBUG} == true ]]; then set -x -v; fi

# Create example site.  This done after previous reboot to avoid error.
cd ${HOME}/websites
drush qc --domain=example7.dev
drush qc --domain=example6.dev --makefile=d6.make


firefox -CreateProfile temp &
sleep 5
# firefox -CreateProfile Default &
firefox -P temp http://softwarebychuck.com/xpis/FEBE7.0.3.3.xpi &
sleep 5
zenity --info --text="Firefox is starting in order to install FEBE.

1) Install the FEBE extention.
2) Once FEBE is installed, choose the option to RESTART Firefox.
3) Next, choose Tools > FEBE > Restore Profile to restore the default profile using the file: ${HOME}/profileFx4{default}.fbu.\n
4) Finally, close Firefox "

firefox -ProfileManager &
sleep 5
zenity --info --text="Firefox profile manager will start.\n1) Delete temp profile.\n2) THEN CLOSE MANAGER."
#rm profileFx4{ddd}.fbu

# Load Sublime Text with default README.txt file
"${HOME}/opt/Sublime Text 2/sublime_text" "${HOME}/opt/Sublime Text 2/README.txt"

# final size
if [ "${EXTRA_DEBUG_INFO}" = true ]; then
  df -h -T > ${HOME}/${DDD}/setup_scripts/logs/size-end.log
fi

# Manual config instructions.
firefox ${HOME}/${DDD}/config/manualconfig.txt


