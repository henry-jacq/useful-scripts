#!/bin/bash

# Title	   	   : Pacman Cache Cleaner
# Purpose	   : To clean the Pacman and AUR caches
# Author	   : Henry
# Usage		   : ./pacman-cleaner.sh
# Version	   : 0.1
# Created Date : 12/11/22
# Modified Date: 
# Info		   : You need to add this script to cron for weekly

DEPENDENCIES="pacman-contrib" # List the dependency packages
PKGMGR="pacman -Sy" # Package manager with update and install command
PCACHE="/usr/bin/paccache"
# The location of the cache for your aur helper
# AUR HELPER: Paru
AUR_CACHE_DIR=${HOME}/.cache/yay

# Get all cache directories for AUR helper
AUR_CACHE_REMOVED="$(find "$AUR_CACHE_DIR" -maxdepth 1 -type d | awk '{ print "-c " $1 }' | tail -n +2)"

# Remove everything for uninstalled AUR packages
AUR_REMOVED=$($PCACHE -ruvk0 ${AUR_CACHE_REMOVED} | sed '/\.cache/!d' | cut -d \' -f2 | rev | cut -d / -f2- | rev)

# START #
# Error and warnings
function _red_text(){
	QUERY="$*"
	echo -e "\e[31m${QUERY}\e[0m"
}

# Successful output
function _green_text(){
	QUERY="$*"
	echo -e "\e[32m${QUERY}\e[0m"
}

# Informative
function _yellow_text(){
	QUERY="$*"
	echo -e "\e[33m${QUERY}\e[0m"
}

# Show process
function _blue_text(){
	QUERY="$*"
	echo -e "\e[34m${QUERY}\e[0m"
}

function main(){
	verify_root
	_green_text ${0}: Setting up ${PROGRAM}...
	install_dependencies
	setup
}

# If there is any dependencies, install them !
function install_dependencies(){
	_green_text [+] Installing dependencies...
	$PKGMGR $DEPENDENCIES 2> /dev/null || panic
}

function setup(){
	_green_text [*] Cleaning pacman and AUR caches...
	[ -z "$AUR_REMOVED" ] || rm -rf $AUR_REMOVED

	# Keep the latest version for uninstalled native packages, keep two versions of the installed packages
	# Get all cache directories for AUR helper (without removed packages)
	AUR_CACHE="$(find "$AUR_CACHE_DIR" -maxdepth 1 -type d | awk '{ print "-c " $1 }'| tail -n +2)"
	$PCACHE -qruk1
	$PCACHE -qrk2 -c /var/cache/pacman/pkg $AUR_CACHE
}

# Panic if something goes wrong; we can use this is
# in script with the || syntax, if the command fails
function panic(){
	_red_text [-] Fatal error, aborting...
	exit -1
}

# Make sure that the user running this as root
function verify_root(){
	if [ "$UID" != 0 ]; then
		_red_text [$0]: You must be root to run this script !
		exit -1
	fi
}


# Calling main function, passing in all passed arguments to every function
main "$@"

# END #
