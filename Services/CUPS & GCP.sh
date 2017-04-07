## CUPS
# Install packages
	pacman -Syu cups hplip 

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
	pacaur -Syu gcp-cups-connector

	## IF THIS INSTALLATION FAILS -> BUILD MANUALLY
	# Go to .cache/pacaur/gcp-cups-connector
	# copy the pkgver from PKGBUILD

	cd ~/build/
	curl -L -O https://aur.archlinux.org/cgit/aur.git/snapshot/gcp-cups-connector.tar.gz
	tar -xvf gcp-cups-connector.tar.gz
	cd gcp-cups-connector

	nano .SRCINFO && nano PKGBUILD
		# Change pkgver to the latest version in both files

	makepkg -sri


	gcp-connector-util init
		# Follow instructions

	# Move gcp-cups-connector.config.json to ~/Applications/gcp-cups-connector

	# Place systemd service file to /etc/systemd/system
	systemctl enable gcp-cups-connector.service
	systemctl start gcp-cusp-connector.service
