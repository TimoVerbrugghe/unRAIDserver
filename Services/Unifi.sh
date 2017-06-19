 ## Unifi Controller installation on ArchServer
 # Install unifi package
 	pacman -Syu unifi

 # Enable & start unifi controller
 	systemctl enable unifi
 	systemctl start unifi

 # Go to localhost:8443 to start configuration
 	# Don't forget to do an RF environment scan to set up the best channels 
 	# Set up static IP
 	# Set up controller name, cloud access & Site name

 # Add firewall exceptions
 	# Port 8080 & 8443 on local network