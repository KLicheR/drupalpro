#!/bin/bash
set -e

#======================================| Import Variables
# Make sure you have edited this file
source "${HOME}/${DDD}/setup_scripts/CONFIG"
if [[ ${DEBUG} == true ]]; then set -x -v; fi

# add some useful git tools
sudo apt-get ${APTGET_VERBOSE} install gitg meld git-gui gitk
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


# Install some useful utilities for developing & theming in Ubuntu
# Synaptic Xchat gnote compass guake (instant shell) gufw (GUI for firewall)
sudo apt-get install -yq synaptic xchat gnote guake gufw p7zip autokey-gtk bleachbit ardesia

# Whitelist autokey for Unity panel
if grep -iq 'autokey-gtk' <(echo `gsettings get com.canonical.Unity.Panel systray-whitelist`); then
  echo "'Autokey' already exists in the Unity panel whitelist. Nothing to do here.";
else echo "Adding 'Autokey' to Unity panel whitelist." && gsettings set com.canonical.Unity.Panel systray-whitelist "`echo \`gsettings get com.canonical.Unity.Panel systray-whitelist | tr -d ]\`,\'autokey-gtk\']`"; fi

# Whitelist xchat for Unity panel
if grep -iq 'xchat' <(echo `gsettings get com.canonical.Unity.Panel systray-whitelist`); then
  echo "'xchat' already exists in the Unity panel whitelist. Nothing to do here.";
else echo "Adding 'xchat' to Unity panel whitelist." && gsettings set com.canonical.Unity.Panel systray-whitelist "`echo \`gsettings get com.canonical.Unity.Panel systray-whitelist | tr -d ]\`,\'xchat\']`"; fi

#Setup Firewall
sudo ufw enable
sudo ufw allow in proto tcp from any to any port 443
sudo ufw allow in proto tcp from any to any port 80

#Set default values for guake
gconftool -s /apps/guake/keybindings/global/show_hide --type=string "F4"
gconftool -s /apps/guake/general/history_size --type=int 8192
gconftool -s /apps/guake/style/background/transparency --type=int 10
gconftool -s /apps/guake/general/window_losefocus --type=bool true

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


#======================================| FIREFOX
# Install flash-plugin browser
sudo apt-get ${APTGET_VERBOSE} install flashplugin-installer
# Download FEBE backup file
wget ${WGET_VERBOSE} -O ${HOME}/profileFx4{ddd}.fbu --referer="${REFERER}" --user-agent="${USERAGENT}" --header="${HEAD1}" --header="${HEAD2}" --header="${HEAD3}" --header="${HEAD4}" --header="${HEAD5}" "${FEBE_URL}"
