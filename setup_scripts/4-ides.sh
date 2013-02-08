#!/bin/bash
set -e

#======================================| Import Variables
# Make sure you have edited this file
source "${HOME}/${DDD_PATH}/setup_scripts/config.ini"
if [[ ${DEBUG} == true ]]; then set -x -v; fi

#======================================| JRE
# REQUIREMENT for Netbeans / Eclipse / Apatana
if [[ "${INSTALL_NETBEANS}" == true ]] || [[ "${INSTALL_ECLIPSE}" == true ]] || [[ "${INSTALL_APTANA}" == true ]] || [[ "${INSTALL_JRE}" == true ]]; then
  ## Install java - 100mb
  sudo apt-get ${APTGET_VERBOSE} install default-jre
fi

#======================================| Lightweight Editors
#======================================| Bluefish
if [[ "${INSTALL_BLUEFISH}" == true ]]; then
  sudo apt-get ${APTGET_VERBOSE} install bluefish bluefish-data bluefish-plugins
fi

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

  # Config gedit in gnome3 / unity
  gsettings set org.gnome.gedit.preferences.editor auto-indent true
  gsettings set org.gnome.gedit.preferences.editor bracket-matching true
  gsettings set org.gnome.gedit.preferences.editor display-line-numbers true
  gsettings set org.gnome.gedit.preferences.editor display-right-margin true
  gsettings set org.gnome.gedit.preferences.editor editor-font 'Monospace 12'
  gsettings set org.gnome.gedit.preferences.editor ensure-trailing-newline true
  gsettings set org.gnome.gedit.preferences.editor highlight-current-line true
  gsettings set org.gnome.gedit.preferences.editor insert-spaces true
  gsettings set org.gnome.gedit.preferences.editor right-margin-position 80
  gsettings set org.gnome.gedit.preferences.editor scheme 'classic'
  gsettings set org.gnome.gedit.preferences.editor syntax-highlighting true
  gsettings set org.gnome.gedit.preferences.editor tabs-size 2
  gsettings set org.gnome.gedit.preferences.editor wrap-mode 'none'
  gsettings set org.gnome.gedit.plugins active-plugins "['bookmarks', 'bracketcompletion', 'codecomment', 'dashboard', 'snippets', 'filebrowser', 'spell', 'modelines', 'colorpicker', 'wordcompletion', 'zeitgeistplugin', 'sessionsaver', 'time', 'docinfo', 'multiedit']"
  gsettings set org.gnome.gedit.plugins.filebrowser enable-remote false
  gsettings set org.gnome.gedit.preferences.ui bottom-panel-visible false
  gsettings set org.gnome.gedit.preferences.ui side-panel-visible true
  gsettings set org.gnome.gedit.preferences.ui statusbar-visible true
fi

#======================================| SUBLIME TEXT 2
if [[ "${INSTALL_SUBLIME}" == true ]]; then
  mkdir -p "${APP_FOLDER}"
  cd "${APP_FOLDER}"
  wget ${WGET_VERBOSE} -O "${HOME}/sublime.tar.bz2" --referer="${REFERER}" --user-agent="${USERAGENT}" --header="${HEAD1}" --header="${HEAD2}" --header="${HEAD3}" --header="${HEAD4}" --header="${HEAD5}" "${SUBLIME_URL}"
  tar jxf "${HOME}/sublime.tar.bz2" && rm "${HOME}/sublime.tar.bz2"
  cd "${APP_FOLDER}/Sublime Text 2"
  chmod u=rwx,o= "${APP_FOLDER}/Sublime Text 2/sublime_text"
  mkdir -p "${HOME}/bin"
  ln -s "${APP_FOLDER}/Sublime Text 2/sublime_text" "${HOME}/bin/sublime"
  mkdir -p "${HOME}/.local/share/applications"
  cat > "${HOME}/.local/share/applications/Sublime.desktop" <<END
#!/usr/bin/env xdg-open
[Desktop Entry]
Version=1.0
Name=Sublime Text
GenericName=Text Editor
Comment=Edit source code
Encoding=UTF-8
Exec=sublime %F
Icon=${APP_FOLDER}/Sublime Text 2/Icon/48x48/sublime_text.png
Terminal=false
Type=Application
StartupNotify=true
MimeType=text/plain;
Categories=TextEditor;Development;Utility;
Actions=NewWindow;

[Desktop Action NewWindow]
Name=New Window
Exec=sublime -n
END

chmod 750 "${HOME}/.local/share/applications/Sublime.desktop"

cat > "${APP_FOLDER}/Sublime Text 2/README.txt" <<END

NOTICE:
Sublime Text is NOT Open Source software nor is it Freeware.  It was downloaded
and installed as part of DrupalPro so you may easily evaluate it because it is
a popular text editor.  It's just not simple for newbies to install.  You might
also want to search Synaptic or Ubuntu Software Center for other editors.

If you use & like Sublime Text, you should support the product and buy it:

http://www.sublimetext.com/buy


If you don't like it, or prefer to only use FOSS software, please delete it from
your system by deleting the folder or running this command from a terminal:

    rm -R ${APP_FOLDER}/Sublime Text 2



NOTICE FROM THE SUBLIME TEXT WEBSITE:
Sublime Text 2 may be downloaded and evaluated for free, however a license must
be purchased for continued use. There is currently no enforced time limit
for the evaluation.

Please submit feature requests to http://sublimetext.userecho.com/.
For notification about new versions, follow sublimehq on twitter.
END

# Install Sublime Text 2 Package Control (http://wbond.net/sublime_packages/package_control)
cd "${HOME}/.config/sublime-text-2/Installed Packages"
wget https://sublime.wbond.net/Package%20Control.sublime-package
fi

#======================================| GEANY
# INSTALL GEANY & SETUP FOR DRUPAL / WEB DEVELOPMENT
# Geany is a small fast IDE (based on scintilla ... also what notepad++ is also built on)
# info: http://en.wikipedia.org/wiki/Geany
if [[ "${INSTALL_GEANY}" == true ]]; then
  # add ppa for 1.22 version of Geany which fixes a bug in Unity
  echo 'deb http://ppa.launchpad.net/geany-dev/ppa/ubuntu precise main' | sudo tee -a /etc/apt/sources.list.d/geany-dev-precise.list > /dev/null
  echo 'deb-src http://ppa.launchpad.net/geany-dev/ppa/ubuntu precise main' | sudo tee -a /etc/apt/sources.list.d/geany-dev-precise.list > /dev/null
  sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys B3641232 &
  wait
  sudo apt-get update &
  wait

  sudo apt-get ${APTGET_VERBOSE} install geany geany-common geany-plugin-addons
  mkdir -p ${HOME}/.config/geany/tags

  # GEANY: Extra color themes
  cd ~
  wget ${WGET_VERBOSE} -O ${HOME}/geany-themes.tar.bz2 --referer="${REFERER}" --user-agent="${USERAGENT}" --header="${HEAD1}" --header="${HEAD2}" --header="${HEAD3}" --header="${HEAD4}" --header="${HEAD5}" "${GEANY_THEME}"
  tar jxf geany-themes.tar.bz2 && rm geany-themes.tar.bz2
  mv -f geany-themes-1.22/* ${HOME}/.config/geany/
  rm -r geany-themes-1.22

  # GEANY: Install extra tag files
  wget ${WGET_VERBOSE} -O ${HOME}/.config/geany/tags/geany-tags-drupal --referer="${REFERER}" --user-agent="${USERAGENT}" --header="${HEAD1}" --header="${HEAD2}" --header="${HEAD3}" --header="${HEAD4}" --header="${HEAD5}" "${GEANY_DRUPAL}"
  wget ${WGET_VERBOSE} -O ${HOME}/.config/geany/tags/geany-tags-php-5.3.5 --referer="${REFERER}" --user-agent="${USERAGENT}" --header="${HEAD1}" --header="${HEAD2}" --header="${HEAD3}" --header="${HEAD4}" --header="${HEAD5}" "${GEANY_PHP}"
  wget ${WGET_VERBOSE} -O ${HOME}/.config/geany/tags/geany-tags-js --referer="${REFERER}" --user-agent="${USERAGENT}" --header="${HEAD1}" --header="${HEAD2}" --header="${HEAD3}" --header="${HEAD4}" --header="${HEAD5}" "${GEANY_JS}"
  wget ${WGET_VERBOSE} -O ${HOME}/.config/geany/tags/geany-tags-css --referer="${REFERER}" --user-agent="${USERAGENT}" --header="${HEAD1}" --header="${HEAD2}" --header="${HEAD3}" --header="${HEAD4}" --header="${HEAD5}" "${GEANY_CSS}"
fi

#======================================| ECLIPSE
if [[ "${INSTALL_ECLIPSE}" == true ]]; then
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

fi

#======================================| APTANA
if [[ "${INSTALL_APTANA}" == true ]]; then
  mkdir -p "${APP_FOLDER}"
  cd "${APP_FOLDER}"
  wget ${WGET_VERBOSE} -O "${APP_FOLDER}/aptana.zip" --referer="${REFERER}" --user-agent="${USERAGENT}" --header="${HEAD1}" --header="${HEAD2}" --header="${HEAD3}" --header="${HEAD4}" --header="${HEAD5}" "${APTANA_URL}"
  unzip -q aptana.zip && rm aptana.zip
  mkdir -p "${HOME}/.local/share/applications"
  cat > "${HOME}/.local/share/applications/AptanaStudio3.desktop" <<END
#!/usr/bin/env xdg-open
[Desktop Entry]
Type=Application
Name=Aptana Studio 3
Comment=Aptana Integrated Development Environment
Icon=${APP_FOLDER}/Aptana_Studio_3/icon.xpm
Exec=${APP_FOLDER}/Aptana_Studio_3/AptanaStudio3
Terminal=false
Categories=Development;IDE;Java;
END
chmod 750 "${HOME}/.local/share/applications/AptanaStudio3.desktop"
fi

#======================================| NETBEANS
if [[ "${INSTALL_NETBEANS}" == true ]]; then
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
fi

stage_finished=0
exit "$stage_finished"
