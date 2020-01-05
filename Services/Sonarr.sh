## Installation guide for Sonarr on Arch
# Install dependencies
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
	# Set configuration

	# Then, import series
	# Go to add series & then import existing series from disk