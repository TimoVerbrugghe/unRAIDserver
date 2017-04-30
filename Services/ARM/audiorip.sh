#!/bin/bash
# This script rips an Audio CD/DVD

##########################
# Initializing Variables #
##########################

# Default Variables
	PUSHBULLET_SCRIPT="/home/fileserver/Applications/pushbullet.sh"

# Other Variables
	ABCDE_CONFIG="/home/fileserver/Applications/ARM/abcde.conf"
	LOG="/home/fileserver/Applications/ARM/logs/audiorip.log"

###################
# Start Audio Rip #
###################
printf "Starting ripping AUDIO CD/DVD. Time & Date right now is $(date)\n" >> "$LOG"
printf "Sending message\n" >> "$LOG"
$PUSHBULLET_SCRIPT "ArchServer: Audio Rip Started" "ArchServer has identified an audio CD in its tray and has begun ripping. A seperate message will be sent when completed."

# Start rip using custom configuration file (which defines the output folder)
abcde -d "$DEVNAME" -c "$ABCDE_CONFIG" >> "$LOG"

printf "Ripping completed. Sending message.\n\n" >> "$LOG"
$PUSHBULLET_SCRIPT "ArchServer: Audio Rip completed" "ArchServer has completed ripping the audio cd/dvd. It can now safely be ejected."