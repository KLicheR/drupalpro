#!/bin/bash

NETBEANS_URL="http://download.netbeans.org/netbeans/7.1.2/final/bundles/netbeans-7.1.2-ml-php-linux.sh"
# To install Netbeans beta, remove the comment below
#NETBEANS_URL="http://download.netbeans.org/netbeans/7.2/beta/bundles/netbeans-7.2beta-ml-php-linux.sh"

# eclipse http://www.eclipse.org/pdt/downloads/
if [ `uname -p` == "x86_64" ]
then
  # Quickstart1 alternative |ECLIPSE_URL="http://ftp.osuosl.org/pub/eclipse/technology/epp/downloads/release/helios/SR2/eclipse-php-helios-SR2-linux-gtk-x86_64.tar.gz"
  ECLIPSE_URL="http://zend-sdk.googlecode.com/files/eclipse-php-3.0.2.v20120511142-x86_64.tar.gz"
else
  # Quickstart1 |ECLIPSE_URL="http://ftp.osuosl.org/pub/eclipse/technology/epp/downloads/release/helios/SR2/eclipse-php-helios-SR2-linux-gtk.tar.gz"
  ECLIPSE_URL="http://zend-sdk.googlecode.com/files/eclipse-php-3.0.2.v20120511142-x86.tar.gz"
fi
echo "*** ECLIPSE URL: $ECLIPSE_URL"

cd ~

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
wget -nv -O geany-themes.tar.bz2 https://github.com/downloads/codebrainz/geany-themes/geany-themes-0.21.tar.bz2
tar jxf geany-themes.tar.bz2
mv -f geany-themes-0.21/* ~/.config/geany/
rm geany-themes.tar.bz2
rm -r geany-themes-0.21

# GEANY: Install extra tag files
wget -nv -O ~/.config/geany/tags/geany-tags-drupal http://wiki.geany.org/_media/tags/drupal.php.tags
wget -nv -O ~/.config/geany/tags/geany-tags-php-5.3.5 http://wiki.geany.org/_media/tags/phpfull-5.3.5.php.tags
wget -nv -O ~/.config/geany/tags/geany-tags-js http://dl.yent.eu/em.js.tags
wget -nv -O ~/.config/geany/tags/geany-tags-css http://wiki.geany.org/_media/tags/standard.css.tags

## GUI IDE's

# Download and install eclipse - 167mb
wget -nv -O eclipse.tar.gz $ECLIPSE_URL
tar -xvf eclipse.tar.gz
sudo ln -s /home/quickstart/eclipse/eclipse /usr/bin/eclipse
rm eclipse.tar.gz
# PPA's are a good idea, but about 458mb!
#sudo add-apt-repository ppa:yogarine/eclipse/ubuntu && sudo apt-get update
#sudo DEBIAN_FRONTEND=noninteractive apt-get -yqq install eclipse eclipse-pdt eclipse-plugin-cvs eclipse-subclipse

# Download and install netbeans - 122mb
wget -nv -O netbeans.sh $NETBEANS_URL
chmod +x ./netbeans.sh
bash ./netbeans.sh --silent
rm netbeans.sh

