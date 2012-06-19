#!/bin/bash
set -e

# ################################################################################ Import Variables
# Make sure you have edited this file
source "${HOME}/${DDD}/setup_scripts/CONFIG"
if [[ ${DEBUG} == true ]]; then set -x; fi

cd

## Install java - 100mb
sudo apt-get -yq install default-jre

## Lightweight Editors
sudo apt-get -yq install gedit-plugins

# Config gedit-2
gconftool-2 -s /apps/gedit-2/preferences/editor/auto_indent/auto_indent --type=bool true
gconftool-2 -s /apps/gedit-2/preferences/editor/bracket_matching/bracket_matching --type=bool true
gconftool-2 -s /apps/gedit-2/preferences/editor/line_numbers/display_line_numbers --type=bool true
gconftool-2 -s /apps/gedit-2/preferences/editor/current_line/highlight_current_line --type=bool true
gconftool-2 -s /apps/gedit-2/preferences/editor/right_margin/display_right_margin --type=bool true
gconftool-2 -s /apps/gedit-2/preferences/editor/wrap_mode/wrap_mode --type=string GTK_WRAP_NONE
gconftool-2 -s /apps/gedit-2/preferences/editor/tabs/insert_spaces --type=bool true
gconftool-2 -s /apps/gedit-2/preferences/editor/tabs/tabs_size --type=integer 2
gconftool-2 -s /apps/gedit-2/preferences/editor/save/auto_save --type=bool true


# INSTALL GEANY & SETUP FOR DRUPAL / WEB DEVELOPMENT
# Geany is a small fast IDE (based on scintilla ... also what notepad++ is also built on)
# info: http://en.wikipedia.org/wiki/Geany
sudo apt-get install -yq geany
mkdir -p ~/.config/geany/tags

# GEANY: Extra color themes
wget "$verbose" -O geany-themes.tar.bz2 --referer="${REFERER}" --user-agent="${USERAGENT}" --header="${HEAD1}" --header="${HEAD2}" --header="${HEAD3}" --header="${HEAD4}" --header="${HEAD5}" "${GEANY_THEME}"
tar jxf geany-themes.tar.bz2
mv -f geany-themes-0.21/* ~/.config/geany/
rm geany-themes.tar.bz2
rm -r geany-themes-0.21

# GEANY: Install extra tag files
wget "$verbose" -O ~/.config/geany/tags/geany-tags-drupal --referer="${REFERER}" --user-agent="${USERAGENT}" --header="${HEAD1}" --header="${HEAD2}" --header="${HEAD3}" --header="${HEAD4}" --header="${HEAD5}" "${GEANY_DRUPAL}"
wget "$verbose" -O ~/.config/geany/tags/geany-tags-php-5.3.5 --referer="${REFERER}" --user-agent="${USERAGENT}" --header="${HEAD1}" --header="${HEAD2}" --header="${HEAD3}" --header="${HEAD4}" --header="${HEAD5}" "${GEANY_PHP}"
wget "$verbose" -O ~/.config/geany/tags/geany-tags-js --referer="${REFERER}" --user-agent="${USERAGENT}" --header="${HEAD1}" --header="${HEAD2}" --header="${HEAD3}" --header="${HEAD4}" --header="${HEAD5}" "${GEANY_JS}"
wget "$verbose" -O ~/.config/geany/tags/geany-tags-css --referer="${REFERER}" --user-agent="${USERAGENT}" --header="${HEAD1}" --header="${HEAD2}" --header="${HEAD3}" --header="${HEAD4}" --header="${HEAD5}" "${GEANY_CSS}"

# Download and install eclipse - 167mb
wget "$verbose" -O eclipse.tar.gz --referer="${REFERER}" --user-agent="${USERAGENT}" --header="${HEAD1}" --header="${HEAD2}" --header="${HEAD3}" --header="${HEAD4}" --header="${HEAD5}" "${ECLIPSE_URL}"
tar -xvf eclipse.tar.gz
sudo ln -s "${HOME}"/eclipse/eclipse /usr/bin/eclipse
rm eclipse.tar.gz

# Download and install netbeans - 122mb
wget "$verbose" -O netbeans.sh --referer="${REFERER}" --user-agent="${USERAGENT}" --header="${HEAD1}" --header="${HEAD2}" --header="${HEAD3}" --header="${HEAD4}" --header="${HEAD5}" "${NETBEANS_URL}"
chmod +x ./netbeans.sh
bash ./netbeans.sh --silent --nospacecheck
rm netbeans.sh

# Download Netbeans preferences used for importing
wget "$verbose" -O ~/Desktop/netbeans-prefs.zip --referer="${REFERER}" --user-agent="${USERAGENT}" --header="${HEAD1}" --header="${HEAD2}" --header="${HEAD3}" --header="${HEAD4}" --header="${HEAD5}" "${NETBEANS_PREF}"
