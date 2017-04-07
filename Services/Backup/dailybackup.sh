#!/bin/bash

# Daily Backup Script which backs up several folders on the RAID5 box (mounted at ~/Media) to a BTRFS RAID-0 (2 x 2TB) Backup Drive (mounted at ~/Backup)

#############
# Variables #
#############

PUSHBULLET_SCRIPT="/home/fileserver/Applications/pushbullet.sh"
RSYNC_LOG="/home/fileserver/Applications/Backup/logs/rsync.log"
BACKUP_LOG="/home/fileserver/Applications/Backup/logs/backup.log"

MEDIA_LOCATION="/home/fileserver/Media"
BACKUP_LOCATION="/home/fileserver/Backup"

BACKUP_FOLDERS=(Applications Books Games Movies Music Network OSInstallISO Photos Software SystemImage TVShows)

#############
# Functions #
#############

function backupToMedia () {
	# This function expects 1 argument, the folder you want to restore
	printf "Backing up %s to ~/Media\n" "$1" >> $BACKUP_LOG 2>&1
	rsync --log-file=$RSYNC_LOG -avhP --delete "/home/fileserver/$1/" "$MEDIA_LOCATION/$1" >/dev/null 2>&1
}

function backupToBackup () {
	# This function expects 1 argument, the folder you want to restore
	printf "Backing up %s to ~/Backup\n" "$1" >> $BACKUP_LOG 2>&1
	rsync --log-file=$RSYNC_LOG -avhP --delete "$MEDIA_LOCATION/$1/" "$BACKUP_LOCATION/$1" >/dev/null 2>&1
}

#################
# Backup Script #
#################

printf "Starting Daily Backup. Time & Date right now is $(date)\n" >>/home/fileserver/Applications/Backup/logs/backup.log 2>&1

# Checking if Media & Backup is mounted
printf "Checking if Media & Backup is successfully mounted\n" >>/home/fileserver/Applications/Backup/logs/backup.log 2>&1

if [[ $(mount | grep -c /home/fileserver/Media) == 0 ]]; then

	# Error - Media is not mounted. Sending Message to Sysadmin
	$PUSHBULLET_SCRIPT "ERROR - Media not Mounted" "During Daily Backup, the mount check of ~/Media failed." >/dev/null 2>&1
	exit 1
fi

if [[ $(mount | grep -c /home/fileserver/Backup) == 0 ]]; then

	# Error - Backup is not mounted. Sending Message to Sysadmin
	$PUSHBULLET_SCRIPT "ERROR - Backup not Mounted" "During Daily Backup, the mount check of ~/Backup failed." >/dev/null 2>&1
	exit 1
fi

# Backing up Applications Folder to ~/Media
backupToMedia Applications

# Backing up all folders in Media to Backup
for i in "${BACKUP_FOLDERS[@]}"; do
	backupToBackup $i
done

# End of Backup, Sending message to sysadmin
$PUSHBULLET_SCRIPT "ArchServer: Daily Backup Completed" "Daily Backup of /Media to /Backup has successfully finished." >/dev/null 2>&1

# Ending backup
printf "End of Daily Backup.\n\n" >>/home/fileserver/Applications/Backup/logs/backup.log 2>&1
exit 0