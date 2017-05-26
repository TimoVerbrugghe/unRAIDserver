#!/bin/bash

##########################
# Initializing Variables #
##########################

# Default Variables
	PUSHBULLET_SCRIPT="/home/fileserver/Applications/pushbullet.sh"

# Other Variables
	VIDEO_TITLE=""
	MOVIETITLE_SCRIPT="/home/fileserver/Applications/ARM/getmovietitle.py"
	VIDEORIP_SCRIPT="/home/fileserver/Applications/ARM/videorip.sh"
	DATARIP_SCRIPT="/home/fileserver/Applications/ARM/datarip.sh"
	AUDIORIP_SCRIPT="/home/fileserver/Applications/ARM/audiorip.sh"
	LOG="/home/fileserver/Applications/ARM/logs/identify.log"

##################
# Start Identify #
##################

printf "Starting Identify Script. Time & Date right now is $(date)\n" >> "$LOG"

if [ "$ID_FS_TYPE" == "udf" ]; then
	printf "Identified udf\n" >> "$LOG"
	printf "Found ${ID_FS_LABEL} on ${DEVNAME}\n" >> "$LOG"

	# check to see if this is really a video
	mkdir -p /mnt/"$DEVNAME"
	mount "$DEVNAME" /mnt/"$DEVNAME"
	if [[ -d /mnt/${DEVNAME}/VIDEO_TS || -d /mnt/${DEVNAME}/BDMV ]]; then
		printf "Identified udf as video\n" >> "$LOG"

		# Try to get a better title for the film

		GET_TITLE_OUTPUT=$($MOVIETITLE_SCRIPT -p /mnt"${DEVNAME}" 2>&1)
		GET_TITLE_RESULT=$?

		if [ $GET_TITLE_RESULT = 0 ]; then
			printf "Obtained Title $GET_TITLE_OUTPUT\n" >> "$LOG"
			VIDEO_TITLE=${GET_TITLE_OUTPUT}
		else
			printf "failed to get title $GET_TITLE_OUTPUT\n" >> "$LOG"
			VIDEO_TITLE=${ID_FS_LABEL} 
		fi

		umount "/mnt/$DEVNAME"
		$VIDEORIP_SCRIPT "$VIDEO_TITLE"
	else
		umount "/mnt/$DEVNAME"
		printf "Identified udf as data CD/DVD\n" >> "$LOG"
		printf "IDENTIFY COMPLETE - Start ripping data\n\n" >> "$LOG"
		$DATARIP_SCRIPT
	fi


elif (("$ID_CDROM_MEDIA_TRACK_COUNT_AUDIO" > 0 )); then	
	printf "IDENTIFY COMPLETE - Start ripping audio\n\n" >> "$LOG"
	$AUDIORIP_SCRIPT

elif [ "$ID_FS_TYPE" == "iso9660" ]; then
	printf "Identified data CD/DVD\n" >> "$LOG"
	printf "IDENTIFY COMPLETE - Start ripping data\n\n" >> "$LOG"
	$DATARIP_SCRIPT

else
	printf "Unable to identify CD/DVD. Putting gathered information in log & exiting.\n" >> "$LOG"
	printf "$ID_CDROM_MEDIA_TRACK_COUNT_AUDIO\n" >> "$LOG"
	printf "$ID_FS_TYPE\n" >> "$LOG"
fi

exit 0