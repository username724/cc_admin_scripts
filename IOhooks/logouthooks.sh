#!/bin/sh
# logouthooks.sh by n!c
# this script calls whatever scripts we want to run when a user logs out
# located in /private/var/root/bin/IOhooks
#=============================================================
# Variable for the path to our scripts
CRIPTZ=/private/var/root/bin/IOhooks
# Tell STDOUT that we're running (for the system log of course)
echo "LOGOUT HOOKS RUNNING!!"
sh $CRIPTZ/rmu.sh
wait
sh $CRIPTZ/rmMC_state.sh
wait
sh $CRIPTS/scratch_permissions.sh
wait
echo "END LOGOUT HOOKS!"
#logout hooks must exit with a zero status
exit 0