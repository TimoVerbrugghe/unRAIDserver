## pfSense Installation on ArchServer

## Set up new pfSense VM
	# Move qemuargspfsense to ~/Applications/pfsense/
	# Move pfsense.service to /etc/systemd/system/pihole.service
	systemctl enable pfsense.service

	# Create directory WITHOUT copy-on-write (disabling copy-on-write on BTRFS where VM image is stored increases VM performance)
	mkdir /home/fileserver/Applications/pfsense
	chattr +C /home/fileserver/Applications/pfsense

	# Create PFSense image file
	qemu-img create -f raw /home/fileserver/Applications/pfsense/pfsense.img 10G

	# Start the pfSense VM

# Follow installation instructions on screen - VNC is enabled on port 5901