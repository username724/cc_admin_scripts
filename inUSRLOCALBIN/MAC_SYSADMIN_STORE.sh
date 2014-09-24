#!/bin/bash
# MAC_SYSADMIN_STORE v2.5.3
# last edit: 20140522v01
# Functions:
# -> no_iCloud - set user template to not show iCloud prompt at login
# -> no_winAnims - turn off all the window animations
# -> no_SavedStates - stop OS from writing saved states
# -> yes_SavedStates - undo the saved states thing
# -> launchD_No_Index - pushes in the no_index and launchD magic
# -> no_timeMachine - don't offer new disks for time machine
# -> hide_PrefPanes - self explanatory
# -> hide_Apps - Hide launchpad and mission control
# -> UNhide_PrefPanes - yep
# -> clean_KeyAccess - clear the files that should not be imaged
# -> create_UserTemplate - roll "temp" into "User Tmeplate"
# -> no_Airdrop - disable AirDrop (10.7.3+ only) not in menu
# -> yes_Airdrop - enable AirDrop (10.7.3+ only) not in menu
# -> preNnetboot - a little house keeping then upload to DS
# -> set_next_netboot - just set next boot as netboot
# -> nohide_Apps - Unhides all the apps that hide_Apps hides.
# -> lInk_FromRootBin - Links scripts and executables from /private/var/root/bin/inUSRLOCALBIN to /usr/local/bin
# -> scratchPerms - opens up permissions for A/V Scratch disks && /Users/Shared
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

# setup our environment for us shall we
shopt -s extglob
printf "\e[8;25;72;t"

function lInk_FromRootBin() {
	## Remove the hardlinks if they are there ##
	rm -Rf /usr/local/bin/cc_maintain
	rm -Rf /usr/local/bin/ccFix_czecNrun
	rm -Rf /usr/local/bin/loginwinpoweroff.sh
	rm -Rf /usr/local/bin/lwp_serv.sh
	rm -Rf /usr/local/bin/macsoftware
	rm -Rf /usr/local/bin/no_index
	rm -Rf /usr/local/bin/SwitchAudioSource
	rm -Rf /usr/local/bin/sync_rootbin
	rm -Rf /usr/local/bin/sz_Adobecs6
	rm -Rf /usr/local/bin/rmu
	## Create HardLinks so we don't get "permission denied" ###
	ln /private/var/root/bin/inUSRLOCALBIN/cc_maintain /usr/local/bin
	ln /private/var/root/bin/inUSRLOCALBIN/ccFix_czecNrun /usr/local/bin
	ln /private/var/root/bin/inUSRLOCALBIN/loginwinpoweroff.sh /usr/local/bin
	ln /private/var/root/bin/inUSRLOCALBIN/lwp_serv.sh /usr/local/bin
	ln /private/var/root/bin/inUSRLOCALBIN/macsoftware /usr/local/bin
	ln /private/var/root/bin/inUSRLOCALBIN/SwitchAudioSource /usr/local/bin
	ln /private/var/root/bin/inUSRLOCALBIN/sync_rootbin /usr/local/bin
	cp -Rf /private/var/root/bin/inUSRLOCALBIN/sz_Adobecs6 /usr/local/bin
	ln /private/var/root/bin/inUSRLOCALBIN/no_index /usr/local/bin
	ln /private/var/root/bin/IOhooks/rmu /usr/local/bin

}
#end_lInk_FromRootBin

function no_iCloud() {
	defaults write /System/Library/User\ Template/Non_localized/Library/Preferences/com.apple.SetupAssistant DidSeeCloudSetup -boolean YES
	defaults write  /System/Library/User\ Template/English.lproj/Library/Preferences/com.apple.SetupAssistant DidSeeCloudSetup -boolean YES
}
# end no_iCloud

function no_winAnims() {
	# this stuff actually has to be run as temp (not sure how to script that)
	cd /
	defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false
	defaults write com.apple.finder DisableAllAnimations -bool true
	defaults write com.apple.dock autohide-time-modifier -float 0
	defaults write com.apple.dock autohide-delay -float 0
	defaults write com.apple.dock launchanim -bool false
	cd ~
}
# end no_winAnims

function no_SavedStates() {
	cd /
	defaults write NSGlobalDomain NSQuitAlwaysKeepsWindows -bool false
	# application saved states - force no write
	rm -Rf /Users/*/Library/Saved\ Application\ State/*
	chmod -R a-w /Users/*/Library/Saved\ Application\ State

	# reopen windows - force no write (even change owner)
	defaults write com.apple.loginwindow TALLogoutSavesState -bool false
	defaults write com.apple.loginwindow LoginwindowLaunchesRelaunchApps -bool false
	rm -Rf /Users/*/Library/Preferences/com.apple.loginwindow.plist.lockfile
	chmod augo-w /Users/*/Library/preferences/com.apple.loginwindow.plist
	chown root /Users/*/Library/Preferences/com.apple.loginwindow.plist
	####Last distch effort if windows keep opening####
	#x=$(ls /Users/*/Library/Preferences/ByHost/com.apple.loginwindow* | grep -v lock)
	#rm $x;
	#mkdir $x;
	#touch $x/f;
	####~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~####
	cd ~
}
# end no_SavedStates

function yes_SavedStates() {
	cd /
	chmod augo+w /Users/*/Library/Saved\ Application\ State
	chown _unknown /Users/*/Library/Preferences/com.apple.loginwindow.plist
	defaults write com.apple.loginwindow TALLogoutSavesState -bool true
	cd ~
}
# end yes_SavedStates

function launchD_No_Index() {
	# too much text for echo one liners so lets cat the text into files we need
	# first create the plist
	touch /tmp/com.index.no_index.plist
	# too much text for echo one liners so lets cat the text into files we need
	cat > /tmp/com.index.no_index.plist <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
"http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Label</key>
	<string>com.index.no_index</string>
	<key>Disabled</key>
	<false/>
	<key>Program</key>
	<string>/usr/local/bin/no_index</string>
	<key>StartOnMount</key>
	<true/>
	<key>RunAtLoad</key>
	<false/>
	<key>KeepAlive</key>
	<false/>
	<key>EnableTransactions</key>
	<true/>
</dict>
</plist>
EOF

	cp /private/var/root/bin/no_index /usr/local/bin
	chmod +x /usr/local/bin/no_index

	mv /tmp/com.index.no_index.plist /Library/LaunchAgents/com.index.no_index.plist
	cd /
	launchctl load -w /Library/LaunchAgents/com.index.no_index.plist
}
# end launchD_No_Index

function no_timeMachine(){
	rm -Rf /Library/Preferences/com.apple.TimeMachine.plist.lockfile
	defaults write /Library/Preferences/com.apple.TimeMachine DoNotOfferNewDisksForBackup 1
}
#end no_TimeMachine

function hide_Apps() {
	chflags hidden /Applications/Address\ Book.app
	chflags hidden /Applications/App\ Store.app
	chflags hidden /Applications/Avid_Uninstallers
	chflags hidden /Applications/Calendar.app
	chflags hidden /Applications/Chess.app
	chflags hidden /Applications/Contacts.app
	chflags hidden /Applications/Dashboard.app
	chflags hidden /Applications/Dictionary.app
	chflags hidden /Applications/FaceTime.app
	chflags hidden /Applications/Flip4Mac
	chflags hidden /Applications/Game\ Center.app
	chflags hidden /Applications/GarageBand.app
	chflags hidden /Applications/iBooks.app
	chflags hidden /Applications/iCal.app
	chflags hidden /Applications/iChat.app
	chflags hidden /Applications/Licenses
	chflags hidden /Applications/Mail.app
	chflags hidden /Applications/Maps.app
	chflags hidden /Applications/Messages.app
	chflags hidden /Applications/Mission\ Control.app
	chflags hidden /Applications/Notes.app
	chflags hidden /Applications/Photo\ Booth.app
	chflags hidden /Applications/Reminders.app
	chflags hidden /Applications/Stickies.app
	chflags hidden /Applications/support
	chflags hidden /Applications/Time\ Machine.app
	chflags hidden /Applications/Unity
	chflags hidden /Applications/Xcode.app
}
#end hide_Apps

function nohide_Apps() {
	chflags nohidden /Applications/Address\ Book.app
	chflags nohidden /Applications/App\ Store.app
	chflags nohidden /Applications/Avid_Uninstallers
	chflags nohidden /Applications/Calendar.app
	chflags nohidden /Applications/Chess.app
	chflags nohidden /Applications/Contacts.app
	chflags nohidden /Applications/Dashboard.app
	chflags nohidden /Applications/Dictionary.app
	chflags nohidden /Applications/FaceTime.app
	chflags nohidden /Applications/Flip4Mac
	chflags nohidden /Applications/Game\ Center.app
	chflags nohidden /Applications/GarageBand.app
	chflags nohidden /Applications/iBooks.app
	chflags nohidden /Applications/iCal.app
	chflags nohidden /Applications/iChat.app
	chflags nohidden /Applications/Licenses
	chflags nohidden /Applications/Mail.app
	chflags nohidden /Applications/Maps.app
	chflags nohidden /Applications/Messages.app
	chflags nohidden /Applications/Mission\ Control.app
	chflags nohidden /Applications/Notes.app
	chflags nohidden /Applications/Photo\ Booth.app
	chflags nohidden /Applications/Reminders.app
	chflags nohidden /Applications/Stickies.app
	chflags nohidden /Applications/support
	chflags nohidden /Applications/Time\ Machine.app
	chflags nohidden /Applications/Unity
	chflags nohidden /Applications/Xcode.app
}
#end nohide_Apps

function hide_PrefPanes(){
	cd /
	echo "About to CHMOD a bunch of PREF panes"
	chown -Rf root:admin /System/Library/PreferencePanes
	chown -Rf root:admin /Library/PreferencePanes
	chown -Rf root:admin /Library/Internet\ Plug-Ins/JavaAppletPlugin.plugin/Contents/Home/lib/deploy/JavaControlPanel.prefPane
	### System PrefPanes ###
	chmod -R 750 /System/Library/PreferencePanes/AppStore.prefPane
	chmod -R 750 /System/Library/PreferencePanes/Accounts.prefPane/
	chmod -R 750 /System/Library/PreferencePanes/Bluetooth.prefPane/
	chmod -R 750 /System/Library/PreferencePanes/DateAndTime.prefPane/
	chmod -R 750 /System/Library/PreferencePanes/Dock.prefPane/
	chmod -R 750 /System/Library/PreferencePanes/EnergySaver.prefPane/
	chmod -R 750 /System/Library/PreferencePanes/Expose.prefPane/
	chmod -R 750 /System/Library/PreferencePanes/FibreChannel.prefPane/
	chmod -R 750 /System/Library/PreferencePanes/iCloudPref.prefPane/
	chmod -R 750 /System/Library/PreferencePanes/InternetAccounts.prefPane/
	chmod -R 750 /System/Library/PreferencePanes/Ink.prefPane/
	##chmod -R 750 /System/Library/PreferencePanes/Keyboard.prefPane/
	chmod -R 750 /System/Library/PreferencePanes/Localization.prefPane/
	chmod -R 750 /System/Library/PreferencePanes/MobileMe.prefPane/
	chmod -R 750 /System/Library/PreferencePanes/Network.prefPane/
	chmod -R 750 /System/Library/PreferencePanes/Notifications.prefPane/
	chmod -R 750 /System/Library/PreferencePanes/ParentalControls.prefPane/
	chmod -R 750 /System/Library/PreferencePanes/PrintAndFax.prefPane/
	chmod -R 750 /System/Library/PreferencePanes/Security.prefPane/
	chmod -R 750 /System/Library/PreferencePanes/SharingPref.prefPane/
	chmod -R 750 /System/Library/PreferencePanes/SoftwareUpdate.prefPane/
	chmod -R 750 /System/Library/PreferencePanes/Spotlight.prefPane/
	chmod -R 750 /System/Library/PreferencePanes/Speech.prefPane/
	chmod -R 750 /System/Library/PreferencePanes/StartupDisk.prefPane/
	chmod -R 750 /System/Library/PreferencePanes/TimeMachine.prefPane/
	##chmod -R 750 /System/Library/PreferencePanes/Trackpad.prefPane/
	chmod -R 750 /System/Library/PreferencePanes/DesktopScreenEffectsPref.prefPane/
	chmod -R 750 /System/Library/PreferencePanes/Appearance.prefPane/
	### Installed PrePanes ###
	chmod -R 750 /Library/PreferencePanes/Apple\ Qmaster.prefPane
	chmod -R 750 /Library/PreferencePanes/CUDA\ Preferences.prefPane
	chmod -R 750 /Library/PreferencePanes/Flip4Mac\ WMV.prefPane
	chmod -R 750 /Library/PreferencePanes/KeyAccessPref.prefPane
	chmod -R 750 /Library/PreferencePanes/REDcode.prefpane
	chmod -R 750 /Library/PreferencePanes/Surveyor.prefPane
	chmod -R 750 /Library/PreferencePanes/TrackballWorks.prefPane
	chmod -R 750 /Library/PreferencePanes/Flash\ Player.prefPane
	chmod -R 750 /Library/PreferencePanes/JavaControlPanel.prefPane
	chmod -R 750 /Library/Internet\ Plug-Ins/JavaAppletPlugin.plugin/Contents/Home/lib/deploy/JavaControlPanel.prefPane
	### Clear ALL prepane caches ###
	rm -Rf /Users/*/Library/Caches/com.apple.preferencepanes.searchindexcache
	rm -Rf /Users/*/Library/Caches/com.apple.preferencepanes.cache
}
#end hide_PrefPanes

function UNhide_PrefPanes() {
	cd /
	echo "About to CHMOD a bunch of PREF panes"
	chown -Rf root:wheel /System/Library/PreferencePanes
	chown -Rf root:wheel /Library/PreferencePanes
	chown -Rf root:wheel /Library/Internet\ Plug-Ins/JavaAppletPlugin.plugin/Contents/Home/lib/deploy/JavaControlPanel.prefPane
	### System PrefPanes ###
	chmod -R 755 /System/Library/PreferencePanes/AppStore.prefPane
	chmod -R 755 /System/Library/PreferencePanes/Accounts.prefPane/
	chmod -R 755 /System/Library/PreferencePanes/Bluetooth.prefPane/
	chmod -R 755 /System/Library/PreferencePanes/DateAndTime.prefPane/
	chmod -R 755 /System/Library/PreferencePanes/Dock.prefPane/
	chmod -R 755 /System/Library/PreferencePanes/EnergySaver.prefPane/
	chmod -R 755 /System/Library/PreferencePanes/Expose.prefPane/
	chmod -R 755 /System/Library/PreferencePanes/FibreChannel.prefPane/
	chmod -R 755 /System/Library/PreferencePanes/iCloudPref.prefPane/
	chmod -R 755 /System/Library/PreferencePanes/InternetAccounts.prefPane/
	chmod -R 755 /System/Library/PreferencePanes/Ink.prefPane/
	##chmod -R 755 /System/Library/PreferencePanes/Keyboard.prefPane/
	chmod -R 755 /System/Library/PreferencePanes/Localization.prefPane/
	chmod -R 755 /System/Library/PreferencePanes/MobileMe.prefPane/
	chmod -R 755 /System/Library/PreferencePanes/Network.prefPane/
	chmod -R 755 /System/Library/PreferencePanes/Notifications.prefPane/
	chmod -R 755 /System/Library/PreferencePanes/ParentalControls.prefPane/
	chmod -R 755 /System/Library/PreferencePanes/PrintAndFax.prefPane/
	chmod -R 755 /System/Library/PreferencePanes/Security.prefPane/
	chmod -R 755 /System/Library/PreferencePanes/SharingPref.prefPane/
	chmod -R 755 /System/Library/PreferencePanes/SoftwareUpdate.prefPane/
	chmod -R 755 /System/Library/PreferencePanes/Spotlight.prefPane/
	chmod -R 755 /System/Library/PreferencePanes/Speech.prefPane/
	chmod -R 755 /System/Library/PreferencePanes/StartupDisk.prefPane/
	chmod -R 755 /System/Library/PreferencePanes/TimeMachine.prefPane/
	##chmod -R 755 /System/Library/PreferencePanes/Trackpad.prefPane/
	chmod -R 755 /System/Library/PreferencePanes/DesktopScreenEffectsPref.prefPane/
	chmod -R 755 /System/Library/PreferencePanes/Appearance.prefPane/
	### Installed PrePanes ###
	chmod -R 755 /Library/PreferencePanes/Apple\ Qmaster.prefPane
	chmod -R 755 /Library/PreferencePanes/CUDA\ Preferences.prefPane
	chmod -R 755 /Library/PreferencePanes/Flip4Mac\ WMV.prefPane
	chmod -R 755 /Library/PreferencePanes/KeyAccessPref.prefPane
	chmod -R 755 /Library/PreferencePanes/REDcode.prefpane
	chmod -R 755 /Library/PreferencePanes/Surveyor.prefPane
	chmod -R 755 /Library/PreferencePanes/TrackballWorks.prefPane
	chmod -R 755 /Library/PreferencePanes/Flash\ Player.prefPane
	chmod -R 755 /Library/PreferencePanes/JavaControlPanel.prefPane
	chmod -R 755 /Library/Internet\ Plug-Ins/JavaAppletPlugin.plugin/Contents/Home/lib/deploy/JavaControlPanel.prefPane
	### Clear ALL prepanes caches ###
	rm -Rf /Users/*/Library/Caches/com.apple.preferencepanes.searchindexcache
	rm -Rf /Users/*/Library/Caches/com.apple.preferencepanes.cache
}
#end UNhide_PrefPanes

function clean_KeyAccess() {
	rm -Rf /var/root/Library/Preferences/KeyAccess\ Audit
	rm -Rf /var/root/Library/Preferences/KeyAccess\ Offline
	rm -Rf /var/root/Library/Preferences/KeyAccess\ Prefs
	rm -Rf /Library/Preferences/KeyAccess/KeyAccess\ Audit
	rm -Rf /Library/Preferences/KeyAccess/KeyAccess\ Offline
	rm -Rf /Library/Preferences/KeyAccess/KeyAccess\ Prefs
	rm -Rf /Library/Preferences/KeyAccess/Portable\ Keys
}
#end clean_KeyAccess

function create_UserTemplate() {
	cd /
	if [ -f "/System/Library/User Template/english.lproj.tar" ];
	then
		echo "no need to backup the old lproj"
	else
		tar -cpvf /System/Library/User\ Template/english.lproj.tar /System/Library/User\ Template
		tar -cpvf /System/Library/User\ Template/Non_localized.tar /System/Library/User\ Template
	fi
	# unhide /Users/temp/Library cause users libraries are hidden in Lion
	chflags nohidden /Users/temp/Library
	chflags nohidden /Users/temp/Library/Preferences/.GlobalPreferences.plist
	 
	#clean out old caches and files before cp
	rm -Rf /Users/temp/Downloads/*
	rm -Rf /System/Library/User\ Template/English.lproj/Library
	rm -Rf /System/Library/User\ Template/English.lproj/Desktop
	rm -Rf /Users/temp/Library/Caches
	rm -Rf /Library/Caches
	rm -Rf /Users/temp/Library/Application\ Support/Ubiquity
	# Copy in the files we love
	cp -Rf /Users/temp/Library  /System/Library/User\ Template/English.lproj/
	cp -Rf /Users/temp/Documents  /System/Library/User\ Template/English.lproj/
	cp -Rf /Users/temp/Desktop  /System/Library/User\ Template/English.lproj/
	cp -Rf /Users/temp/Library/Preferences/.GlobalPreferences.plist /System/Library/User\ Template/English.lproj/Library/Preferences
	# cp -Rf /Users/temp/Library/Preferences/.GlobalPreferences.plist.lockfile /System/Library/User\ Template/English.lproj/Library/Preferences
	rm -Rf /System/Library/User\ Template/Non_localized/Library/Preferences/.GlobalPreferences.plist
	cp -Rf /Users/temp/Library/Preferences/.GlobalPreferences.plist /System/Library/User\ Template/Non_localized/Library/Preferences
	# not installed yet 20120420 -> cp -R /Users/temp/NETHASP.INI .
	# remove the login keychain to avoid the pop-up (login.kechain and metadata.keychain)
	rm -Rf /System/Library/User\ Template/English.lproj/Library/Keychains/*
	wait $!
	chflags hidden /Users/temp/Library/Preferences/.GlobalPreferences.plist
}
#end create_UserTemplate

function All_Setup() {
	echo "running basic setup functions"
	no_iCloud
	no_winAnims
	no_SavedStates
	launchD_No_Index
	no_timeMachine
	hide_PrefPanes
	hide_Apps
	printf "\a"
	osascript -e "beep 1"
	echo "DONE!"

}
#end All_Setup

function no_Airdrop() {
	defaults write com.apple.NetworkBrowser DisableAirDrop -boolean YES
}
#end no_Airdrop

function yes_Airdrop() {
	defaults write com.apple.NetworkBrowser DisableAirDrop -boolean NO
}
#end yes_Airdrop

function scratchPerms() {
	if [[ -d /Volumes/Video ]]; then
		echo "Video Volume Found"
		diskutil enableOwnership /Volumes/Video > /dev/null 2>&1
		chown -Rf _unknown:everyone /Volumes/Video
		chmod -Rf 777 /Volumes/Video
		chmod -R +a "everyone allow list,add_file,search,add_subdirectory,delete_child,readattr,writeattr,readextattr,writeextattr,readsecurity,file_inherit,directory_inherit" /Volumes/Video
		diskutil disableOwnership /Volumes/Video > /dev/null 2>&1
	else
		echo "Video Volume Not Found"
	fi

	if [[ -d /Volumes/Audio ]]; then
		echo "Audio Volume Found"
		diskutil enableOwnership /Volumes/Audio > /dev/null 2>&1
		chown -Rf _unknown:everyone /Volumes/Audio
		chmod -R +a "everyone allow list,add_file,search,add_subdirectory,delete_child,readattr,writeattr,readextattr,writeextattr,readsecurity,file_inherit,directory_inherit" /Volumes/Audio
		chmod -Rf 777 /Volumes/Audio
		diskutil disableOwnership /Volumes/Audio > /dev/null 2>&1
	else
		echo "Audio Volume Not Found"
	fi

	if [[ -d /Volumes/Scratch ]]; then
		echo "Scratch Volume Found"
		diskutil enableOwnership /Volumes/Scratch > /dev/null 2>&1
		chown -Rf _unknown:everyone /Volumes/Scratch
		chmod -R +a "everyone allow list,add_file,search,add_subdirectory,delete_child,readattr,writeattr,readextattr,writeextattr,readsecurity,file_inherit,directory_inherit" /Volumes/Scratch
		chmod -Rf 777 /Volumes/Scratch
		diskutil disableOwnership /Volumes/Scratch > /dev/null 2>&1
	else
		echo "Scratch Volume Not Found"
	fi

	if [[ -d /Users/Shared ]]; then
		echo "Users Shared Folder Found"
		chown -Rf _unknown:everyone /Users/Shared
		chmod -R +a "everyone allow list,add_file,search,add_subdirectory,delete_child,readattr,writeattr,readextattr,writeextattr,readsecurity,file_inherit,directory_inherit" /Users/Shared
		chmod -Rf 777 /Users/Shared
	else
		echo "Users Shared Folder Not Found"
	fi

	if [[ -d /Volumes/Scratch ]]; then
		echo "Scratch Volume Found"
		diskutil enableOwnership /Volumes/Scratch > /dev/null 2>&1
		chown -Rf _unknown:everyone /Volumes/Scratch
		chmod -R +a "everyone allow list,add_file,search,add_subdirectory,delete_child,readattr,writeattr,readextattr,writeextattr,readsecurity,file_inherit,directory_inherit" /Volumes/Scratch
		chmod -Rf 777 /Volumes/Scratch
		diskutil disableOwnership /Volumes/Scratch > /dev/null 2>&1
	else
		echo "Scratch Volume Not Found"
	fi

	if [[ -d /Volumes/Classroom\ Exercises ]]; then
		echo "Class Ex Volume Found"
		diskutil enableOwnership /Volumes/Classroom\ Exercises > /dev/null 2>&1
		chown -Rf _unknown:everyone /Volumes/Classroom\ Exercises
		chmod -R +a "everyone allow list,add_file,search,add_subdirectory,delete_child,readattr,writeattr,readextattr,writeextattr,readsecurity,file_inherit,directory_inherit" /Volumes/Classroom\ Exercises
		chmod -Rf 777 /Volumes/Classroom\ Exercises
		diskutil disableOwnership /Volumes/Classroom\ Exercises > /dev/null 2>&1
	else
		echo "Class Ex Volume Not Found"
	fi

}
#end scratchPerms

function prepNnetboot () {
	cd /
	rm -Rf ./.DocumentRevisions-V100
	wait
	cd ~
	clean_KeyAccess
	wait
	bless --netboot --server bsdp://10.10.52.5 --nextonly
	wait
	reboot
	killall Terminal
}
#end prepNnetboot

function set_next_netboot() {
	clean_KeyAccess
	wait
	bless --netboot --server bsdp://10.10.52.5 --nextonly
}
#end set_next_boot

function clNexit() {
	rm -rf ~/.bash_history
	history -c
	clear
	exit
}
#end clNexit

function Creative_Computing () {
cat <<"EOT"
                  (                        (
             (    )\ )       (       *   ) )\ )
             )\  (()/( (     )\      )  /((()/( (   (   (
           (((_)  /(_)))\ ((((_)(   ( )(_))/(_)))\  )\  )\
           )\___ (_)) ((_) )\ _ )\ (_(_())(_)) ((_)((_)((_)
          ((/ __|| _ \| __|(_)_\(_)|_   _||_ _|\ \ / / | __|
           | (__ |   /| _|  / _ \    | |   | |  \ V /  | _|
            \___||_|_\|___|/_/ \_\   |_|  |___|  \_/   |___|
                = C . O . M . P . U . T . I . N . G =
                     LION SYSADMIN STORE v2.5.1
EOT
}



showMenu2 () {
	clear
	Creative_Computing
		echo "  1) no_iCloud - set user template to not show iCloud prompt at login"
		echo "  2) no_winAnims - turn off all the window animations"
		echo "  3) no_SavedStates - stop OS from writing saved states"
		echo "  4) yes_SavedStates - undo the saved states mods"
		echo "  5) launchD_No_Index - pushes in the no_index and launchD magic"
		echo "  6) no_timeMachine - don't offer new disks for time machine"
		echo "  7) no_Airdrop - turn off airdrop"
		echo "  8) hide_Apps - Hides a bunch of apps"
		echo "  9) nohide_Apps - Un-Hides a bunch of apps"
		echo " 10) lInk_FromRootBin - SymLinks some scripts to /usr/local/bin"
		echo " 11) BACK TO MAIN MENU"
		echo " 12) EXIT"
		printf "\e[1mPick A Number\e[m:"
}

function menuNumber2() {
while [ 1 ]
do
	showMenu2
	read CHOICE
		case "$CHOICE" in
			"1")
				no_iCloud
				;;
			"2")
				no_winAnims
				;;
			"3")
				no_SavedStates
				;;
			"4")
				yes_SavedStates
				;;
			"5")
				launchD_No_Index
				;;
			"6")
				no_timeMachine
				;;
			"7")
				no_Airdrop
				;;
			"8")
				hide_Apps
				;;
			"9")
				nohide_Apps
				;;
			"10")
				lInk_FromRootBin
				;;
			"11")
				showMainMenu
				;;
			"12")
				clNexit
				;;
        esac
done
}

showMenu () {
	clear
	Creative_Computing
		echo "  1) RUN ALL SETUP FUNCTIONS"
		echo "  2) hide_PrefPanes - self explanatory"
		echo "  3) UNhide_PrefPanes - yep"
		echo "  4) create_UserTemplate - roll temp into User Tmeplate"
		echo "  5) clean_KeyAccess - clear the files that should not be imaged"
		echo "  6) prepNnetboot - prep then netboot"
		echo "  7) set_next_netboot - just set next boot as netboot"
		echo "  8) scratchPerms - open up perms on scratch disks and /Shared"
		echo "  9) SHOW MORE FUNCTIONS"
		echo " 10) EXIT"
		printf "\e[1mPick A Number\e[m:"
}

function showMainMenu() {
while [ 1 ]
do
	showMenu
	read CHOICE
		case "$CHOICE" in
			"1")
				All_Setup
				;;
			"2")
				hide_PrefPanes
				;;
			"3")
				UNhide_PrefPanes
				;;
			"4")
				create_UserTemplate
				;;
			"5")
				clean_KeyAccess
				;;
			"6")
				prepNnetboot
				;;
			"7")
				set_next_netboot
				;;
			"8")
				scratchPerms
				;;
			"9")
				menuNumber2
				;;
			"10")
				clNexit
				;;

        esac
done
}

showMainMenu

# end LION_SYSADMIN_STORE

#    .__________________.
#    |.----------------.|
#    ||         .:'    ||
#    ||     __ :'__    ||
#    ||  .'`__`-'__``. ||
#    || :__________.-' ||
#    || :_________:    ||
#    ||  :_________`-; ||
#    ||   `.__.-.__.'  ||
#    ||________________||
#    /.-.-.-.-.-.-.-.-. \
#   /.-.-.-.-.-.-.-.-.-. \
#  /.-.-.-.-.-.-.-.-.-.-. \
# /______/__________\___o_ \
# \_______________________ /
# need a users UID GID info?  use:
#	id [account name] | perl -lne 's/ /\n/g; s/,/\n\t/g; print;'

## DEAD FUNCTIONS ##
# function login_ScreenSaver() {
# 	mkdir /Volumes/Mac\ Software
# 	mount_afp "afp://admin:m80,mOuse@10.10.52.5/Mac%20Software" /Volumes/Mac\ Software
# 	cp -Rf /Volumes/Mac\ Software/nic/AdminApps/Paper\ Shadow.slideSaver /private/var/root
# 	rm -Rf /System/Library/Screen\ Savers/Paper\ Shadow.slideSaver
# 	cp -Rf /private/var/root/Paper\ Shadow.slideSaver /System/Library/Screen\ Savers/
# 	rm -Rf /private/var/root/Paper\ Shadow.slideSaver
# 	cp -Rf /Volumes/Mac\ Software/nic/AdminApps/Nature\ Patterns.slideSaver /private/var/root
# 	rm -Rf /System/Library/Screen\ Savers/Nature\ Patterns.slideSaver
# 	cp -Rf /private/var/root/Nature\ Patterns.slideSaver /System/Library/Screen\ Savers/
# 	rm -Rf /private/var/root/Nature\ Patterns.slideSaver
# 	defaults write /Library/Preferences/com.apple.screensaver loginWindowIdleTime 30
# 	defaults write /Library/Preferences/com.apple.screensaver loginWindowModulePath "/System/Library/Screen Savers/Paper Shadow.slideSaver"
# 	umount /Volumes/Mac\ Software
# }
# #end login_ScreenSaver
# 
# function login_BackGround() {
# 	mkdir /Volumes/Mac\ Software
# 	mount_afp "afp://admin:m80,mOuse@10.10.52.5/Mac%20Software" /Volumes/Mac\ Software
# 	cp -f /Volumes/Mac\ Software/nic/AdminApps/NSTexturedFullScreenBackgroundColor.png /private/var/root
# 	cp -f /private/var/root/NSTexturedFullScreenBackgroundColor.png /System/Library/Frameworks/AppKit.framework/Versions/C/Resources
# 	rm -f /private/var/root/NSTexturedFullScreenBackgroundColor.png
# 	cp -f /Volumes/Mac\ Software/nic/AdminApps/apple.png /private/var/root
# 	cp -f /private/var/root/apple.png /System/Library/PrivateFrameworks/LoginUIKit.framework/Versions/A/Frameworks/LoginUICore.framework/Versions/A/Resources
# 	rm -f /private/var/root/apple.png
# 	cp -f /Volumes/Mac\ Software/nic/AdminApps/appleLinen.png /private/var/root
# 	cp -f /private/var/root/appleLinen.png /System/Library/PrivateFrameworks/LoginUIKit.framework/Versions/A/Frameworks/LoginUICore.framework/Versions/A/Resources
# 	rm -f /private/var/root/appleLinen.png
# 	cp -f /Volumes/Mac\ Software/nic/AdminApps/SArtFile.new.bin /private/var/root
# 	mv /private/var/root/SArtFile.new.bin /private/var/root/SArtFile.bin
# 	cp -f /private/var/root/SArtFile.bin /System/Library/PrivateFrameworks/CoreUI.framework/Resources
# 	rm -f /private/var/root/SArtFile.bin
# 	umount /Volumes/Mac\ Software
# }
# #end login_BackGround
# 
# function sca_IOhooks() {
# 	#sh /private/var/root/IOhooks/activatelogouthooks.sh
# 	echo "IO hooks must be manually entered in the root terminal"
# 	# 20120514 IO hooks must be manually entered in the root terminal
# }
# #end sca_IOhooks
# 
# function Set_DefaultDeskTop() {
# 	mkdir /Volumes/Mac\ Software
# 	mount_afp "afp://admin:m80,mOuse@10.10.52.5/Mac%20Software" /Volumes/Mac\ Software/
# 	cp -Rf /Volumes/Mac\ Software/nic/AdminApps/Andromeda\ Galaxy.jpg /Volumes/SCA_MacHD/Library/Desktop\ Pictures
# 	umount /Volumes/Mac\ Software
# }
# #end Set_DefaultDeskTop
# 
# function ad_Tweaks(){
# 	dsconfigad -passinterval 0
# }
# #end ad_Tweaks
# 
# function login_WindowTweaks(){
# 	cd /
# 	# removed in lion -> defaults write /Library/Preferences/com.apple.loginwindow StartupDelay 30
# 	# Not needed in LION-> defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo DSStatus
# 	cd ~
# }
# #end login_WindowTweaks