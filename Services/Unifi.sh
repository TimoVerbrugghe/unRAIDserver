 ## Unifi Controller installation on ArchServer 
 # Add firewall exceptions
 	# Add 8080/tcp, 8443/tcp & 3487/udp to the UFW firewall
 	ufw allow from 192.168.0.0/24 to any port 8080 proto tcp
 	ufw allow from 192.168.0.0/24 to any port 8443 proto tcp
 	ufw allow from 192.168.0.0/24 to any port 3487 proto udp

# Install correct mongodb package
	yay -Syu mongodb-bin # don't install the regular mongodb package, since it takes several hours to compile. monogodb-bin is a precompiled package

 # Install unifi package
 	yay -Syu unifi

 # Enable & start unifi controller
 	systemctl enable unifi
 	systemctl start unifi

 # SSH into the Unifi AP access point and perform the following commands
 	set-default #resets device
 	set-inform http://<ip-address of server>:8080/inform # makes sure unifi ap is announcing itself to the correct controller

# Go to https://<ip-address of server>:8443 to start configuration

 	# Don't forget to do an RF environment scan to set up the best channels 
 	# Set up static IP
 	# Set up controller name, cloud access & Site name
 	# Set up cloud access and that you can sign in with your UBNT account at https://unifi.ubnt.com

 # Run systemd service certbot to enable SSL on unifi controller