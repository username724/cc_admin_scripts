#!/bin/sh
# activates login and logout hooks to run logouthooks.sh
#=====================================================================================

cd /
# write hooks in root
defaults write /private/var/root/Library/Preferences/com.apple.loginwindow LoginHook /private/var/root/bin/IOhooks/loginhooks.sh
wait $!
defaults write /private/var/root/Library/Preferences/com.apple.loginwindow LogoutHook /private/var/root/bin/IOhooks/logouthooks.sh
wait $!
# write hooks in usertemplate
defaults write /System/Library/User\ Template/English.lproj/Library/Preferences/com.apple.loginwindow LoginHook /private/var/root/bin/IOhooks/loginhooks.sh
wait $!
defaults write /System/Library/User\ Template/English.lproj/Library/Preferences/com.apple.loginwindow LogoutHook /private/var/root/bin/IOhooks/logouthooks.sh
wait $!


# note IOhooks have to exit 0
exit 0
