#!/bin/bash
set -e

#======================================| Import Variables
# Make sure you have edited this file
source "${HOME}/${DDD_PATH}/setup_scripts/config.ini"
if [[ ${DEBUG} == true ]]; then set -x -v; fi

# final size
if [ "${EXTRA_DEBUG_INFO}" = true ]; then
  df -h -T > ${HOME}/${DDD_PATH}/setup_scripts/logs/size-end.log
fi

# Manual config instructions.
echo "Installation is complete.

If you intend to export this installation, run this command...
		bash -x ~/drupalpro/setup_scripts/export-prep.sh
...shutdown, compact VM hard drives and export virtual machine.

Press \"Enter\" to exit"
read

stage_finished=0
exit "$stage_finished"
