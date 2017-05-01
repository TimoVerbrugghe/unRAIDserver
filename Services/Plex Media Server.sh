## Plex Media Server Installation on Arch
# https://wiki.archlinux.org/index.php/Plex
# Install plex package
	pacaur -Syu plex-media-server

# Make work directories & copy needed files
	mkdir ~/Applications/plexmediaserver/conf.d/plexmediaserver
	cp /etc/conf.d/plexmediaserver ~/Applications/plexmediaserver/conf.d/plexmediaserver

# Change environment file
	nano ~/Applications/plexmediaserver/conf.d/plexmediaserver
		LD_LIBRARY_PATH=/opt/plexmediaserver
		PLEX_MEDIA_SERVER_HOME=/opt/plexmediaserver
		PLEX_MEDIA_SERVER_APPLICATION_SUPPORT_DIR=/home/fileserver/Applications/plexmediaserver
		PLEX_MEDIA_SERVER_MAX_PLUGIN_PROCS=6
		PLEX_MEDIA_SERVER_TMPDIR=/tmp
		TMPDIR=/tmp

# Change systemd file
	systemctl edit plexmediaserver.service
		# Add content from plexmediaserver.conf

# Enable & start systemd service
	systemctl enable plexmediaserver.service
	systemctl start plexmediaserver.service

# Configure Plex Media Server by going to port 32400/web

## Trakt TV plugin
	# Download latest trakt TV plugin release from https://github.com/trakt/Plex-Trakt-Scrobbler
	# Unzip & move Trakttv.bundle to /home/fileserver/Applications/plexmediaserver/Plex\ Media\ Server/Plug-ins/

## SSL support
	# Go to Settings -> Server -> Network
	# Custom certificate location -> /home/fileserver/Applications/plexmediaserver/certificate.pfx
	# Custom certificate encryption key -> plexmediaserver
	# Custom certificate domain -> www.timo.be