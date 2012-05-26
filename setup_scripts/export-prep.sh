#!/bin/bash

# dev and server

# Remove unneeded packages
sudo apt-get autoremove

# Clean out downloaded packages
sudo apt-get clean

# Clean up apt cache
sudo rm /var/lib/apt/lists/*   # 44mb
sudo rm /var/lib/apt/lists/partial/*

# empty trash
sudo rm -rf ~/.local/share/Trash/files/*
sudo rm -rf ~/.local/share/Trash/info/*

#clear bash history
cat /dev/null > ~/.bash_history
cat /dev/null > ~/.bash_eternal_history

#clear gnome history
cat /dev/null > ~/.local/share/recently-used.xbel

#clear logs
sudo find /var/log/ -name '*.gz' -type f -print0 -exec rm '{}' \;
sudo logrotate -f -s /home/quickstart/quickstart/setup_scripts/logs/logrotate-status.log /home/quickstart/config/clear-all-logs.conf

# Zero-fill unused sectors on vm disk
# Zero-filled sectors compress very nice :-)
# No need to export sectors for files that could be "undeleted"
sudo dd if=/dev/zero of=/zerofile; sudo rm /zerofile
