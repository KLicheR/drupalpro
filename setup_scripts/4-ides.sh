#!/bin/bash
set -e

#======================================| Import Variables
# Make sure you have edited this file
source "${HOME}/${DDD}/setup_scripts/CONFIG"
if [[ ${DEBUG} == true ]]; then set -x -v; fi

#======================================| JRE
# REQUIREMENT for Netbeans / Eclipse / Apatana
if [[ "${INSTALL_NETBEANS}" == true ]] || [[ "${INSTALL_NETBEANS}" == true ]] || [[ "${INSTALL_APTANA}" == true ]] || [[ "${INSTALL_JRE}" == true ]]; then
  ## Install java - 100mb
  sudo apt-get ${APTGET_VERBOSE} install default-jre
fi

#======================================| Lightweight Editors
#======================================| GEDIT
if [[ "${INSTALL_GEDIT}" == true ]]; then
  sudo apt-get ${APTGET_VERBOSE} install gedit-plugins

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
fi

#======================================| GEANY
# INSTALL GEANY & SETUP FOR DRUPAL / WEB DEVELOPMENT
# Geany is a small fast IDE (based on scintilla ... also what notepad++ is also built on)
# info: http://en.wikipedia.org/wiki/Geany
if [[ "${INSTALL_GEANY}" == true ]]; then
  sudo apt-get install -yq geany
  mkdir -p ${HOME}/.config/geany/tags

  # GEANY: Extra color themes
  cd
  wget ${WGET_VERBOSE} -O ${HOME}/geany-themes.tar.bz2 --referer="${REFERER}" --user-agent="${USERAGENT}" --header="${HEAD1}" --header="${HEAD2}" --header="${HEAD3}" --header="${HEAD4}" --header="${HEAD5}" "${GEANY_THEME}"
  tar jxf geany-themes.tar.bz2 && rm geany-themes.tar.bz2
  mv -f geany-themes-0.21/* ${HOME}/.config/geany/
  rm -r geany-themes-0.21

  # GEANY: Install extra tag files
  wget ${WGET_VERBOSE} -O ${HOME}/.config/geany/tags/geany-tags-drupal --referer="${REFERER}" --user-agent="${USERAGENT}" --header="${HEAD1}" --header="${HEAD2}" --header="${HEAD3}" --header="${HEAD4}" --header="${HEAD5}" "${GEANY_DRUPAL}"
  wget ${WGET_VERBOSE} -O ${HOME}/.config/geany/tags/geany-tags-php-5.3.5 --referer="${REFERER}" --user-agent="${USERAGENT}" --header="${HEAD1}" --header="${HEAD2}" --header="${HEAD3}" --header="${HEAD4}" --header="${HEAD5}" "${GEANY_PHP}"
  wget ${WGET_VERBOSE} -O ${HOME}/.config/geany/tags/geany-tags-js --referer="${REFERER}" --user-agent="${USERAGENT}" --header="${HEAD1}" --header="${HEAD2}" --header="${HEAD3}" --header="${HEAD4}" --header="${HEAD5}" "${GEANY_JS}"
  wget ${WGET_VERBOSE} -O ${HOME}/.config/geany/tags/geany-tags-css --referer="${REFERER}" --user-agent="${USERAGENT}" --header="${HEAD1}" --header="${HEAD2}" --header="${HEAD3}" --header="${HEAD4}" --header="${HEAD5}" "${GEANY_CSS}"
fi

#======================================| ECLIPSE
if [[ "${INSTALL_ECLIPSE}" == true ]]; then
  cd
  wget ${WGET_VERBOSE} -O "${HOME}/eclipse.tar.gz" --referer="${REFERER}" --user-agent="${USERAGENT}" --header="${HEAD1}" --header="${HEAD2}" --header="${HEAD3}" --header="${HEAD4}" --header="${HEAD5}" "${ECLIPSE_URL}"
  tar -xvf eclipse.tar.gz && rm eclipse.tar.gz
  if [ -e ${HOME}/eclipse/icon.xpm /usr/share/pixmaps/eclipse.xpm ]; then sudo cp ${HOME}/eclipse/icon.xpm /usr/share/pixmaps/eclipse.xpm; fi
  if [ -e ${HOME}/eclipse/plugins/org.eclipse.platform_3.6.2.v201102101200/eclipse48.png ]; then sudo cp ${HOME}/eclipse/plugins/org.eclipse.platform_3.6.2.v201102101200/eclipse48.png /usr/share/pixmaps/eclipse.png; fi
  if [ -e ${HOME}/eclipse-php/configuration/org.eclipse.osgi/bundles/224/1/.cp/icons/eclipse48.png ]; then sudo cp ${HOME}/eclipse-php/configuration/org.eclipse.osgi/bundles/224/1/.cp/icons/eclipse48.png /usr/share/pixmaps/eclipse.png; fi
#  if [ -e ${HOME}/eclipse/eclipse ]; then sudo ln -s "${HOME}/eclipse/eclipse" /usr/bin/eclipse; fi
  cat > ${HOME}/Desktop/Eclipse.desktop <<END
#!/usr/bin/env xdg-open
[Desktop Entry]
Type=Application
Name=Eclipse
Comment=Eclipse Integrated Development Environment
Icon=/usr/share/pixmaps/eclipse.xpm
Exec=${HOME}/eclipse/eclipse
Terminal=false
Categories=Development;IDE;Java;
END
chmod 750 ${HOME}/Desktop/Eclipse.desktop

fi

#======================================| APTANA
if [[ "${INSTALL_APTANA}" == true ]]; then
  cd
  wget ${WGET_VERBOSE} -O aptana.zip --referer="${REFERER}" --user-agent="${USERAGENT}" --header="${HEAD1}" --header="${HEAD2}" --header="${HEAD3}" --header="${HEAD4}" --header="${HEAD5}" "${APTANA_URL}"
  unzip -q aptana.zip
  rm aptana.zip

cat > ${HOME}/Desktop/AptanaStudio3.desktop <<END
#!/usr/bin/env xdg-open
[Desktop Entry]
Type=Application
Name=Aptana Studio 3
Comment=Aptana Integrated Development Environment
Icon=${HOME}/Aptana_Studio_3/icon.xpm
Exec=${HOME}/Aptana_Studio_3/AptanaStudio3
Terminal=false
Categories=Development;IDE;Java;
END
chmod 750 ${HOME}/Desktop/AptanaStudio3.desktop
fi

#======================================| NETBEANS
if [[ "${INSTALL_NETBEANS}" == true ]]; then
  cd
  wget ${WGET_VERBOSE} -O netbeans.sh --referer="${REFERER}" --user-agent="${USERAGENT}" --header="${HEAD1}" --header="${HEAD2}" --header="${HEAD3}" --header="${HEAD4}" --header="${HEAD5}" "${NETBEANS_URL}"
  chmod +x ./netbeans.sh
  bash ./netbeans.sh --silent --nospacecheck
  rm netbeans.sh
cat > ${HOME}/Desktop/Netbeans.desktop <<END
#!/usr/bin/env xdg-open
[Desktop Entry]
Type=Application
Name=Netbeans
Comment=Netbeans Integrated Development Environment
Icon=${HOME}/netbeans-7.1.2/nb/netbeans.png
Exec=${HOME}/netbeans-7.1.2/bin/netbeans
Terminal=false
Categories=Development;IDE;Java;
END
chmod 750 ${HOME}/Desktop/Netbeans.desktop

  # Download Netbeans preferences used for importing
  wget ${WGET_VERBOSE} -O ${HOME}/Desktop/netbeans-prefs.zip --referer="${REFERER}" --user-agent="${USERAGENT}" --header="${HEAD1}" --header="${HEAD2}" --header="${HEAD3}" --header="${HEAD4}" --header="${HEAD5}" "${NETBEANS_PREF}"
fi
