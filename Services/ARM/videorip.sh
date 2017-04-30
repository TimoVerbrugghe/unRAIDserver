#!/bin/bash
# This script rips a Video CD/DVD to a (or multiple) mkv files

##########################
# Initializing Variables #
##########################

# Default Variables
	PUSHBULLET_SCRIPT="/home/fileserver/Applications/pushbullet.sh"
	RIPFOLDER="/home/fileserver/Media/DriveRip"

# MakeMKV variables
	# Method of MakeMKV to use for Blu Ray discs.  Options are "mkv" or "backup".
	# mkv is the normal method of ripping mkv files directly from the DVD
	# backup decrypts the dvd and then copies it to the hard drive.  This allows HandBrake to apply some of it's
	# analytical abilities such as the main-feature identification.  This method seems to offer success on bluray 
	# discs that fail in "mkv" mode. *** NOTE: MakeMKV only supports the backup method on BluRay discs.  Regular
	# DVD's will always default back to the "mkv" mode. If this is set to "backup" then you must also set HandBrake's MAINFEATURE to true. 
	RIPMETHOD="mkv" 

	# MakeMKV Arguments
	# MakeMKV Profile used for controlling Audio Track Selection.
	# This is the default profile MakeMKV uses for Audio track selection. Updating this file or changing it is considered
	# to be advanced usage of MakeMKV. But this will allow users to alternatively tell makemkv to select HD audio tracks and etc.
	# MKV_ARGS="--profile=/opt/arm/default.mmcp.xml"
	MKV_ARGS=""

	# Minimum length of track for MakeMKV rip (in seconds)
	MINLENGTH="600"

# Setting Destination folder
	DEST="${RIPFOLDER}/${VIDEO_TITLE}"

# Other Variables
	VIDEO_TITLE=$1
	LOG="/home/fileserver/Applications/ARM/logs/videorip.log"

###################
# Start Video Rip #
###################
printf "Starting ripping VIDEO CD/DVD. Time & Date right now is $(date)\n" >> "$LOG"
printf "Video Title is ${VIDEO_TITLE}\n" >> "$LOG"
printf "Ripping video ${ID_FS_LABEL} from ${DEVNAME}\n" >> "$LOG"

printf "Sending message\n" >> "$LOG"
$PUSHBULLET_SCRIPT "ArchServer: Video Rip Started" "ArchServer has identified an Video CD/DVD in its tray and has begun ripping. A seperate message will be sent when completed."

# Create destination folder if not already created
mkdir -p "$DEST"

# Start timer
RIPSTART=$(date +%s);

	# Rip either Bluray or DVD
	if [ "$RIPMETHOD" = "backup" ] && [ "$ID_CDROM_MEDIA_BD" = "1" ]; then
		printf "Using backup method of ripping." >> "$LOG"
		DISC="${DEVNAME: -1}"
		makemkvcon backup --decrypt $MKV_ARGS -r disc:"$DISC" "$DEST"/ >> "$LOG"
	else
		# if DVD
		printf "Using mkv method of ripping." >> "$LOG"
		makemkvcon mkv $MKV_ARGS dev:"$DEVNAME" all "$DEST" --minlength="$MINLENGTH" -r >> "$LOG"
	fi

# Stopping timer & calculating Ripping time
RIPEND=$(date +%s);
RIPSEC=$((RIPEND-RIPSTART));
RIPTIME="$((RIPSEC / 3600)) hours, $(((RIPSEC / 60) % 60)) minutes and $((RIPSEC % 60)) seconds."

# Setting right permissions
chmod -R 755 "$DEST"
chown -R fileserver:fileserver "$DEST"

# Ripping completed, sending message to sysadmin
printf "Video CD/DVD ripping completed in %s. Sending message\n\n" "$RIPTIME" >> "$LOG"
$PUSHBULLET_SCRIPT "ArchServer: Video Rip completed" "ArchServer has completed ripping the video cd/dvd. It can now safely be ejected."

exit 0