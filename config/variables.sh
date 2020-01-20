PUSHBULLET_SCRIPT="/home/fileserver/Applications/ArchServer/Services/pushbullet.sh"
RCLONE_EXCLUSIONS="/home/fileserver/Applications/ArchServer/config/rclone_exclusions"
MEDIA_LOCATION="/home/fileserver/Media"
BACKUP_LOCATION="/home/fileserver/Backup"
RESTORE_LOCATION="/home/fileserver/Temporary"

BACKUP_LOG="/home/fileserver/Applications/logs/backup.log"
RCLONE_LOG="/home/fileserver/Applications/logs/rclone.log"
RESTORE_LOG="/home/fileserver/Applications/logs/restore.log"
DELETE_LOG="/home/fileserver/Applications/logs/deletelatenight.log"

ERRORVALUE=0

RESTORE_FOLDERS=(Applications Games Movies Network Photos SystemImage TVShows)
BACKUP_FOLDERS=(Applications Books Games Movies Music Network OSInstallISO Photos Software SystemImage TVShows)
LATENIGHT_FOLDERS=("The Late Show with Stephen Colbert" "The Daily Show" "Last Week Tonight with John Oliver")
SONARR_API_KEY=