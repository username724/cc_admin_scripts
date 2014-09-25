#!/bin/sh
# loginhooks.sh by n!c
# this script calls whatever scripts we want to run when a user logs out
# Scripts called (all should be in /private/var/root/bin/IOhooks):
#  - N/A 20120514
#=============================================================#
# Simple variable for the path to our scripts
CRIPTZ=/private/var/root/bin/IOhooks
# Tell STDOUT that we're running (for the system log of course)
echo "LOGIN HOOKS RUNNING!"

# login & out hooks always have to exit 0
echo "END LOGIN HOOKS"
exit 0
