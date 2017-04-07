## Crashplan Installation on Arch
# Install crashplan service
	pacaur -Syu crashplan

# Set right java version
	sudo archlinux-java set java-8-openjdk/jre

# Change memory for crashplan
	nano /opt/crashplan/bin/run.conf
	# change -Xmx option at SRV options to 4096 mb

# Enable systemd server
	systemctl enable crashplan.service
	systemctl start crashplan.service

# Open crashplan desktop app and follow instructions