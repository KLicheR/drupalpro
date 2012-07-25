#!/bin/bash
set -e

#======================================| Import Variables
# Make sure you have edited this file
source "${HOME}/${DDD_PATH}/setup_scripts/CONFIG"
if [[ ${DEBUG} == true ]]; then set -x -v; fi

# Install some useful utilities for developing & theming in Ubuntu
# Synaptic Xchat gnote compass guake (instant shell) gufw (GUI for firewall)
sudo apt-get update
sudo apt-get ${APTGET_VERBOSE} install gnome-activity-journal p7zip gnote

if [[ ${INSTALL_GRAPHIC_XTRAS} == true ]]; then
  #======================================| Add Unity Scopes PPA
  echo 'deb http://ppa.launchpad.net/scopes-packagers/ppa/ubuntu precise main ' | sudo tee -a /etc/apt/sources.list.d/scopes-packagers-precise.list > /dev/null
  echo 'deb-src http://ppa.launchpad.net/scopes-packagers/ppa/ubuntu precise main ' | sudo tee -a /etc/apt/sources.list.d/scopes-packagers-precise.list > /dev/null
  sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 48894010
  sudo apt-get update
  sudo apt-get ${APTGET_VERBOSE} install ardesia unity-lens-graphicdesign unity-lens-utilities unity-lens-wikipedia
fi
if [[ ${INSTALL_POWER_UTILS} == true ]]; then
  # power utils
  sudo apt-get ${APTGET_VERBOSE} install synaptic bleachbit

  #======================================| Add Diodon Clipboard Manager PPA
  echo 'deb http://ppa.launchpad.net/diodon-team/stable/ubuntu precise main' | sudo tee -a /etc/apt/sources.list.d/diodon-precise.list > /dev/null
  echo 'deb-src http://ppa.launchpad.net/diodon-team/stable/ubuntu precise main' | sudo tee -a /etc/apt/sources.list.d/diodon-precise.list > /dev/null
  sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 523884B2
  sudo apt-get update
  #======================================| Diodon clipboard and Autokey automation

  sudo apt-get ${APTGET_VERBOSE} install diodon diodon-plugins autokey-gtk
  # Whitelist autokey for Unity panel
  if grep -iq 'autokey-gtk' <(echo `gsettings get com.canonical.Unity.Panel systray-whitelist`); then
    echo "'Autokey' already exists in the Unity panel whitelist. Nothing to do here.";
  else echo "Adding 'Autokey' to Unity panel whitelist." && gsettings set com.canonical.Unity.Panel systray-whitelist "`echo \`gsettings get com.canonical.Unity.Panel systray-whitelist | tr -d ]\`,\'autokey-gtk\']`"; fi

  #======================================| Xchat IRC
  sudo apt-get ${APTGET_VERBOSE} install xchat
  # Whitelist xchat for Unity panel
  if grep -iq 'xchat' <(echo `gsettings get com.canonical.Unity.Panel systray-whitelist`); then
    echo "'xchat' already exists in the Unity panel whitelist. Nothing to do here.";
  else echo "Adding 'xchat' to Unity panel whitelist." && gsettings set com.canonical.Unity.Panel systray-whitelist "`echo \`gsettings get com.canonical.Unity.Panel systray-whitelist | tr -d ]\`,\'xchat\']`"; fi
fi
if [[ ${INSTALL_TERMINAL_UTILS} == true ]]; then
  sudo apt-get ${APTGET_VERBOSE} install guake nautilus-open-terminal grsync
  #Set default values for guake
  gconftool -s /apps/guake/keybindings/global/show_hide --type=string "F4"
  gconftool -s /apps/guake/general/history_size --type=int 8192
  gconftool -s /apps/guake/style/background/transparency --type=int 10
  gconftool -s /apps/guake/general/window_losefocus --type=bool true
  gconftool -s /apps/guake/style/font/style --type=string "Monospace 13"
fi
if [[ ${INSTALL_GIT_POWER} == true ]]; then
  #======================================| Add GIT tools and configure GIT
  sudo apt-get ${APTGET_VERBOSE} install gitg meld git-gui gitk nautilus-compare
  # mostly based off http://cheat.errtheblog.com/s/git
  git config --global alias.st status
  git config --global alias.ci commit
  git config --global alias.br branch
  git config --global alias.co checkout
  git config --global alias.df diff
  git config --global alias.lg "log --graph --pretty=format:'%C(blue)%h %Creset%C(reverse bold blue)%d%Creset %C(white)%s %C(green bold)%cr%Creset %C(green)%aN' --abbrev-commit --decorate"
  # can't seem to isolate ! in command > git config --global alias.clear "!git add -A && git reset --hard"
  git config --global alias.unstage "reset HEAD --"
  git config --global alias.ign "ls-files -o -i --exclude-standard"
  # can't seem to isolate ! in command > git config --global alias.gitkconflict "!gitk --left-right HEAD...MERGE_HEAD"
  git config --global alias.alias "config --get-regexp alias"
  git config --global apply.whitespace error-all
  git config --global color.ui auto
  git config --global color.diff.whitespace "red reverse"
  git config --global color.diff.meta "magenta"
  git config --global color.diff.frag "yellow"
  git config --global color.diff.old "red"
  git config --global color.diff.new "green bold"
  git config --global color.grep.context yellow
  git config --global color.grep.filename blue
  git config --global color.grep.function "yellow bold"
  git config --global color.grep.linenumber "cyan bold"
  git config --global color.grep.match red bold
  git config --global color.grep.selected white
  git config --global color.grep.separator blue
  git config --global color.status.added yellow
  git config --global color.status.changed red
  git config --global color.status.untracked "cyan bold"
  git config --global diff.tool meld
  git config --global gui.editor geany
  git config --global merge.summary true
  git config --global merge.tool meld
fi

# Install Cheatsheet Wallpaper
wget ${WGET_VERBOSE} -O "${HOME}/Pictures/${CHEAT1##*/}" --referer="${REFERER}" --user-agent="${USERAGENT}" --header="${HEAD1}" --header="${HEAD2}" --header="${HEAD3}" --header="${HEAD4}" --header="${HEAD5}" "${CHEAT1}"
wget ${WGET_VERBOSE} -O "${HOME}/Pictures/${CHEAT2##*/}" --referer="${REFERER}" --user-agent="${USERAGENT}" --header="${HEAD1}" --header="${HEAD2}" --header="${HEAD3}" --header="${HEAD4}" --header="${HEAD5}" "${CHEAT2}"
wget ${WGET_VERBOSE} -O "${HOME}/Pictures/${CHEAT3##*/}" --referer="${REFERER}" --user-agent="${USERAGENT}" --header="${HEAD1}" --header="${HEAD2}" --header="${HEAD3}" --header="${HEAD4}" --header="${HEAD5}" "${CHEAT3}"
wget ${WGET_VERBOSE} -O "${HOME}/Pictures/${CHEAT4##*/}" --referer="${REFERER}" --user-agent="${USERAGENT}" --header="${HEAD1}" --header="${HEAD2}" --header="${HEAD3}" --header="${HEAD4}" --header="${HEAD5}" "${CHEAT4}"
wget ${WGET_VERBOSE} -O "${HOME}/Pictures/${CHEAT5##*/}" --referer="${REFERER}" --user-agent="${USERAGENT}" --header="${HEAD1}" --header="${HEAD2}" --header="${HEAD3}" --header="${HEAD4}" --header="${HEAD5}" "${CHEAT5}"

# Setup desktop
gconftool -s /desktop/gnome/background/picture_filename --type=string "${HOME}/Pictures/${DEFAULT_BG}"
gsettings set org.gnome.desktop.background primary-color '#adad7f7fa8a7'
gsettings set org.gnome.desktop.background draw-background true
gsettings set org.gnome.desktop.background picture-opacity 100
gsettings set org.gnome.desktop.background picture-options 'stretched'
gsettings set org.gnome.desktop.background picture-uri "file:///${HOME}/Pictures/${DEFAULT_BG}"
gsettings set org.gnome.desktop.background secondary-color '#201f4a4a8787'
gsettings set org.gnome.desktop.background color-shading-type 'horizontal'
# to monitor changes, use this:  gsettings monitor org.gnome.desktop.background

#======================================| INSTALL EXTRA INDICATORS
if [ "${INSTALL_EXTRA_INDICATORS}" ]; then
  new_indicators=""
  sudo apt-add-repository -y ppa:indicator-multiload/stable-daily && new_indicators="${new_indicators}indicator-multiload "
  sudo apt-add-repository -y ppa:kilian/f.lux                     && new_indicators="${new_indicators}fluxgui "
  #sudo apt-add-repository -y
  #sudo apt-add-repository -y
  #sudo apt-add-repository -y
  sudo apt-get update
  sudo apt-get ${APTGET_VERBOSE} install "${new_indicators}"
fi

#======================================| FIREFOX
# Install flash-plugin browser
sudo apt-get ${APTGET_VERBOSE} install flashplugin-installer
# Download FEBE backup file
wget ${WGET_VERBOSE} -O ${HOME}/profileFx4{ddd}.fbu --referer="${REFERER}" --user-agent="${USERAGENT}" --header="${HEAD1}" --header="${HEAD2}" --header="${HEAD3}" --header="${HEAD4}" --header="${HEAD5}" "${FEBE_URL}"

if [[ ${INSTALL_GIMP} == true ]]; then
  # Install graphics editors - weights about 25mb
  # sudo add-apt-repository ppa:otto-kesselgulasch/gimp
  # setup gimp ppa
  echo 'deb http://ppa.launchpad.net/otto-kesselgulasch/gimp/ubuntu precise main' | sudo tee -a /etc/apt/sources.list.d/otto-kesselgulasch-gimp-precise.list > /dev/null
  echo 'deb-src http://ppa.launchpad.net/otto-kesselgulasch/gimp/ubuntu precise main' | sudo tee -a /etc/apt/sources.list.d/otto-kesselgulasch-gimp-precise.list > /dev/null
  sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 614C4B38
  sudo apt-get update
  sudo apt-get ${APTGET_VERBOSE} install gimp gimp-data gimp-extras icc-profiles-free #install inkscape, + icc profiles  @TODO: suggest to user of non-free icc profiles
fi
if [[ ${INSTALL_INKSCAPE} == true ]]; then
  sudo apt-get ${APTGET_VERBOSE} install inkscape #install inkscape, color profiles disabled in this build of inkscape
fi
if [[ ${INSTALL_COMPASS} == true ]]; then
  # Install compass (which needs ruby)
  sudo apt-get ${APTGET_VERBOSE} install ruby1.9.1
  sudo gem1.9.1 install compass
fi
# Install chrome browser (Webkit - fork of KHTML/Konquerer, also used by Safari)
# sudo apt-get ${APTGET_VERBOSE} install chromium-browser
# sudo ln -s /usr/lib/flashplugin-installer/libflashplayer.so /usr/lib/chromium-browser/plugins/
