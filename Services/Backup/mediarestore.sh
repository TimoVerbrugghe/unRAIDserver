#!/bin/bash

# This script restores all folders defined in RESTORE_FOLDERS from BACKUP_LOCATION to RESTORE_LOCATION

#############
# Variables #
#############

PUSHBULLET_SCRIPT="/home/fileserver/Applications/pushbullet.sh"
RSYNC_LOG="/home/fileserver/rsync.log"
RESTORE_LOG="/home/fileserver/restore.log"

BACKUP_LOCATION="/home/fileserver/Media" # The location where there are currently files that you want to restore to another location
RESTORE_LOCATION="/home/fileserver/Temporary" # The location where you want to restore files to

RESTORE_FOLDERS=(Applications Books Games Movies Music Network OldServer OSInstallISO Photos Software SystemImage TVShows)

###########################
# Asking for confirmation #
###########################
echo "These are the locations I'm going to work with:"
echo "Pushbullet script: $PUSHBULLET_SCRIPT"
echo "Restore log: $RESTORE_LOG"
echo "Rsync log: $RSYNC_LOG"
echo "Backup location: $BACKUP_LOCATION"
echo "Restore location: $RESTORE_LOCATION"

echo 
echo "This is what I'm going to restore: ${RESTORE_FOLDERS[*]}"
echo

echo "This script WILL OVERRIDE data. Only proceed if these locations are correct !!!"

read -p "Are you sure you want to continue? [y/N] " -r
echo
if [[ $REPLY =~ ^[Yy]$ ]] 

then

	#############
	# Functions #
	#############

	function create_logs () {
		echo "Creating log files"
		touch $RSYNC_LOG
		touch $RESTORE_LOG
	}

	function restore () {
		# This function expects 1 argument, the folder you want to restore
		printf "Now restoring %s\n" "$1" >> $RESTORE_LOG 2>&1

		rsync --log-file=$RSYNC_LOG -avhAHXP "$BACKUP_LOCATION/$1/" "$RESTORE_LOCATION/$1"

		printf "Done restoring %s, sending message to sysadmin.\n" "$1" >> $RESTORE_LOG 2>&1
		
		echo "Done restoring \"$1\", sending message to sysadmin."
		$PUSHBULLET_SCRIPT "ArchServer: \"$1\" folder restored" "The \"$1\" folder is now restored." >/dev/null 2>&1
	}

	##################
	# Restore Script #
	##################

	# Creating logs

	create_logs

	# Restoring folders 

	for i in "${RESTORE_FOLDERS[@]}"; do
		restore $i
	done

	# Recreating downloads folder
	printf "Recreating Downloads folder." >> $RESTORE_LOG 2>&1
	echo "Recreating Downloads folder"
	
	mkdir $RESTORE_LOCATION/Downloads 2>&1
	mkdir $RESTORE_LOCATION/Downloads/complete 2>&1
	mkdir $RESTORE_LOCATION/Downloads/incomplete 2>&1
	mkdir $RESTORE_LOCATION/Downloads/complete/movies 2>&1
	mkdir $RESTORE_LOCATION/Downloads/complete/tvshows 2>&1

	# Setting default permissions
	printf "Setting permissions on restored volume (755 for directories, 644 for files, unless other specified)" >> $RESTORE_LOG 2>&1
	echo "Setting permissions on restored volume (755 for directories, 644 for files, unless other specified)"
	find $RESTORE_LOCATION -type d -exec chmod 755 {} \;
	find $RESTORE_LOCATION -type f -exec chmod 644 {} \;

	chmod 755 $RESTORE_LOCATION 2>&1
	chown -R fileserver:fileserver $RESTORE_LOCATION 2>&1

	# Setting special permissions
	chmod +x $RESTORE_LOCATION/Network/vnc/utils/websockify/run 2>&1
	chmod 777 -R $RESTORE_LOCATION/Network/alltube/templates_c 2>&1

	printf "Restore done, sending message to sysadmin" >> $RESTORE_LOG 2>&1
	echo "Restore done, sending message to sysadmin"
	$PUSHBULLET_SCRIPT "ArchServer: Restore to \"$BACKUP_LOCATION\" complete" "All folders have been restored." >/dev/null 2>&1

	exit 0

else
	echo "Allright, nothing will be restored."
	exit 0
fi
