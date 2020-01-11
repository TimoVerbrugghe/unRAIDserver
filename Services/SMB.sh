## SMB
	# Install samba package
	pacman -Syu samba avahi nss-mdns

	## Avahi
		# Set up avahi local hostname resolution
		nano /etc/nsswitch.conf
		hosts: files ... mdns_minimal [NOTFOUND=return] ... 

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

	## Samba
	# Move correct smb.conf (config/smb.conf) to etc/samba/smb.conf

	# create samba password
	smbpasswd -a fileserver
		# Enter password


## Enable WSD discovery method
	# Download latest release from https://github.com/christgau/wsdd
	# Move wsdd.py to /home/fileserver/Applications/wsdd and rename to wsdd
	# Move wsdd.service to /etc/systemd/system

## Enable systemd samba services
	systemctl enable smb.service nmb.service wsdd.service
	systemctl start smb.service nmb.service wsdd.service
	