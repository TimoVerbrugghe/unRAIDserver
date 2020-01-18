PUSHBULLET_SCRIPT="/home/fileserver/Applications/ArchServer/Services/pushbullet.sh"
RCLONE_EXCLUSIONS="/home/fileserver/Applications/ArchServer/config/rclone_exclusions"
BACKUP_LOG="/home/fileserver/Applications/logs/backup.log"
RCLONE_LOG="/home/fileserver/Applications/logs/rclone.log"
RESTORE_LOG="/home/fileserver/restore.log"

MEDIA_LOCATION="/home/fileserver/Media"
BACKUP_LOCATION="/home/fileserver/Backup"
BACKUP_FOLDERS=(Applications Books Games Movies Music Network OSInstallISO Photos Software SystemImage TVShows)
ERRORVALUE=0

RESTORE_LOCATION="/home/fileserver/Temporary" # The location where you want to restore files to

RESTORE_FOLDERS=(Applications Games Movies Network Photos SystemImage TVShows)