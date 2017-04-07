## Shellinabox
# Install the shellinabox package
pacaur -Syu shellinabox-git

# Create data directory
mkdir ~/Applications/shellinabox

# Move WhiteOnBlack.css in ~/Applications/shellinabox

# Edit the systemd file
systemctl edit shellinabox@
	# Add content from shellinabox.conf

# Enable the shellinabox as a root user (this user is required)
systemctl enable shellinabox@root.service