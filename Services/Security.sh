## Extra security measures to install / configure after initial Arch Installation
# https://wiki.archlinux.org/index.php/Security

## Deny user login access after 5 failed login attempts
	nano /etc/pam.d/system-login
		# Comment out first auth required tally.so line & add following lines to the auth/account section
		auth required pam_env.so
		auth required pam_tally.so deny=6 unlock_time=600 onerr=succeed file=/var/log/faillog
		account required pam_tally.so

## Only allow certain users
	nano /etc/pam.d/su && nano /etc/pam.d/su-l
	# "Uncomment following line to require user to be in wheel group"

## Restrict root login
	passwd -l root

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
				nano /etc/systemd/system/fail2ban.service.d/capabilities.conf
					[Service]
					CapabilityBoundingSet=CAP_DAC_READ_SEARCH CAP_NET_ADMIN CAP_NET_RAW

			# Paths
				cp /etc/fail2ban/paths-fedora.conf /etc/fail2ban/paths-archlinux.conf
				nano /etc/fail2ban/jail.d/paths.conf
					[INCLUDES]
					before = paths-archlinux.conf

			# SSH jail (in a separated /etc/fail2ban/jail.d/ssh-iptables.conf)
				nano /etc/fail2ban/jail.d/ssh-iptables.conf
					[DEFAULT]
					bantime = 864000
					ignoreip = 127.0.0.1/8 192.168.0.0/24

					[sshd]
					enabled  = true
					filter   = sshd
					action   = iptables[name=SSH, port=ssh, protocol=tcp]
					backend  = systemd
					maxretry = 5
		
		systemctl enable fail2ban
		systemctl start fail2ban

		# Google Authenticator
		# Install sshguard -> https://wiki.archlinux.org/index.php/sshguard
			# UFW
			# Systemd

## Physical security
	# Denying console login as root