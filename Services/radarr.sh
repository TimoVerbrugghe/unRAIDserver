## Installation guide for Radarr on Arch
# Create folders & Git clone the radarr github project
	mkdir ~/Applications/radarr/app && mkdir ~/Applications/radarr/data
	cd ~/Applications/radarr/app
	git clone https://github.com/Radarr/Radarr

# Move radarr systemd file to /etc/systemd/system/
# Enable & start systemd service
	systemctl enable radarr.service
	systemctl start radarr.service

# Go to default port & start configuration