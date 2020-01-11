## First things to do after installation
# This guide will reference other files in the ArchServer Installation folder

# Enable SSH & Haveged
	systemctl enable sshd
	systemctl enable haveged

## General Recommendations
# https://wiki.archlinux.org/index.php/General_recommendations
# Users & Groups
	useradd -m -G wheel -s /bin/bash fileserver
	EDITOR=nano visudo
		fileserver ALL=(ALL) ALL

##############################################
## Go to the 'Security' file & follow steps ##
##############################################

## Package Management

## Mirrors
	# Install reflector
	# https://wiki.archlinux.org/index.php/Reflector

	# Create pacman hook

[Trigger]
Operation = Upgrade
Type = Package
Target = pacman-mirrorlist

[Action]
Description = Updating pacman-mirrorlist with reflector and removing pacnew...
When = PostTransaction
Depends = reflector
Exec = /usr/bin/env sh -c "reflector --protocol https --latest 20 --sort rate --save /etc/pacman.d/mirrorlist; if [[ -f /etc/pacman.d/mirrorlist.pacnew ]]; then rm /etc/pacman.d/mirrorlist.pacnew; fi"


	# Create systemd service & weekly systemd timer
		# Move reflector.service & reflector.timer to /etc/systemd/system/

## AUR
	# Change makepkg for performance & general cleanup. For this, we are going to create an additional makepkg.conf file

	mkdir .build/packages
	sudo nano /home/fileserver/.makepkg.conf

	PACKAGER="Timo Verbrugghe <timo@hotmail.be>"
	MAKEFLAGS="-j$(nproc)"
	BUILDDIR=/tmp/makepkg
	PKGDEST=~/.build/packages/ 
	BUILDENV=(!distcc color ccache check !sign)
	COMPRESSXZ=(xz -c -z - --threads=0)

	# Install yay
		git clone https://aur.archlinux.org/yay.git
		cd yay
		makepkg -si

## Networking
	# Synchronize time
	timedatectl set-timezone Europe/Brussels

## System Service
	# File Index & Search

## Console Improvements
	# Bash Additions - Bash Tips & Tricks
		# Command not found (first install pkgfile!)
		pacman -Syu pkgfile
		pkgfile --update
		
		# Search for commands in non-installed packages if command not found
		source /usr/share/doc/pkgfile/command-not-found.bash

	# Console prompt - Console Bach prompt
		# Add neofetch prompt
		# Install neofetch & move config file from config folder to /home/fileserver/Applications/neofetch/config
		yay -Syu neofetch
		nano ~/.bashrc
			if [ -f /usr/bin/neofetch ]; then neofetch --config /home/fileserver/Applications/neofetch/config; fi

## Autologin
systemctl edit getty@tty1

	[Service]
	ExecStart=
	ExecStart=-/usr/bin/agetty --autologin fileserver --noclear %I $TERM

## Performance
	# Change cpupower default settings -> governor to performance
	nano /etc/default/cpupower
		governor='performance'

	systemctl enable cpupower

	# You can measure current cpu frequency with below command
		watch grep \"cpu MHz\" /proc/cpuinfo

	## Turn off CPU mitigations - don't do this on critical systems
	nano /etc/default/grub
		mitigations=off

	## Reduce swappiness
	nano /etc/sysctl.d/99-swappiness.conf
		vm.swappiness=10

	## Increase network performance
	nano /etc/sysctl.d/99-sizereceivequeue.conf
		net.core.netdev_max_backlog = 100000
		net.core.netdev_budget = 50000
		net.core.netdev_budget_usecs = 5000

	nano /etc/sysctl.d/99-increasemaxconnections.conf
		net.core.somaxconn = 1024

	nano /etc/sysctl.d/99-increasememorynetinterface.conf
		net.core.rmem_default = 1048576
		net.core.rmem_max = 16777216
		net.core.wmem_default = 1048576
		net.core.wmem_max = 16777216
		net.core.optmem_max = 65536
		net.ipv4.tcp_rmem = 4096 1048576 2097152
		net.ipv4.tcp_wmem = 4096 65536 16777216
		net.ipv4.udp_rmem_min = 8192
		net.ipv4.udp_wmem_min = 8192

	nano /etc/sysctl.d/99-tcpfastopen.conf
		net.ipv4.tcp_fastopen = 3

	nano /etc/sysctl.d/99-bbr.conf
		net.core.default_qdisc = fq
		net.ipv4.tcp_congestion_control = bbr
