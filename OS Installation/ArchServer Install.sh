#################################
## Arch installation on Server ##
#################################

##################
## Installation ##
##################

## Instructions to set up ArchServer based on the Installation Guide found on Archwiki

## If additional steps need to be taken outside of the wiki installation guide, the title of the step will be in comments, followed by the additional steps/commands

##  (Optional) Wireless Installation
# If installation needs to be done wirelessly, first check if the wireless card is loaded (firmware/etc...) through lspci -k & dmesg | grep firmware
# If wireless card is loaded -> search for wireless networks through wifi-menu -o & go through the steps
# netctl start <profile name given during wifi-menu>

## Format the partitions
# EFI -> FAT32 (mkfs.fat -F32 /dev/sdxY)
# Boot partition -> ext4
# After partition formatting, enable swap on the swap partition
mkswap /dev/sda3
swapon /dev/sda3

## Install the base packages
# Install these additional packages
pacstrap /mnt base base-devel btrfs-progs openssh rsync wget curl ufw smartmontools sudo ntfs-3g ttf-dejavu haveged ccache libcdio libdvdread libdvdcss libdvdnav pacman-contrib irqbalance

# Install either intel-ucode or amd-ucode for microcode support

## Fstab
# After generating fstab, be sure to change to current fstab with right mounting options.

## Timezone
# Set timezone with the following command
ln -sf /usr/share/zoneinfo/Europe/Brussels /etc/localtime
timedatectl set-ntp true

## Network Configuration
# Use netctl to assign a static IP Address
# https://wiki.archlinux.org/index.php/Netctl#Wired

# Get current interface name
ip addr

# /etc/netctl/wired
	Interface= <interfacename>
	Connection=ethernet
	IP=static
	Address='192.168.0.3/24'
	Gateway='192.168.0.1'
	IP6=static
	Address6='2a02:1810:4f2b:7900::0003/64'
	Gateway6='fe80::1'
	# Using IPv4 & IPv6 Google DNS servers
	DNS=('8.8.8.8' '8.8.4.4' '2001:4860:4860::8888' '2001:4860:4860::8844')
	TimeoutUp=300
	TimeoutCarrier=300

netctl enable staticIPwired
systemctl enable netctl-wait-online.service

## Bootloader installation
# Make sure all partitions are mounted to the correct folders!
# Mount /boot/ first before mounting /boot/efi !
arch-chroot /mnt /bin/bash
pacman -Syu grub efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=arch-grub --boot-directory=/boot --debug
grub-mkconfig -o /boot/grub/grub.cfg

	## UEFI - Troubleshooting
		# Make sure all other UEFI boot options (from previous installs) are erased using efibootmgr
		# It could be that the bootloader has to have bootx64.efi in the esp/EFI/boot/ folder. If so, copy /mnt/boot/efi/EFI/arch/grubx64.efi to /mnt/boot/efi/EFI/boot/bootx64.efi