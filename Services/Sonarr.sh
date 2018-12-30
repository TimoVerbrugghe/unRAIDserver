## Installation guide for Sonarr on Arch
# Install sonarr package
	yay -Syu sonarr

# Edit sonarr systemd file
	systemctl edit sonarr
		# Add content from sonarr.conf

# create data directory
	mkdir ~/Applications/sonarr

# Enable & start systemd service
	systemctl enable sonarr.service
	systemctl start sonarr.service

# Go to default port 8989 & start configuration
	# First - Try the Backup & Restore method - https://github.com/Sonarr/Sonarr/wiki/Backup-and-Restore

	# Otherwise
		# Set configuration

		# Then, import series
		# Go to add series & then import existing series from disk