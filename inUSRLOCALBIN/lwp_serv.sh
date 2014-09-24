#!/bin/bash
# chan
# changed lwp_serv.sh to check remote file then set local switch file
# - /private/var/root/check.txt
# note 3 hours in seconds is 10800
TST=/Volumes/SCA_MacHD/private/var/root
RSWITCH=`grep -e '[(on|off)]' /Volumes/LWP/check.txt`
LSWITCH=`grep -e '[(on|off)]' /Volumes/SCA_MacHD/private/var/root/check.txt`
LFT=`stat -c %Y /Volumes/SCA_MacHD/private/var/root/check.txt`
LET=`date +%s`
CKT=`expr $LET - $LFT`

cd /


# this function checks the remote file if called
function check_rswitch() {
	osascript /usr/local/bin/mnt_LWP.scpt
	#check server side check.txt if on or off
	echo "the server switch is ${RSWITCH}"
	if [ ${RSWITCH} == 'on' ] || [ ${RSWITCH} == 'off' ] ; then
		if [[ -d ${TST} ]]; then
			touch /Volumes/SCA_MacHD/private/var/root/check.txt
			echo ${RSWITCH} > /Volumes/SCA_MacHD/private/var/root/check.txt
			umount /Volumes/LWP
			sleep 5
		fi
	else
		umount /Volumes/LWP
		echo "Something went wrong"
		echo "BAGGER 288!!"
	fi
}

# this function checks the local file
function check_lswitch() {
	if [ ${LSWITCH} == 'on' ]; then
		shutdown -h now
		exit 0
	else
		echo "LWP is off"
		exit 0
	fi
}

# this is the main function of this script
function main_check() {
	if [ "${CKT}" -ge 10800 ]; then
		check_rswitch
		wait $!
		sleep 3
		check_lswitch
	else
		check_lswitch
	fi
}

# run the main function here
main_check

# all scripts that run over the login window have to exit 0
exit 0