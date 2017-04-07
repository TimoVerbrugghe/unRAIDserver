#!/bin/bash
## This script takes a location as input and starts a btrfs scrub command on that location. Based on the output of the scrub command, the script informs system administrator of errors.

#############
# Variables #
#############

BTRFS_LOG="/home/fileserver/Applications/btrfscheck/btrfscheck.log"
PUSHBULLET_SCRIPT="/home/fileserver/Applications/pushbullet.sh"
SCRUB_LOCATION=$1

printf "Starting BTRFS scrub on %s. Time & Date right now is $(date)\n" "$STATS_LOCATION" >> $BTRFS_LOG 2>&1

# See which logfile needs to be used

if [[ $SCRUB_LOCATION -ef /home/fileserver/Media ]]  ; then
	LOGFILE="/tmp/scrubraid"
elif [[ $SCRUB_LOCATION -ef /home/fileserver/Backup ]] ; then
	LOGFILE="/tmp/scrubbackup"
elif [[ $SCRUB_LOCATION -ef / ]] ; then
	LOGFILE="/tmp/scrubroot"
else
	echo "Error: You need to provide a correct location to scrub"
	exit 0
fi


## Setup of files

rm -rf $LOGFILE
touch $LOGFILE

## Start scrub

btrfs scrub start -B $SCRUB_LOCATION >> $LOGFILE 2>&1

## Check if scrub contains errors
# If "with 0 errors" is NOT PRESENT in the logfile
if ! grep -q "with 0 errors" $LOGFILE ; then
	printf "WARNING: errors found during scrub on %s. Contacting system administrator.\n\n" "$STATS_LOCATION" >> $BTRFS_LOG 2>&1
	$PUSHBULLET_SCRIPT "ArchServer: HARD DRIVE FAILURE" "During a btrfs scrub on location \"$SCRUB_LOCATION\", errors were detected. More information in the logfile \"$LOGFILE\"." >/dev/null 2>&1
else
	# "with 0 errors" was found in the logfile, so delete it
	printf "Scrub finished on %s. No errors found.\n\n" "$STATS_LOCATION" >> $BTRFS_LOG 2>&1
	rm -rf $LOGFILE
fi
