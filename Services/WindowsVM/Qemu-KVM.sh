## Qemu-KVM Installation on Arch
# Install qemu & ovmf package
	pacman -Syu qemu-headless ovmf-git

# Change grub boot options - /etc/default/grub
GRUB_CMDLINE_LINUX_DEFAULT="usbcore.autosuspend=-1 intel_iommu=on iommu=pt"

# Enable loading of virtio mdoules
	nano /etc/modules-load.d/virtio-net.conf
		# Load virtio-net.ko at boot
		virtio-net

	nano /etc/modules-load.d/virtio-scsi.conf
		# Load virtio-scsi.ko at boot
		virtio-scsi

	nano /etc/modules-load.d/virtio-blk.conf
		# Load virtio-blk.ko at boot
		virtio-blk

	nano /etc/modules-load.d/virtio-balloon.conf
		# Load virtio-balloon.ko at boot
		virtio-balloon

# Add Graphics card, USB 3.0 ports & Intel HD Audio Controller to vfio.conf
	nano /etc/modprobe.d/vfio.conf
	options vfio-pci ids=10de:1c03,10de:10f1,8086:8cb1,8086:8ca0
		# 10de:1c03 & 10de:10f1 -> Nvidia Graphics Card
		# 8086:8cb1 -> USB 3.0 ports
		# 8086:8ca0 -> Intel HD Audio Controller

# Blacklist nvidia nouveau, USB 3.0 & Intel HD Audio Controller
	nano /etc/modprobe.d/blacklist.conf
		blacklist nouveau
		blacklist xhci_pci
		blacklist xhci_hcd
		blacklist snd_hda_intel

# Change /etc/mkinitcpio.conf
	MODULES="... vfio vfio_iommu_type1 vfio_pci vfio_virqfd ..."

# Change /etc/mkinitcpio.conf
	HOOKS="... modconf ..."

# Reload mkinitcpio
	mkinitcpio -p linux

## Enabling /dev/hugepages
# Create kvm group
	groupadd kvm
	gpasswd -a fileserver kvm

# Get gid of kvm group
	getent group kvm

# Add to /etc/fstab
	hugetlbfs       /dev/hugepages  hugetlbfs       mode=1770,gid=<GIDOFKVMGROUP>        0 0

# Change HugePages to 8 gb
	nano /etc/sysctl.d/40-hugepage.conf
	vm.nr_hugepages = 4200

## Enabling networking
# Enable bridge helper
	nano /etc/qemu/bridge.conf
		allow br0

# Set up netctl bridge
	nano /etc/netctl/bridge
		Description="Bridge configuration for qemu"
		Interface=br0
		Connection=bridge
		BindsToInterfaces=(enp3s0 tap0)
		IP=static
		Address='10.124.161.101/24'
		Gateway='10.124.161.93'
		DNS=('8.8.8.8' '8.8.4.4')
		TimeoutUp=300
		TimeoutCarrier=300
		SkipForwardingDelay=yes

	nano /etc/netctl/tuntap
		Description='Tuntap connection for qemu'
		Interface=tap0
		Connection=tuntap
		Mode='tap'
		User='nobody'
		Group='nobody'
	
	netctl enable bridge
	netctl disable enp3s0

## Make sure that WindowsVM folder is in /home/fileserver/Applications
# Move windowsvm.service to /etc/systemd/system
	systemctl enable windowsvm.service

## Reboot to make changes permanent

## Change Graphics Card to accept Signal Based Interrupts
	# Go to Device Manager -> Graphics Card -> Details -> Device Instance Path
		# Note down Device Instance Path
	# Open up Register Editor (regedit.exe)
	# Go to HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Enum\PCI
		# Find Device Instance Path
	 # Go to Device Parameters
	 	# Add new Key Interrupt Management (if necessary)
	 	# Add new Key MessageSignaledInterruptProperties
	 		# Add new DWORD (32-Bit) Value MSISupported
	 		# Change value to 1

	 # Repeat same steps for PCI High Definition Audio Controller (x2 for Nvidia Audio & Realtek Audio)

	 # Check if changes were succesfully Implemented
	 	# Go to Device Manager -> View -> Resources By Type -> Interrupt Request (IRQ) -> Scroll down to PCI devices
	 	# Both Graphics card AS the PCI High Definition Audio Controller must have a NEGATIVE value between brackets

## Change Audio Settings
	# Make sure Audio Level is at 16 bit, 48000 hz for streaming purposes