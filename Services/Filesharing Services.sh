## Filesharing Services - Arch Install

## NFS
	# Install nfs-utils
	pacman -Syu nfs-utils

	# Add share to /etc/exports
	/home/fileserver/Media 192.168.0.0/24(rw,sync,no_root_squash,no_subtree_check,insecure)

	# Enable systemd service for nfs
	systemctl enable nfs-server.service

## FTP
	# Install vsftpd
	pacman -Syu vsftpd

	# Move correct vsftpd.conf (config/vsftpd.conf) to /etc/vsftpd.conf

	# make folders in root mode
	sudo su
	mkdir /var/run/vsftpd
	mkdir /var/run/vsftpd/empty

	# Enable systemd service for ftp service
	systemctl enable vsftpd.service

## SMB
	# Install samba package
	pacman -Syu samba avahi nss-mdns

	## Avahi
		# Set up avahi local hostname resolution
		nano /etc/nsswitch.conf
		hosts: files mdns_minimal [NOTFOUND=return] dns myhostname

		# Advertise smb server on Avahi network
		nano /etc/avahi/services/smb.service

		<?xml version="1.0" standalone='no'?>
		<!DOCTYPE service-group SYSTEM "avahi-service.dtd">
		<service-group>
		  <name replace-wildcards="yes">%h</name>
		  <service>
		    <type>_smb._tcp</type>
		    <port>445</port>
		  </service>
		  <service>
		   <type>_device-info._tcp</type>
		   <port>0</port>
		   <txt-record>model=RackMac</txt-record>
		 </service>
		</service-group>

		# Enable & start service
		systemctl enable avahi-daemon.service
		systemctl start avahi-daemon.service

	# Move correct smb.conf (config/smb.conf) to etc/samba/smb.conf

	# create samba password
	smbpasswd -a fileserver
		# Enter password

	# Enable systemd samba services
	systemctl enable smbd.service nmbd.service