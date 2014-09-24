#!/bin/bash
# scratch_permissions.sh
# - fix up all the permissions on /Audio /Video and or /Scratch partitions
# - chown to _unknown:staff
# - Set perms to rwx for everyone
# - add/set ACL for everyone allow all inherited
# - diable ownership
#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

echo "Checking for Video volume..."
if [[ -d /Volumes/Video ]]; then
	diskutil enableOwnership /Volumes/Video > /dev/null 2>&1
	chown -Rf _unknown:everyone /Volumes/Video
	chmod -Rf 777 /Volumes/Video
	chmod -R +a "everyone allow list,add_file,search,add_subdirectory,delete_child,readattr,writeattr,readextattr,writeextattr,readsecurity,file_inherit,directory_inherit" /Volumes/Video
	diskutil disableOwnership /Volumes/Video > /dev/null 2>&1
fi

echo "Checking for Audio volume..."
if [[ -d /Volumes/Audio ]]; then
	diskutil enableOwnership /Volumes/Audio > /dev/null 2>&1
	chown -Rf _unknown:everyone /Volumes/Audio
	chmod -R +a "everyone allow list,add_file,search,add_subdirectory,delete_child,readattr,writeattr,readextattr,writeextattr,readsecurity,file_inherit,directory_inherit" /Volumes/Audio
	chmod -Rf 777 /Volumes/Audio
	diskutil disableOwnership /Volumes/Audio > /dev/null 2>&1
fi

echo "Checking for Scratch volume..."
if [[ -d /Volumes/Scratch ]]; then
	diskutil enableOwnership /Volumes/Scratch > /dev/null 2>&1
	chown -Rf _unknown:everyone /Volumes/Scratch
	chmod -R +a "everyone allow list,add_file,search,add_subdirectory,delete_child,readattr,writeattr,readextattr,writeextattr,readsecurity,file_inherit,directory_inherit" /Volumes/Scratch
	chmod -Rf 777 /Volumes/Scratch
	diskutil disableOwnership /Volumes/Scratch > /dev/null 2>&1
fi

echo "Checking for SCRATCH volume..."
if [[ -d /Volumes/SCRATCH ]]; then
	diskutil enableOwnership /Volumes/SCRATCH > /dev/null 2>&1
	chown -Rf _unknown:everyone /Volumes/SCRATCH
	chmod -R +a "everyone allow list,add_file,search,add_subdirectory,delete_child,readattr,writeattr,readextattr,writeextattr,readsecurity,file_inherit,directory_inherit" /Volumes/SCRATCH
	chmod -Rf 777 /Volumes/SCRATCH
	diskutil disableOwnership /Volumes/SCRATCH > /dev/null 2>&1
fi

echo "Checking /Users/Shared"
if [[ -d /Volumes/SCA_MacHD/Users/Shared ]]; then
	chown -Rf _unknown:everyone /Volumes/SCA_MacHD/Users/Shared
	chmod -R +a "everyone allow list,add_file,search,add_subdirectory,delete_child,readattr,writeattr,readextattr,writeextattr,readsecurity,file_inherit,directory_inherit" /Volumes/SCA_MacHD/Users/Shared
	chmod -Rf 777 /Volumes/SCA_MacHD/Users/Shared
fi
