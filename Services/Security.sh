## Extra security measures to install / configure after initial Arch Installation
# https://wiki.archlinux.org/index.php/Security

## Deny user login access after 5 failed login attempts
	nano /etc/pam.d/system-login
	# Comment out first auth required tally.so line
	auth required pam_tally.so deny=5 unlock_time=600 onerr=succeed file=/var/log/faillog

## Only allow certain users
	nano /etc/pam.d/su && nano /etc/pam.d/su-l
	# "Uncomment following line to require user to be in wheel group"

## Restrict root login
	passwd -l root

## Deny root access for ssh
	# https://wiki.archlinux.org/index.php/Secure_Shell#Deny
	nano /etc/ssh/sshd_config
	PermitRootLogin no 

## At this point in time, we are not going to use MAC control - skip to kernel hardening

## Kernel hardening
	# Restricting access to kernel logs
	# Restricting access to kernel pointers in the proc filesystem
	# hidepid

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
		# Install Fail2ban
			# https://wiki.archlinux.org/index.php/Fail2ban
			# Capabilities
			# SSH jail (in a seperated /etc/fail2ban/jail.d/ssh-iptables.conf)
		
		# Google Authenticator

## Physical security
	# Denying console login as root

## (Optional) Grsecurity