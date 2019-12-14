## Deluge installation on Arch
# Install deluge package
	pacman -Syu deluge python2-service-identity python2-notify python2-mako

# Add the deluge systemd files to the systemd user folder (since default arch linux install systemd files will overwrite fileserver user always with the deluge user on startup of the service)
	/home/fileserver/.config/systemd/user/deluged.service
	/home/fileserver/.config/systemd/user/deluge-web.service

# Enable & start systemd service
	systemctl --user enable deluged.service
	systemctl --user enable deluge-web.service

	systemctl --user start deluged.service
	systemctl --user start deluge-web.service

# Go to the default port (8112) & start configuration
	# Default password deluge
	# Password fileserver

# After initial startup, you can change the port in the config file
	nano /home/fileserver/.config/deluge/web.conf
		port: 8080

# Install AutoRemovePlus plugin, download from https://github.com/omaralvarez/deluge-autoremoveplus/releases
	# Upload the python egg file to the deluge web interface (settings -> plugins)  