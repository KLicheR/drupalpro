#!/bin/bash
set -e

#======================================| Import Variables
# CWD based on http://stackoverflow.com/questions/59895/can-a-bash-script-tell-what-directory-its-stored-in
CWD="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "${CWD}"/../config.ini

## Install java - 100mb
sudo apt-get ${APTGET_VERBOSE} install default-jre

#======================================| NETBEANS
mkdir -p "${APP_FOLDER}"
cd "${APP_FOLDER}"
wget ${WGET_VERBOSE} -O "${APP_FOLDER}/netbeans.sh" --referer="${REFERER}" --user-agent="${USERAGENT}" --header="${HEAD1}" --header="${HEAD2}" --header="${HEAD3}" --header="${HEAD4}" --header="${HEAD5}" "${NETBEANS_URL}"
chmod +x ./netbeans.sh
bash ./netbeans.sh --silent --nospacecheck
rm netbeans.sh
# Test if desktop icon exists, if so then move installation to Applications folder since netbeans installs to HOME by default
if [[ -f "$HOME/.local/share/applications/${NETBEANS_DESKTOP}.desktop" ]]; then
  # move netbeans to applicaitons folder
  mv "${HOME}/${NETBEANS_ROOT}" "${APP_FOLDER}/${NETBEANS_ROOT}"
  # and update paths in [Desktop Entry]
  sed -i "s|${HOME}/${NETBEANS_ROOT}|${APP_FOLDER}/${NETBEANS_ROOT}|g" "$HOME/.local/share/applications/${NETBEANS_DESKTOP}.desktop"
fi

# Download Netbeans preferences used for importing
wget ${WGET_VERBOSE} -O ${HOME}/Desktop/netbeans-prefs.zip --referer="${REFERER}" --user-agent="${USERAGENT}" --header="${HEAD1}" --header="${HEAD2}" --header="${HEAD3}" --header="${HEAD4}" --header="${HEAD5}" "${NETBEANS_PREF}"