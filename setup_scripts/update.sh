#!/bin/bash
set -e

#======================================| Import Variables
# Make sure you have edited this file
# CWD based on http://stackoverflow.com/questions/59895/can-a-bash-script-tell-what-directory-its-stored-in
CWD="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "${CWD}"/config.ini
if [[ ${DEBUG} == true ]]; then set -x -v; fi

################################################################################
# Prompt to ensure user has backed up system
################################################################################
AREYOUSURE=$(zenity \
  --list \
  --radiolist  \
  --hide-column=2 \
  --column "" true abort "Abort!  Let's get our of here Robot, I forgot to snapshot first" false virtual "Silence, you ninny. I don't care if you bork my setup.  Run this update!" false standard "Do it! I took a snapshot first, lets update!" \
  --column value \
  --column Description \
  --width=400 \
  --height=300 \
  --title="Update DrupalPro" \
  --text="\
Danger Will Robinson!

Did you snapshot your DrupalPro VM? Running an update has the potential to totally bork your setup.
It's recommended to shutdown and take a snapshot first.
" \
)

UserAbort=$?
if [ "$AREYOUSURE" == "abort" ]; then UserAbort=3; fi
if [ "$UserAbort" -eq 5 ]; then UserAbort=0; fi # @FIXME: reset to 0 because zenity has a bug & timeout disabled
if [ "$UserAbort" -ne 0 ]; then # if cancel button(1), choose abort(3), or timeout(5) then exit with code
  echo "Aborted: $UserAbort (key: cancel=1, abort=2, time out=5).  Nothing was changed."
  exit $UserAbort;
fi

cd ${HOME}/${DDD_PATH}
git pull
bash "setup_scripts/updates.inc"

stage_finished=0
exit "$stage_finished"
