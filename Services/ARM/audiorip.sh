#!/bin/bash
# This script rips an Audio CD/DVD

##########################
# Initializing Variables #
##########################

# Default Variables
	PUSHBULLET_SCRIPT="/home/fileserver/Applications/pushbullet.sh"
	RIPFOLDER="/home/fileserver/Media/DriveRip"

# Other Variables
	ABCDE_CONFIG="/home/fileserver/Applications/ARM/abcde.conf"
	LOG="/home/fileserver/Applications/ARM/logs/audiorip.log"

###################
# Start Audio Rip #
###################
printf "Starting ripping AUDIO CD/DVD. Time & Date right now is $(date)\n" >> "$LOG"
printf "Sending message\n" >> "$LOG"
$PUSHBULLET_SCRIPT "ArchServer: Audio Rip Started" "ArchServer has identified an audio CD in its tray and has begun ripping. A separate message will be sent when completed."

# For some reason, abcde is very picky with path, so creating temporary PATH variable and adding /usr/bin to it
export PATH="$PATH:/usr/bin"

# Start rip using custom configuration file (which defines the output folder)
abcde -d "$DEVNAME" -c "$ABCDE_CONFIG" >> "$LOG"

# Setting right permissions
chmod -R 755 "$RIPFOLDER"
chown -R fileserver:fileserver "$RIPFOLDER"

printf "Ripping completed. Sending message.\n\n" >> "$LOG"
$PUSHBULLET_SCRIPT "ArchServer: Audio Rip completed" "ArchServer has completed ripping the audio cd/dvd. It can now safely be ejected."