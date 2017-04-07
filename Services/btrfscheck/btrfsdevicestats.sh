#!/bin/bash
## This script takes a location as input and loads the btrfs device stats of that location. Based on the output of the stats command, the script informs system administrator of errors.

#############
# Variables #
#############

BTRFS_LOG="/home/fileserver/Applications/btrfscheck/btrfscheck.log"
PUSHBULLET_SCRIPT="/home/fileserver/Applications/pushbullet.sh"
STATS_LOCATION=$1

printf "Starting BTRFS device stats check on %s. Time & Date right now is $(date)\n" "$STATS_LOCATION" >> $BTRFS_LOG 2>&1

# See which logfile needs to be used

if [[ $STATS_LOCATION -ef /home/fileserver/Media ]]  ; then
	LOGFILE="/tmp/statsraid"
elif [[ $STATS_LOCATION -ef /home/fileserver/Backup ]] ; then
	LOGFILE="/tmp/statsbackup"
elif [[ $STATS_LOCATION -ef / ]] ; then
	LOGFILE="/tmp/statsroot"
else
	echo "Error: You need to provide a correct location for BTRFS device stats"
	exit 0
fi

## Setup of files

rm -rf $LOGFILE
touch $LOGFILE

## Put stats in logfile

btrfs device stats $STATS_LOCATION >> $LOGFILE 2>&1

## Check if stats contains errors
if ! grep -vEq ' 0$' $LOGFILE ; then
	# If only 0 errors are found in the logfile (so no errors in the stats)
	printf "No errors found on %s\n\n" "$STATS_LOCATION" >> $BTRFS_LOG 2>&1
	rm -rf $LOGFILE
else
	# If something else than 0 errors are found in the logfile
	printf "WARNING: errors found on %s. Contacting system administrator.\n\n" "$STATS_LOCATION" >> $BTRFS_LOG 2>&1
	$PUSHBULLET_SCRIPT "ArchServer: HARD DRIVE FAILURE" "During a btrfs device stats check on location \"$STATS_LOCATION\", errors were detected. More information in the logfile \"$LOGFILE\"." >/dev/null 2>&1
fi