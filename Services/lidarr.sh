## Installation guide for lidarr on Arch
# Create folders & download the lidarr project
	mkdir ~/Applications/lidarr/app && mkdir ~/Applications/lidarr/data
	cd ~/Applications/lidarr/app

	# Go to https://github.com/lidarr/Lidarr/releases and downloaded latest release

	# untar release in .../lidarr/app folder
	tar -xzvf Lidarr.develop.XXXXX.linux.tar.gz


# Move lidarr systemd file to /etc/systemd/system/
# Enable & start systemd service
	systemctl enable lidarr.service
	systemctl start lidarr.service

# Go to default port & start configuration