## Netdata Installation on Arch Linux
# Install packages
	pacman -Syu netdata lm_sensors

# Change following values in /etc/netdata/netdata.conf
	default port = 8087
	history = 1800
	update every = 2


# Enable & start systemd services
	systemctl enable netdata.service
	systemctl start netdata.service