#!/bin/bash
set -e

#======================================| Theming Tools & Desktop Utilities
#======================================| Import Variables
# Make sure you have edited this file
source "${HOME}/${DDD_PATH}/setup_scripts/config.ini"
if [[ ${DEBUG} == true ]]; then set -x -v; fi

#======================================| PART2
#======================================| Add some nice Configurations
if [[ ${INSTALL_GIT_POWER} == true ]]; then
  #======================================| configure GIT Tools
  # mostly based off http://cheat.errtheblog.com/s/git
  git config --global alias.st status
  git config --global alias.ci commit
  git config --global alias.br branch
  git config --global alias.co checkout
  git config --global alias.df diff
  git config --global alias.lg "log --graph --pretty=format:'%C(blue)%h %Creset%C(reverse bold blue)%d%Creset %C(white)%s %C(green bold)%cr%Creset %C(green)%aN' --abbrev-commit --decorate"
  git config --global alias.clear '!git add -A && git reset --hard'
  git config --global alias.unstage "reset HEAD --"
  git config --global alias.ign "ls-files -o -i --exclude-standard"
  git config --global alias.alias "config --get-regexp alias"
  git config --global apply.whitespace error-all
  git config --global color.ui auto
  git config --global color.diff.whitespace "red reverse"
  git config --global color.diff.meta "magenta"
  git config --global color.diff.frag "yellow"
  git config --global color.diff.old "red"
  git config --global color.diff.new "green bold"
  git config --global color.grep.context yellow
  git config --global color.grep.filename blue
  git config --global color.grep.function "yellow bold"
  git config --global color.grep.linenumber "cyan bold"
  git config --global color.grep.match red bold
  git config --global color.grep.selected white
  git config --global color.grep.separator blue
  git config --global color.status.added yellow
  git config --global color.status.changed red
  git config --global color.status.untracked "cyan bold"
  git config --global diff.tool meld
  git config --global instaweb.httpd 'apache2'
fi

#======================================| site: for hosts file rapid edition (french version)
mkdir ${HOME}/bin
ln -s ${HOME}/${DDD_PATH}/resources/site ${HOME}/bin/site

stage_finished=0
exit "$stage_finished"
