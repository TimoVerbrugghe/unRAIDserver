#!/bin/bash

# This script is called by the gitupdate systemd service. 
# It updates all git repositories on the system and then does any post-processing needed to update applications

# Reset any changes done in the ArchServerGit repository (updating is only done one-way or by manually committing!)
/usr/bin/git -C /home/fileserver/Applications/ArchServerGit/ reset --hard

# Updating Git repositories
/usr/bin/git -C /home/fileserver/Applications/ArchServerGit/ pull
/usr/bin/git -C /home/fileserver/Media/Network/vnc/ pull
/usr/bin/git -C /home/fileserver/Media/Network/scanner/ pull
/usr/bin/git -C /home/fileserver/Media/Network/alltube/ pull

## Post Processing
# Alltube -> Npm & Composer reinstall after update
cd /home/fileserver/Media/Network/alltube
su fileserver -c "npm install"
su fileserver -c "composer install"

# Systemd reload after potential update from systemd files
/usr/bin/systemctl daemon-reload

# Set right permission for scripts, since they lose execution permission after doing git update
/usr/bin/chmod +x /home/fileserver/Applications/Backup/dailybackup.sh
/usr/bin/chmod +x /home/fileserver/Applications/Backup/mediarestore.sh
/usr/bin/chmod +x /home/fileserver/Applications/Backup/Clonezilla/clonezillabackup.sh
/usr/bin/chmod +x /home/fileserver/Applications/btrfscheck/btrfsdevicestats.sh
/usr/bin/chmod +x /home/fileserver/Applications/failure-notification.sh
/usr/bin/chmod +x /home/fileserver/Applications/gitupdate.sh
/usr/bin/chmod +x /home/fileserver/Applications/pushbullet.sh
/usr/bin/chmod +x /home/fileserver/Applications/stopx11vnc.sh

# Restart services for which config files are linked
# Apache, Samba, FTP
/usr/bin/systemctl restart httpd smbd nmbd vsftpd