#!/bin/bash
# This script rips a Data CD/DVD to an iso file

##########################
# Initializing Variables #
##########################

# Default Variables
	PUSHBULLET_SCRIPT="/home/fileserver/Applications/pushbullet.sh"
	RIPFOLDER="/home/fileserver/Media/DriveRip"

# Setting Destination folder
	FILENAME=${ID_FS_LABEL}_disc.iso
	DEST="${RIPFOLDER}/$FILENAME"

# Other Variables
	LOG="/home/fileserver/Applications/ARM/logs/datarip.log"

##################
# Start Data Rip #
##################
printf "Starting ripping DATA CD/DVD. Time & Date right now is $(date)\n" >> "$LOG"

printf "Sending message\n" >> "$LOG"
$PUSHBULLET_SCRIPT "ArchServer: Data Rip Started" "ArchServer has identified an Data CD/DVD in its tray and has begun ripping. A seperate message will be sent when completed."

# Create destination folder if not already created
mkdir -p "$DEST"

# Using cat instead of dd because of performance
# dd if=/dev/sr0 of=$DEST/$FILENAME 
cat "$DEVNAME" > "$DEST"
		
# Setting right permissions
chmod -R 755 "$RIPFOLDER"
chown -R fileserver:fileserver "$RIPFOLDER"

# Ripping completed, sending message
printf "Ripping completed. Sending message\n\n" >> "$LOG"
$PUSHBULLET_SCRIPT "ArchServer: Data Rip completed" "ArchServer has completed ripping the data cd/dvd. It can now safely be ejected."

exit 0