Project Page: http://drupal.org/project/drupalpro

Before installation, customize settings to your liking in the file: CONFIG
Installation: ~/drupalpro/setup_scripts/install.sh

Support:      IRC:  #drupalpro
              Issue Queue:

Known Issues: The first few times you run the machine after install, there is a
              "popup error" related to unity.  It goes away.  There are probably
              a few other minor issues.  Please file a bug on the project page
              (above) or let us know in IRC #drupal-desktop and we'll fix!


Folders
=======
config          = Used during setup by setup_scripts for general preparation
contrib         = Community contributed utility scripts
drush           = Useful Drush add-ons
make_templates  = Used during setup by setup_scripts to prepare drush environment
setup_scripts   = Run in clean ubuntu environment to setup Drupal Development
                  Desktop (DDD).  Care should be used if attempting to run on a
                  physical machine.  Although the scripts will (likely/mostly)
                  work, DDD is currently less secure than a normal Ubuntu install
                  and is intended to run behind a firewall on your PC.

                    Installation:   ~/drupalpro/install.sh
                    Update:         ~/drupalpro/update.sh
