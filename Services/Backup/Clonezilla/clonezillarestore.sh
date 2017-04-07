#!/bin/bash

# Emergency restore script that restores the internal SSD of this server (/dev/sda) from an image on the RAID-5 installation (mounted at ~/Media)
# This restore is done through Clonezilla. Clonezilla-specific commands can be found at /etc/grub.d/40_custom
# This script is only as preparation for the restore and actual launch of Clonezilla.

# Starting emergency Clonezilla Restore
echo "Starting emergecy Clonezilla Restore. Time & Date right now is $(date)" 2>&1

# Setup of boot environment
echo "Setting up boot environment"

# Set default boot entry
echo "Setting default boot entry"
grub-set-default 0 >/dev/null 2>&1

# Set boot-once entry
echo "Setting boot-once entry: Clonezilla (Arch Restore)"
grub-reboot "Clonezilla (Arch Restore)" >/dev/null 2>&1

# Send a notification to system administrator that a backup is about to happen
echo "Sending notification to System Administrator" 2>&1
/home/fileserver/Applications/pushbullet.sh "ArchServer: Restore Started" "An emergency restore of the Internal SSD from an image using Clonezilla has begun." >/dev/null 2>&1 &&

# Reboot the system to initiate the restore
echo "Rebooting system to start Clonezilla Backup" 2>&1
reboot
