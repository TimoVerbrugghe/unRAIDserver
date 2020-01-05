## Installation guide for Radarr on Arch
# Create folders & Git clone the radarr github project
	mkdir ~/Applications/radarr/app && mkdir ~/Applications/radarr/data
	cd ~/Applications/radarr/app

	curl -L -O $( curl -s https://api.github.com/repos/Radarr/Radarr/releases | grep linux.tar.gz | grep browser_download_url | head -1 | cut -d \" -f 4 )
	tar -xvzf Radarr.develop.*.linux.tar.gz
	mv Radarr/* ~/Applications/radarr/app

# Move radarr systemd file to /etc/systemd/system/
# Enable & start systemd service
	systemctl enable radarr.service
	systemctl start radarr.service

# Go to default port (7878) & start configuration