## CUPS
# Install packages
	pacman -Syu cups hplip libcups

# Enable systemd services
	systemctl enable org.cups.cupsd.service
	systemctl start org.cups.cupsd.service

# Add user to correct groups
	usermod -a -G sys fileserver
	usermod -a -G lp fileserver

# Install printer
	hp-setup -i <PRINTERIP>

	# Go to port 631 
	# Go to administation -> share a printer through the CUPS interface
	# Enable "Share printers connected to this system" & "Allow printing from the internet"

# Restart cups

## Google cloud Print
# Install packages
	yay -Syu bzr avahi git

# Download and compile gcp-connector from source
	cd ~/
	go get github.com/google/cloud-print-connector/...

# Configure Google Cloud Print
	cd ~/go/bin/
	./gcp-connector-util init

# Move files & clean up
	mkdir ~/Applications/gcp-cups-connector
	mv ~/go/bin/gcp-connector-util ~/go/bin/gcp-cups-connector.config.json ~/Applications/gcp-cups-connector/
	rm -rf ~/go/

# Move systemd files (gcp-cups-connector.service) to /etc/systemd/system and enable/start them
	systemctl enable gcp-cups-connector
	systemctl start gcp-cups-connector