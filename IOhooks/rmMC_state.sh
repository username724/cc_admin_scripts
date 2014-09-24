#!/bin/bash
# rmMCSTATE by Nic Wagner
# ver 1.0.0 (7.28.11) remove *all* MCSTATE files from system drive 
# ver 1.0.1 (8.31.11) changed mdfind to find (spotlight is disabled) && reworked error checking 
#=====================================================================================
TEST=/Volumes/SCA_MacHD/Users/ard
echo "RM_MCSTATE RUNNING!!"
if [[ -d "${TEST}" && ! -L "${TEST}" ]]; then
	cd /Volumes/SCA_MacHD
	echo "REMOVING MCSTATE FILES:"
	find -P /Volumes/SCA_MacHD/Users -name MCState | sed -e 's/.*/\"&\"/' | xargs rm -rf
	echo "END RM_MCSTATE!!"
	exit 0
else
	echo "ERROR COULD NOT VALIDATE SCA_MacHD!!"
	echo "END RM_MCSTATE!!"
	exit 0
fi