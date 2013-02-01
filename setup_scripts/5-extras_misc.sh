#!/bin/bash
set -e

#======================================| Theming Tools & Desktop Utilities
#======================================| Import Variables
# Make sure you have edited this file
source "${HOME}/${DDD_PATH}/setup_scripts/config.ini"
if [[ ${DEBUG} == true ]]; then set -x -v; fi


#======================================| PART1
#======================================| Setup PPA's and install
if [[ ${INSTALL_GRAPHIC_XTRAS} == true ]]; then
  GRAPHIC_PKS="ardesia unity-lens-graphicdesign unity-lens-utilities unity-lens-wikipedia"
  #======================================| Add Unity Scopes PPA
  echo 'deb http://ppa.launchpad.net/scopes-packagers/ppa/ubuntu precise main ' | sudo tee -a /etc/apt/sources.list.d/scopes-packagers-precise.list > /dev/null
  echo 'deb-src http://ppa.launchpad.net/scopes-packagers/ppa/ubuntu precise main ' | sudo tee -a /etc/apt/sources.list.d/scopes-packagers-precise.list > /dev/null
  sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 48894010
  Update_APT=1
fi
if [[ ${INSTALL_POWER_UTILS} == true ]]; then
  # power utils
  PWR_UTLS_PKS="synaptic bleachbit diodon diodon-plugins autokey-gtk xchat"
  #======================================| Add Diodon Clipboard Manager PPA
  echo 'deb http://ppa.launchpad.net/diodon-team/stable/ubuntu precise main' | sudo tee -a /etc/apt/sources.list.d/diodon-precise.list > /dev/null
  echo 'deb-src http://ppa.launchpad.net/diodon-team/stable/ubuntu precise main' | sudo tee -a /etc/apt/sources.list.d/diodon-precise.list > /dev/null
  sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 523884B2
  Update_APT=1
fi
if [[ ${INSTALL_TERMINAL_UTILS} == true ]]; then
  TERMINAL_PKS="guake nautilus-open-terminal grsync"
fi
if [[ ${INSTALL_GIT_POWER} == true ]]; then
  #======================================| Add GIT tools
  GIT_PKS="gitg meld git-gui gitk nautilus-compare"
fi
#======================================| INSTALL EXTRA INDICATORS
if [ "${INSTALL_EXTRA_INDICATORS}" == true ]; then
  unset new_indicators
  sudo apt-add-repository -y ppa:alanbell/unity && new_indicators+="unity-window-quicklists"" "
  sudo apt-add-repository -y ppa:bhdouglass/indicator-remindor && new_indicators+="indicator-remindor"" "
  sudo add-apt-repository -y ppa:indicator-multiload/stable-daily && new_indicators+="indicator-multiload"" "
  Update_APT=1
fi
# Install flash-plugin browser
FLASH_PKS="flashplugin-installer"
if [[ ${INSTALL_GIMP} == true ]]; then
  # Install graphics editors - weights about 25mb
  GIMP_PKS="gimp gimp-data gimp-extras icc-profiles-free" #  @TODO: suggest to user of non-free icc profiles
  # sudo add-apt-repository ppa:otto-kesselgulasch/gimp
  # setup gimp ppa
  echo 'deb http://ppa.launchpad.net/otto-kesselgulasch/gimp/ubuntu precise main' | sudo tee -a /etc/apt/sources.list.d/otto-kesselgulasch-gimp-precise.list > /dev/null
  echo 'deb-src http://ppa.launchpad.net/otto-kesselgulasch/gimp/ubuntu precise main' | sudo tee -a /etc/apt/sources.list.d/otto-kesselgulasch-gimp-precise.list > /dev/null
  sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 614C4B38
  Update_APT=1
fi
if [[ ${INSTALL_INKSCAPE} == true ]]; then
  INKSCAPE_PKS="inkscape"
fi
if [[ ${INSTALL_COMPASS} == true ]]; then
  # Install compass (which needs ruby)
  sudo apt-get ${APTGET_VERBOSE} install ruby1.9.1
  sudo gem1.9.1 install compass
fi
# Install chrome browser (Webkit - fork of KHTML/Konquerer, also used by Safari)
sudo apt-get ${APTGET_VERBOSE} install chromium-browser

if [ "$Update_APT" -gt 0 ]; then
  sudo apt-get update
fi

#======================================| Install packages
sudo apt-get ${APTGET_VERBOSE} install ${GRAPHIC_PKS} ${PWR_UTLS_PKS} ${TERMINAL_PKS} ${GIT_PKS} ${new_indicators} ${FLASH_PKS} ${GIMP_PKS} ${INKSCAPE_PKS}

#======================================| IMS
ANTIVIRUS = "clamav clamtk"
UBUNTU_TWEAKS = "compiz"
UTILITIES = "meld pidgin vlc gparted nautilus-dropbox virtualbox-4.2"
# To-do: Download and install appropriate VirtualBox Extension pack
sudo apt-get ${APTGET_VERBOSE} install ${ANTIVIRUS} ${UBUNTU_TWEAKS} ${UTILITIES}


#======================================| PART2
#======================================| Add some nice Configurations

if [[ ${INSTALL_POWER_UTILS} == true ]]; then
  #======================================| Diodon clipboard and Autokey automation
  # Whitelist autokey for Unity panel
  if grep -iq 'autokey-gtk' <(echo `gsettings get com.canonical.Unity.Panel systray-whitelist`); then
    echo "'Autokey' already exists in the Unity panel whitelist. Nothing to do here.";
  else echo "Adding 'Autokey' to Unity panel whitelist." && gsettings set com.canonical.Unity.Panel systray-whitelist "`echo \`gsettings get com.canonical.Unity.Panel systray-whitelist | tr -d ]\`,\'autokey-gtk\']`";
  fi
fi
if [[ ${INSTALL_TERMINAL_UTILS} == true ]]; then
  #Change Defaults for guake
  gconftool -s /apps/guake/keybindings/global/show_hide --type=string "F4"      # Change to F4 since F12 means firebug/dev utilities in most browsers
  gconftool -s /apps/guake/general/history_size --type=int 8192                 # more history
  gconftool -s /apps/guake/style/background/transparency --type=int 10          # Easier to see
  gconftool -s /apps/guake/general/window_ontop --type=bool false               # Alow dialog pop-ups to take focus
  gconftool -s /apps/guake/style/font/style --type=string "Monospace 13"        # Easier to see
fi
if [[ ${INSTALL_GIT_POWER} == true ]]; then
  #======================================| configure GIT Tools
  # mostly based off http://cheat.errtheblog.com/s/git
  git config --global alias.st status
  git config --global alias.ci commit
  git config --global alias.br branch
  git config --global alias.co checkout
  git config --global alias.df diff
  git config --global alias.lg "log --graph --pretty=format:'%C(blue)%h %Creset%C(reverse bold blue)%d%Creset %C(white)%s %C(green bold)%cr%Creset %C(green)%aN' --abbrev-commit --decorate"
  git config --global alias.clear '!git add -A && git reset --hard'
  git config --global alias.unstage "reset HEAD --"
  git config --global alias.ign "ls-files -o -i --exclude-standard"
  git config --global alias.gitkconflict '!gitk --left-right HEAD...MERGE_HEAD'
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
  git config --global instaweb.httpd 'apache2'
  git config --global merge.summary true
  git config --global merge.tool meld
fi

#======================================| KeePassX
if [[ ${INSTALL_KEEPASSX} == true ]]; then
  sudo apt-get ${APTGET_VERBOSE} install keepass2 xdotool
fi

#======================================| site: for hosts file rapid edition (french version)
ln -s ${HOME}/${DDD_PATH}/resources/site ${HOME}/bin/site

#======================================| INSTALL EXTRA INDICATORS
if [ "${INSTALL_EXTRA_INDICATORS}" == true ]; then
  if [ -f "/etc/xdg/autostart/unity-window-quicklists.desktop" ]; then # fix autostart bug if window quicklists is installed.  won't harm anything if ppa is already updated.
    sudo sed -i 's/OnlyShowIn=UNITY/OnlyShowIn=Unity/g' /etc/xdg/autostart/unity-window-quicklists.desktop
  fi
  #show all autostart applications
  sudo sed -i 's/NoDisplay=true/NoDisplay=false/g' /etc/xdg/autostart/*.desktop
fi

# Download FEBE backup file
wget ${WGET_VERBOSE} -O ${HOME}/profileFx4{ddd}.fbu --referer="${REFERER}" --user-agent="${USERAGENT}" --header="${HEAD1}" --header="${HEAD2}" --header="${HEAD3}" --header="${HEAD4}" --header="${HEAD5}" "${FEBE_URL}"

stage_finished=0
exit "$stage_finished"
