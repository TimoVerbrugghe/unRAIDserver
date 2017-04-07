## Enabling cron-like functionality in Arch Linux
# Cron-like functionality is achieved using systemd timers. 
# More info at: https://wiki.archlinux.org/index.php/Systemd/Timers

# Make sure /home/fileserver/Applications/Backup|duckdns folders exists

# Install all systemd timer & service files in /etc/systemd/system
systemctl enable clonezillabackup.timer
systemctl enable dailybackup.timer
systemctl enable duckdns.timer

systemctl start clonezillabackup.timer
systemctl start dailybackup.timer
systemctl start duckdns.timer

# You can take a look if timers are enabled correctly using
systemctl list-timers