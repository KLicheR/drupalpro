#!/bin/bash
set -e

#======================================| Import Variables
# Make sure you have edited this file
source "${HOME}/${DDD_PATH}/setup_scripts/config.ini"
if [[ ${DEBUG} == true ]]; then set -x -v; fi

## Some configuration
# gnome terminal
gconftool-2 -s /apps/gnome-terminal/profiles/Default/scrollback_lines --type=int 8192

#======================================| Config /etc/ssh/ssh_config: http://drupal.org/node/1829126
sudo sed -i 's/#   GSSAPIAuthentication no/GSSAPIAuthentication no/g' /etc/ssh/ssh_config

#======================================| Command line shortcuts (bash aliases)

# Don't sudo here...
cat "${HOME}/${DDD_PATH}/resources/ddd_bash_aliases" >> ${HOME}/.bash_aliases

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

#======================================| Remove uneeded folders
if [[ "${REMOVE_DEFAULT_FOLDERS}" == true ]]; then
  if [ -d "$HOME/Music" ]; then rm -R "$HOME/Music"; fi
  #if [ -d "$HOME/Pictures" ]; then rm -R "$HOME/Pictures"; fi  #don't do this is installing wallpaper
  if [ -d "$HOME/Public" ]; then rm -R "$HOME/Public"; fi
  if [ -d "$HOME/Templates" ]; then rm -R "$HOME/Templates"; fi
  if [ -d "$HOME/Videos" ]; then rm -R "$HOME/Videos"; fi
  if [ -f "$HOME/examples.desktop" ]; then rm "$HOME/examples.desktop"; fi
fi

# final size
if [[ ${EXTRA_DEBUG_INFO} == true ]]; then
  df -h -T > ${HOME}/${DDD_PATH}/setup_scripts/logs/size-end.log
fi

stage_finished=0
exit "$stage_finished"
