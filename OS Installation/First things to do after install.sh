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
	sudo nano ~/.makepkg.conf

	PACKAGER="Timo Verbrugghe <timo@hotmail.be>"
	MAKEFLAGS="-j$(nproc)"
	BUILDDIR=/tmp/makepkg
	PKGDEST=~/.build/packages/ 
	BUILDENV=(!distcc color ccache check !sign)
	COMPRESSXZ=(xz -c -z - --threads=0)

	# Install cower, then pacaur
	# Before installing cower
	gpg --recv-keys --keyserver hkp://pgp.mit.edu 1EB2638FF56C0C53

	# Download snapshot of cower from https://aur.archlinux.org/packages/cower/
	cd ~/.build/
	curl -L -O https://aur.archlinux.org/cgit/aur.git/snapshot/cower.tar.gz
	tar -xvf cower.tar.gz
	cd cower
	makepkg -sri

	# Download snapshot of pacaur
	cd ~/.build/
	curl -L -O https://aur.archlinux.org/cgit/aur.git/snapshot/pacaur.tar.gz
	tar -xvf pacaur.tar.gz
	cd pacaur
	makepkg -sri

## Booting
	# Num Lock activation

## Multimedia
	# (Optional) Unmute sound
	amixer sset Master unmute

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
		# Terminfo escape sequences
		
		# Change escape sequence to color green & give a custom message
		GREEN="\[$(tput setaf 2)\]"
		RESET="\[$(tput sgr0)\]"

		export PS1="${GREEN}\\u@\h \\W${RESET}> "

		# Add neofetch prompt
		# Install neofetch & move config file from config folder to /etc/neofetch
		pacaur -Syu neofetch
		if [ -f /usr/bin/neofetch ]; then neofetch; fi

## Autologin
systemctl edit getty@tty1

[Service]
ExecStart=
ExecStart=-/usr/bin/agetty --autologin fileserver --noclear %I $TERM