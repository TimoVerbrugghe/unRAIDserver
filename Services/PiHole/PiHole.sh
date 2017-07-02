## Pi-Hole Installation on ArchServer
# If WindowsVM has not been installed yet, follow instructions in Qemu-Kvm.sh (Services/WindowsVM) first to set up qemu-kvm & bridged networking

## Set up new bridge for Qemu VM
nano /etc/netctl/tuntap1
		Description='Tuntap connection for qemu - PiHole'
		Interface=tap1
		Connection=tuntap
		Mode='tap'
		User='nobody'
		Group='nobody'

nano /etc/netctl/bridge
	BindsToInterfaces=(enp3s0 tap0 tap1)

netctl enable tuntap1
netctl start tuntap1

## Set up new ubuntu server VM
	# Move qemuargspihole to ~/Applications/pihole/
	# Move pihole.service to /etc/systemd/system/pihole.service
	systemctl enable pihole.service

	# Download the latest ubuntu server iso & place it in ~/Applications/pihole/ubuntu.iso

	# Create directory WITHOUT copy-on-write (disabling copy-on-write on BTRFS where VM image is stored increases VM performance)
	mkdir /home/fileserver/Applications/pihole
	chattr +C /home/fileserver/Applications/pihole

	# Create pihole hard drive image
	qemu-img create -f raw /home/fileserver/Applications/pihole/pihole.img 10G

	# Start the pihole VM

####################
# Ubuntu Server VM #
####################

# Pi-Hole is only supported up to Ubuntu 16.10 - Later versions are not yet officially supported - Using Ubuntu 16.04.2 LTS in Pi-Hole VM

# Go through Ubuntu Server Installation (You can connect to a vnc server at port :5901 for a graphical install, make sure firewall allows port 5901)
	# Hostname PiHole
	# User pihole
	# No extra installation (no standard system utilities or any other extra packages)
	# Guided - Use entire disk

# Post-Installation
	# First update
	sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get dist-upgrade -y && sudo apt-get autoremove -y

	# Installation of nano, wget (needed for pihole install) & openssh, ufw
	sudo apt-get install nano curl openssh-server ufw php-zip

	# Set up static IP
	nano /etc/network/interfaces
		iface <interfacename> inet static
	        address 192.168.0.4
	        netmask 255.255.255.0
	        gateway 192.168.0.1
	        dns-nameservers 8.8.8.8 8.8.4.4

	    iface <interfacename> inet6 static
	    	address 2a02:1810:4f2b:7900::4
	        netmask 64
	        gateway fe80::1
	        dns-nameservers 2001:4860:4860::8888 2001:4860:4860::8844

	# Set up SSH
	nano /etc/ssh/sshd_config
		PermitRootLogin no

		# If not already enabled
		systemctl enable sshd
		systemctl start sshd

	# Set up UFW -> see ufwrules in pihole folder

	# Faster boot
	nano /etc/default/grub
		GRUB_TIMEOUT=0

	update-grub

	# Time synchronization
	ln -sf /usr/share/zoneinfo/Europe/Brussels /etc/localtime
	timedatectl set-ntp true

	# Install Pi-Hole
	curl -sSL https://install.pi-hole.net | bash
		# Follow Pi-Hole installation instructions
		# Do net let Pi-Hole setup IP address or firewall (already manually set up)
			# Pi-Hole will STILL create a file /etc/dhcpcd.conf with your IP address in it, this file needs to be changed if ip address of pi-hole (or VM) ever changes
			# Pi-Hole will not enable IPv6 OpenDNS support, need to enable it through the web admin interface

	# Change admin password
	sudo pihole -a -p <newpassword>

	# Place adlists.list & whitelist.txt in /etc/pihole
	# Update domains & whitelist
	pihole -g
	
	# Enable auto updating for pihole
	nano /etc/cron.d/pihole
		# Uncomment the auto-update line in this cron file
		
	# Enable OS auto updating
	# Move ubuntuupdate.service & ubuntuupdate.timer to /etc/systemd/system
	systemctl enable ubuntuupdate.service
	systemctl enable ubuntuupdate.timer
	systemctl start ubuntuupdate.timer

