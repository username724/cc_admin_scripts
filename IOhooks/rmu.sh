#!/bin/bash
# rmu (aka remove users, rm_users, rmUsers) by Nic Wagner
# NOTE: All login/out-hooks must exit with a status of zero no matter what!!
# ver 1.0.0 (07.15.10) interactive script to remove folders by with given 3 digits
# ver 1.1.0 (01.27.2011) used extended globs to rm all but !(ard|shared)
# ver 1.1.1 (05.27.2011) extended globs version pushed to new file "rmUsersALL"
# ver 1.2.0 (05.04.2011) used find to get folders older than 7 days, used touch to protect ard & shared
# ver 1.2.1 (05.17.2011) used find like before, but protect ard & shared with grep -v 'pattern'
# ver 1.2.2 (07.28.2011) added 'eng' to users not to delete
# ver 2.0.0 (11.28.2011) added rm ALL users if capacity reaches 75% or more, & classroom to protected users
# ver 2.1.0 (11.29.2011) changed it so rm ALL actually only rm's all older than 2 hours
# ver 3.0.0 (11.29.2012) added tests and checks so we don't rm essential users
# ver 3.1.0 (03.13.2013) fixed grep code and test for User folder before touching it, more commenting
#========================================================================================================
# Sanity check
TEST=/Volumes/SCA_MacHD/Users/ard
# Check the disk capacity
CAP=`df -k /Volumes/SCA_MacHD | sed -e 1d|head -3 | tr -s ' ' | cut -d ' ' -f5 | sed 's/%//'`
ALERT="75"
# Safety Net = Redundant uses touch and grep in succession to keep us safe from the langoliers
# First: touch really super important user folders that will be there in any image
touch /Volumes/SCA_MacHD/Users
touch /Volumes/SCA_MacHD/Users/Shared
touch /Volumes/SCA_MacHD/Users/ard
touch /Volumes/SCA_MacHD/Users/temp

# Second: check for the various user folders that we would want to keep if the exist, if they're there touch em
if [ -d /Volumes/SCA_MacHD/Users/eng ]
then
	touch /Volumes/SCA_MacHD/Users/eng
fi

if [ -d /Volumes/SCA_MacHD/Users/temp ]
then
	touch /Volumes/SCA_MacHD/Users/temp
fi

if [ -d /Volumes/SCA_MacHD/Users/classroom ]
then
	touch /Volumes/SCA_MacHD/Users/classroom
fi

if [ -d /Volumes/SCA_MacHD/Users/spare ]
then
	touch /Volumes/SCA_MacHD/Users/spare
fi

if [ -d /Volumes/SCA_MacHD/Users/auto ]
then
	touch /Volumes/SCA_MacHD/Users/auto
fi

if [ -d /Volumes/SCA_MacHD/Users/student ]
then
	touch /Volumes/SCA_MacHD/Users/student
fi
# END Safety Net (the redundant check after this is the grep code)

# Tell STDOUT that we're running (for the system log of course)
echo "RMU RUNNING!!"

if [[ "$CAP" -ge "75" ]]; then
	echo "ALERT!! ALERT!! CAPACITY IS > 75%!!"
	echo "removing ALL non-essential user folders not used in the last 4 hours"
	find /Volumes/SCA_MacHD/Users -maxdepth 1 -type d -mtime +2h | grep -v '\(ard\)\|\(Shared\)\|\(eng\)\|\(classroom\)\|\(temp\)|\(student\)' | xargs rm -Rf
	echo "END RMU!!"
	exit 0
elif [[ -d "${TEST}" && ! -L "${TEST}" ]]
then
	echo "REMOVING DEPRECATED USERS!"
	find /Volumes/SCA_MacHD/Users -maxdepth 1 -type d -mtime +7d | grep -v '\(ard\)\|\(Shared\)\|\(eng\)\|\(classroom\)\|\(temp\)|\(student\)' | xargs rm -Rf
	echo "END RMU!!"
	exit 0
else
 	echo "WE'RE NOT IN KANSAS, WE'RE IN ARKANSAS!!"
 	echo "Actually, this does not appear to be a lab machine so NVM..."
 	echo "END RMU!!"
 	exit 0
fi