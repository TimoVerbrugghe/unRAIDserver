## Let's Encrypt installation on Arch Linux
# Install cerbot package
pacman -Syu certbot
certbot certonly --email timo@hotmail.be -d timoverbrugghe.duckdns.org -d www.timo.be --webroot -w /home/fileserver/Media/Network/

# Place certbot.service & certbot.timer in /etc/systemd/system/
systemctl enable certbot.timer

# Check if timer is enabled correctly
systemctl list-timers