## Extra security measures to install / configure after initial Arch Installation
# https://wiki.archlinux.org/index.php/Security



## Only allow certain users
	nano /etc/pam.d/su && nano /etc/pam.d/su-l
	# "Uncomment following line to require user to be in wheel group"

## Restrict root login
	passwd --lock root

## Deny root access for ssh
	# https://wiki.archlinux.org/index.php/Secure_Shell#Deny
	nano /etc/ssh/sshd_config
		PermitRootLogin no 

	# Denying root access should not only be done through the SSH daemon, but also using pam
	nano /etc/pam.d/sshd
		auth      required  pam_listfile.so      onerr=succeed item=user sense=deny file=/etc/denysshusers

	nano /etc/denysshusers
		root

	chmod 644 /etc/denysshusers		

## At this point in time, we are not going to use MAC control - skip to kernel hardening

## Kernel hardening
	# Restricting access to kernel logs
	# Restricting access to kernel pointers in the proc filesystem
	# Disable kexec

## Network & Firewalls
	# Firewall
	pacman -Syu ufw
	ufw default deny
	ufw allow to any port 22 proto tcp # to keep ssh running if you are doing this install over ssh
	ufw enable
	# Set up rules according to ufwrules

	# Kernel parameters
		# TCP / IP stack hardening

	# SSH
		# Google Authenticator