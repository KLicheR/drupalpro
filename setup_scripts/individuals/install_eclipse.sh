#!/bin/bash
set -e

#======================================| Import Variables
# CWD based on http://stackoverflow.com/questions/59895/can-a-bash-script-tell-what-directory-its-stored-in
CWD="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "${CWD}"/../config.ini

## Install java - 100mb
sudo apt-get ${APTGET_VERBOSE} install default-jre

#======================================| ECLIPSE
mkdir -p "${APP_FOLDER}"
cd "${APP_FOLDER}"
wget ${WGET_VERBOSE} -O "${APP_FOLDER}/eclipse.tar.gz" --referer="${REFERER}" --user-agent="${USERAGENT}" --header="${HEAD1}" --header="${HEAD2}" --header="${HEAD3}" --header="${HEAD4}" --header="${HEAD5}" "${ECLIPSE_URL}"
tar -xvf eclipse.tar.gz && rm eclipse.tar.gz
if [ -e ${APP_FOLDER}/eclipse/icon.xpm ]; then sudo cp ${APP_FOLDER}/eclipse/icon.xpm /usr/share/pixmaps/eclipse.xpm; fi
if [ -e ${APP_FOLDER}/eclipse/plugins/org.eclipse.platform_3.6.2.v201102101200/eclipse48.png ]; then sudo cp ${APP_FOLDER}/eclipse/plugins/org.eclipse.platform_3.6.2.v201102101200/eclipse48.png /usr/share/pixmaps/eclipse.png; fi
if [ -e ${APP_FOLDER}/eclipse-php/configuration/org.eclipse.osgi/bundles/224/1/.cp/icons/eclipse48.png ]; then sudo cp ${APP_FOLDER}/eclipse-php/configuration/org.eclipse.osgi/bundles/224/1/.cp/icons/eclipse48.png /usr/share/pixmaps/eclipse.png; fi
mkdir -p "${HOME}/.local/share/applications"
cat > "${HOME}/.local/share/applications/Eclipse.desktop" <<END
#!/usr/bin/env xdg-open
[Desktop Entry]
Type=Application
Name=Eclipse
Comment=Eclipse Integrated Development Environment
Icon=${APP_FOLDER}/eclipse/icon.xpm
Exec=${APP_FOLDER}/eclipse/eclipse
Terminal=false
Categories=Development;IDE;Java;
END
chmod 750 "${HOME}/.local/share/applications/Eclipse.desktop"