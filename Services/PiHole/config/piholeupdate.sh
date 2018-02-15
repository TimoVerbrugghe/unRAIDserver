#!/bin/bash
# This script ensures the ad block list is updated correctly for pihole

PIHOLE_UPDATE_LOG=/home/pihole/piholeupdate.log

######################
# RESET ADLISTS FILE #
###################### 
printf "Starting Pihole Update. Time & Date right now is $(date)\n" >> $PIHOLE_UPDATE_LOG 2>&1
printf "Resetting adlists file\n" >> $PIHOLE_UPDATE_LOG 2>&1

# Trim adlists file starting from where custom domains are added
# Get line number where custom insertions in adlists.list start
LINENUMBER=$(sed -n '/Custom domains added by Timo/=' /etc/pihole/adlists.list)

# Trim adlists.list file to delete custom insertions
sed -i ''"$LINENUMBER"',$d' /etc/pihole/adlists.list

# Add custom adlists.list insertions
cat /home/pihole/customadlists.list >> /etc/pihole/adlists.list

######################
# RESET WALLY3K LIST #
######################
printf "Adding Wally3k list to adlists.list file\n" >> $PIHOLE_UPDATE_LOG 2>&1
# This script takes the list available at https://wally3k.github.io/, downloads it and makes it available so pihole can put it in its gravity list
# 1 > ensures that no duplicates are placed in the list when it's downloaded again, since the file is recreated
curl https://v.firebog.net/hosts/lists.php?type=nocross >> /etc/pihole/adlists.list

######################
# RESET YOUTUBE LIST #
######################
printf "Resetting youtube list\n" >> $PIHOLE_UPDATE_LOG 2>&1
# This script takes the pihole log and scans it for youtube ads, then appends it to a locally stored list which pihole can take into its gravity list
# http://localhost/youtube-ads-list.txt needs to be added to adlists.list

# Greps the log for youtube ads and appends to /var/www/html/youtube-ads-list.txt
grep r*.googlevideo.com /var/log/pihole.log | awk '{print $8}'| grep -v '^googlevideo.com\|redirector' | sort -nr | uniq >> /var/www/html/youtube-ads-list.txt
# Removes duplicate lines from /var/www/html/youtube-ads-list.txt
perl -i -ne 'print if ! $x{$_}++' /var/www/html/youtube-ads-list.txt

######################
# RESET GRAVITY LIST #
######################
printf "Updating Pi-Hole\n" >> $PIHOLE_UPDATE_LOG 2>&1
pihole -up >> $PIHOLE_UPDATE_LOG 2>&1

printf "Updating Gravity list\n" >> $PIHOLE_UPDATE_LOG 2>&1
pihole -g >> $PIHOLE_UPDATE_LOG 2>&1

printf "Pi-Hole update complete\n" >> $PIHOLE_UPDATE_LOG 2>&1
printf "#################################################\n\n" >> $PIHOLE_UPDATE_LOG 2>&1