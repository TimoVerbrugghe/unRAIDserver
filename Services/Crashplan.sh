## Crashplan Installation on Arch
# Install Crashplan Pro Service
	pacaur -Syu crashplan-pro

	## Temporary other installation procedure for version 4.9.0
		# Download snapshot from AUR
		# Download version 4.9.0 from https://web-ebm-msp.crashplanpro.com/client/installers/CrashPlanPRO_4.9.0_1436674888490_33_Linux.tgz
		# Get SHA256 from file (sha256sum tool)
		# Change PKGBuild -> download link & sha256
		# makepkg -si in snapshot folder

# Set right java version
	sudo archlinux-java set java-8-openjdk/jre

# Change memory for crashplan
	nano /opt/crashplan/bin/run.conf
	# change -Xmx option at SRV options to 4096 mb

# Enable systemd server
	systemctl enable crashplan-pro.service
	systemctl start crashplan-pro.service

# Open crashplan desktop app and follow instructions