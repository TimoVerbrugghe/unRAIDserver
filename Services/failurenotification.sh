## Failure Notification service for Arch Home Server
# This will send a failure notification when a specific systemd unit fails. This only works IF an OnFailure state is added to a .service file.

# Move unit-failure-notification@.service to /etc/systemd/system/ & ~/.config/systemd/user/

## How to enable on other service
# Add OnFailure=unit-failure-notification@%n to a service file in the [Unit] section
# Use systemctl edit <SERVICENAME>.service to override existing service files

systemctl edit <SERVICENAME>.service

--------------
[Unit]
# Clearing current OnFailure setting if there is one
OnFailure= 
OnFailure=unit-failure-notification@%n
--------------

# Units to be manually edited
	HTTPD
	SSH (sshd)
	UFW
	Haveged
	NFS
	Samba (smbd,nmbd)
	FTP