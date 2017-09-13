## Deluge installation on Arch
# Install deluge package
	pacman -Syu deluge python2-service-identity python2-notify python2-mako

# Edit the deluge systemd files
	systemctl edit deluged
		# Add content from deluged.conf
	systemctl edit deluge-web
		# Add content from deluge-web.conf

# Enable & start systemd service
	systemctl enable deluged.service
	systemctl enable deluge-web.service

	systemctl start deluged.service
	systemctl start deluge-web.service

# Go to the default port (8112) & start configuration
	# Default password deluge
	# Password fileserver

# After initial startup, you can change the port in the config file
	nano /home/fileserver/.config/deluge/web.conf
		port: 8080

# Install AutoRemovePlus plugin, download from https://github.com/omaralvarez/deluge-autoremoveplus/releases
	# Upload the python egg file to the deluge web interface (settings -> plugins)  