#!/bin/bash

# Daily Backup Script which backs up several folders on the RAID5 box (mounted at ~/Media) to a BTRFS RAID-0 (2 x 2TB) Backup Drive (mounted at ~/Backup)

source /home/fileserver/Applications/ArchServer/config/variables.sh

#############
# Functions #
#############

function mountCheck () {
	if [[ $(mount | grep -c $1) == 0 ]]; then

	# Error - Media is not mounted. Sending Message to Sysadmin
	$PUSHBULLET_SCRIPT "ERROR - \"$1\" not Mounted" "During Daily Backup, the mount check of \"$1\" failed." >/dev/null 2>&1
	exit 1
	fi
}

function errorCheck () {
	ERRORVALUE="$?"
	if [ $ERRORVALUE -ne 0 ]; then
  		$PUSHBULLET_SCRIPT "ERROR - ArchServer Backup failed" "During daily backup, rclone failed backing up files (error code different than 0)." >/dev/null 2>&1
		exit 1
	fi
}

function backup () {
	# This function expects 2 arguments, the backup location & the folder you want to restore
	printf "Backing up %s to %s\n" "$1" "$2" >> $BACKUP_LOG 2>&1
	rclone sync --delete-excluded -v -P --fast-list --transfers=20 --checkers=20 --drive-chunk-size=1M --log-file $RCLONE_LOG --filter-from $RCLONE_EXCLUSIONS "$1" "$2"

	errorCheck
}

#################
# Backup Script #
#################

printf "Starting Daily Backup. Time & Date right now is $(date)\n" >> $BACKUP_LOG 2>&1

# Checking if Media & Backup is mounted
printf "Checking if Media & Backup is successfully mounted\n" >> $BACKUP_LOG 2>&1

mountCheck $MEDIA_LOCATION
mountCheck $BACKUP_LOCATION

# Backing up Applications Folder to ~/Media
backup /home/fileserver/Applications $MEDIA_LOCATION/Applications

# Backing up all folders in Media to Backup
#for i in "${BACKUP_FOLDERS[@]}"; do
#	backup $MEDIA_LOCATION/$i $BACKUP_LOCATION/$i
#done

# Ending backup
printf "End of Daily Backup.\n\n" >> $BACKUP_LOG 2>&1
exit 0