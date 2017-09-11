## HackintoshVM Installation on ArchServer
# If WindowsVM has not been installed yet, follow instructions in Qemu-Kvm.sh (Services/WindowsVM) first to set up qemu-kvm & bridged networking

## Set up new bridge for Qemu VM
nano /etc/netctl/tuntap2
		Description='Tuntap connection for qemu - HackintoshVM'
		Interface=tap1
		Connection=tuntap
		Mode='tap'
		User='nobody'
		Group='nobody'

nano /etc/netctl/bridge
	BindsToInterfaces=(enp3s0 tap0 tap1 tap2)

netctl enable tuntap2
netctl start tuntap2

## Set up new HackintoshVM
	# Move qemuargshackintosh to ~/Applications/hackintosh/
	# Move hackintosh.service to /etc/systemd/system/hackintosh.service
	systemctl enable hackintosh.service