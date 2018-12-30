## CUPS
# Install packages
	pacman -Syu cups hplip libcups

# Enable systemd services
	systemctl enable org.cups.cupsd.service
	systemctl start org.cups.cupsd.service

# Add user to correct groups
	sudo usermod -a -G sys lp fileserver

# Install printer
	hp-setup -i 
	# Follow instructions

# Go to port 631 and share a printer through the CUPS interface
	# Enable "Share printers connected to this system" & "Allow printing from the internet"

# Restart cups

## Google cloud Print
# Install packages
	yay -Syu bzr avahi git

# Download and compile gcp-connector from source
	cd ~/
	go get github.com/google/cloud-print-connector/...

# 