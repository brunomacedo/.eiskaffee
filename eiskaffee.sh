# IMPORT FILES
source $EISK_HOME/tools/settings.eisk
source $EISK_HOME/tools/system.eisk
source $EISK_HOME/lib/colors.eisk
source $EISK_HOME/lib/alias.eisk
source $EISK_HOME/lib/git.eisk
source $EISK_HOME/lib/npm.eisk
source $EISK_HOME/lib/rewrite.eisk
source $EISK_HOME/lib/develop.eisk
source $EISK_HOME/tools/rename.eisk
source $EISK_HOME/lib/kubernetes.eisk
source $EISK_HOME/tools/check_update.sh

if [ $(getSystemOS) = "Msys" ]; then
  source $EISK_HOME/lib/custom.eisk
fi
