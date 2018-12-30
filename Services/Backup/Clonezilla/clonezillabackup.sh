#!/bin/bash

# Monthly Backup script that backups up the internal SSD of this server (/dev/sda) to an image on the RAID-5 installation (mounted at ~/Media)
# This backup is done through Clonezilla. Clonezilla-specific commands can be found at /etc/grub.d/40_custom
# This script is only as preparation for the backup and actual launch of Clonezilla

# Remove old backup logs, recreate them & set right permissions
rm -rf /home/fileserver/Applications/Backup/logs/backup.log >/dev/null 2>&1
rm -rf /home/fileserver/Applications/Backup/logs/rsync.log >/dev/null 2>&1
rm -rf /home/fileserver/Applications/Backup/logs/windowsvmuserfolder.log >/dev/null 2>&1
rm -rf /home/fileserver/Applications/btrfscheck/btrfscheck.log >/dev/null 2>&1
rm -rf /home/fileserver/Applications/autoupdate/autoupdate.log >/dev/null 2>&1
rm -rf /home/fileserver/Applications/ARM/logs/* >/dev/null 2>&1

touch /home/fileserver/Applications/Backup/logs/backup.log >/dev/null 2>&1
touch /home/fileserver/Applications/Backup/logs/rsync.log >/dev/null 2>&1
touch /home/fileserver/Applications/Backup/logs/windowsvmuserfolder.log >/dev/null 2>&1
touch /home/fileserver/Applications/btrfscheck/btrfscheck.log >/dev/null 2>&1
touch /home/fileserver/Applications/autoupdate/autoupdate.log >/dev/null 2>&1

chmod 755 -R /home/fileserver/Applications/Backup/logs >/dev/null 2>&1
chown fileserver:fileserver -R /home/fileserver/Applications/Backup/logs >/dev/null 2>&1

chmod 755 -R /home/fileserver/Applications/btrfscheck/btrfscheck.log >/dev/null 2>&1
chown fileserver:fileserver -R /home/fileserver/Applications/btrfscheck/btrfscheck.log >/dev/null 2>&1

# Starting Monthly/Clonezilla Backup
printf "Starting Monthly/Clonezilla Backup. Backup logs have been reset. Time & Date right now is $(date)\n" >>/home/fileserver/Applications/Backup/logs/backup.log 2>&1

# Remove old backup
printf "Preparing Clonezilla Backup\n" >>/home/fileserver/Applications/Backup/logs/backup.log 2>&1
printf "Removing old backup\n" >>/home/fileserver/Applications/Backup/logs/backup.log 2>&1
rm -rf /home/fileserver/Media/SystemImage/Fileserver >/dev/null 2>&1

# Clean up caches
printf "Cleaning caches\n" >>/home/fileserver/Applications/Backup/logs/backup.log 2>&1
yes | paccache -rk 0 >/dev/null 2>&1
yes | paccache -ruk0 >/dev/null 2>&1
yes | yay -Scc --noconfirm 2>&1 || true && # It can be that command fails because no packages to delete, in that case, still give out value true so script can continue
rm -rf /home/fileserver/.build/packages/* 2>&1 &&
rm -rf /home/fileserver/.cache/yay/* 2>&1 &&
rm -rf /home/fileserver/.m2 2>&1 &&
rm -rf /home/fileserver/.mysql_history 2>&1 &&
rm -rf /home/fileserver/.npm 2>&1 &&
rm -rf /home/fileserver/.composer 2>&1 &&
rm -rf /home/fileserver/.python_history 2>&1 &&
rm -rf /home/fileserver/.node-gyp 2>&1 &&
rm -rf /home/fileserver/.rnd 2>&1 &&
rm -rf /home/fileserver/.dvdcss 2>&1 &&
rm -rf /home/fileserver/.bzr.log 2>&1 &&
rm -rf /home/fileserver/.wget-hsts 2>&1 &&
rm -rf /home/fileserver/.thumbnails 2>&1 &&

printf "Cleaning Desktop & DriveRip folder\n" >>/home/fileserver/Applications/Backup/logs/backup.log 2>&1
rm -rf /home/fileserver/Desktop/* 2>&1 &&
rm -rf /home/fileserver/Media/DriveRip/* 2>&1 &&

printf "Cleaning completed Downloads folder\n" >>/home/fileserver/Applications/Backup/logs/backup.log 2>&1
rm -rf /home/fileserver/Media/Downloads/complete/tvshows/* 2>&1
rm -rf /home/fileserver/Media/Downloads/complete/movies/* 2>&1

# Removing unnecessary packages
printf "Removing unnecessary packages\n" >>/home/fileserver/Applications/Backup/logs/backup.log 2>&1
yes | pacman -Rns $(pacman -Qtdq) 2>&1 || true && # It can be that command fails because no packages to delete, in that case, still give out value true so script can continue

# Setup of boot environment
printf "Setting up boot environment\n" >>/home/fileserver/Applications/Backup/logs/backup.log 2>&1

# Set default boot entry
grub-set-default 0 >/dev/null 2>&1

# Set boot-once entry
grub-reboot "Clonezilla (Arch Backup)" >/dev/null 2>&1

# Send a notification to system administrator that a backup is about to happen
printf "Send notification to System Administrator\n" >>/home/fileserver/Applications/Backup/logs/backup.log 2>&1
/home/fileserver/Applications/pushbullet.sh "ArchServer: Monthly Backup Started" "Backup of Internal SSD to an image using Clonezilla has begun. All configuration files are in ~/Applications/Backup. Manual Clonezilla backup also possible using interactive Clonezilla environment (sudo grub-reboot \"Clonezilla (interactive)\")" >/dev/null 2>&1 &&

# Reboot the system to initiate the backup
printf "Rebooting system to start Clonezilla Backup\n\n" >>/home/fileserver/Applications/Backup/logs/backup.log 2>&1
reboot
