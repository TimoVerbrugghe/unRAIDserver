## Qemu-KVM Installation on Arch
# Install qemu & ovmf package
	pacman -Syu qemu-headless ovmf dtc libvirt

# Create folder & OVMF (UEFI) vars file
	mkdir /home/fileserver/Application/WindowsVM/
	cp /usr/share/ovmf/x64/OVMF_VARS.fd /home/fileserver/Applications/WindowsVM/ovmf_windowsvm_vars.fd
	chown fileserver:fileserver /home/fileserver/Applications/WindowsVM/ovmf_windowsvm_vars.fd

# Place 60-ovmf-x86_64.json in /etc/qemu/firmware for correct recognition of the ovmf uefi firmware

# Change grub boot options - /etc/default/grub
# Enables iommu, ignores MSRS for avoiding blue screen, enables 64 bit timer for HPET and allows unsafe interrupts
# Grabs the PCI ids from NVIDIA graphics card and applies driver vfio-pci to it
GRUB_CMDLINE_LINUX_DEFAULT="... amd_iommu=on iommu=pt kvm.ignore_msrs=1 hpet64 vfio_iommu_type1.allow_unsafe_interrupts=1 vfio-pci.ids=10de:1c03,10de:10f1 ..."

# Change grub boot options to isolate cpus from the linux scheduler by using isolcpus
GRUB_CMDLINE_LINUX_DEFAULT="... isolcpus=3-5,9-11 nohz_full=3-5,9-11 rcu_nocbs=3-5,9-11 ..."

# Enable loading of virtio mdoules
	nano /etc/modules-load.d/virtio-net.conf
		# Load virtio-net.ko at boot
		virtio-net

	nano /etc/modules-load.d/virtio-scsi.conf
		# Load virtio-scsi.ko at boot
		virtio-scsi

# Change /etc/mkinitcpio.conf
	MODULES="... vfio vfio_iommu_type1 vfio_pci vfio_virqfd ..."

# Change /etc/mkinitcpio.conf
	HOOKS="... modconf ..."

# Reload mkinitcpio
	mkinitcpio -p linux

## Enabling /dev/hugepages
# Enable hugepages in libvirt
	nano /etc/default/qemu-kvm
		KVM_HUGEPAGES=1

# Create kvm group
	groupadd kvm
	gpasswd -a fileserver kvm

# Get gid of kvm group
	getent group kvm

# Add to /etc/fstab
	hugetlbfs       /dev/hugepages  hugetlbfs       mode=1770,gid=<GIDOFKVMGROUP>        0 0

# Change HugePages to 16 gb (8192 * 2048kb)
	nano /etc/sysctl.d/40-hugepage.conf
	vm.nr_hugepages = 8192

## Enabling networking
# Enable bridge helper
	nano /etc/qemu/bridge.conf
		allow br0

# Set up netctl bridge
	nano /etc/netctl/bridge

		Description="Bridge configuration for vm"
		Interface=br0
		Connection=bridge
		BindsToInterfaces=(eno1)

		## IPv4 configuration
		IP=static
		Address='192.168.0.3/24'
		Gateway='192.168.0.1'

		## IPv6 configuration
		IP6=static
		Address6='2a02:1810:4f2b:7900::0003/64'
		Gateway6='fe80::1'

		## General configuration
		DNS=('8.8.8.8' '8.8.4.4' '2001:4860:4860::8888' '2001:4860:4860::8844')
		TimeoutUp=300
		TimeoutCarrier=300
		SkipForwardingDelay=yes

	# default Wired profile now needs to be deleted
	netctl disable wired
	rm -rf /etc/netctl/wired

	netctl enable bridge
	netctl disable eno1

	netctl start bridge

# Enable fileserver to be added to the libvirt group
	sudo usermod -a -G libvirt fileserver

# Autostart & autoshutdown
	# change shutdown option in /etc/conf.d/libvirt-guests
		ON_SHUTDOWN=shutdown
		ON_BOOT=ignore
		SHUTDOWN_TIMEOUT=150

# Enabling services & vm
	systemctl enable libvirtd libvirt-guests
	systemctl start libvirtd virtlogd libvirt-guests

	virsh define /home/fileserver/Applications/WindowsVM/windowsvm.xml
	virsh autostart windowsvm
	virsh start windowsvm

## Reboot to make changes permanent

## POSSIBLE -> When first booting into windows, EFI shell needs the windows efi file added as a boot option
	# Type "exit" in the efi shell
	# Press escape key to get into OVMF bios
	# In the bios, go to Boot Maintenance Manager
	# Boot options -> Add boot option -> Select hard drive (No volume label) -> <EFI> -> <Microsoft> -> <Boot> -> bootmgfw.efi 
	# Input any description
	# Commit changes

	# Change boot order
	# Put your newly added boot order as first one -> F10 Save
	# Exit bios (continue/reset options)

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

## Enabling remote moonlight streaming
	# Assign a static IP(v4 & v6) to the Windows VM
	# Open the required moonlight streaming ports, more information at their Github -> https://github.com/moonlight-stream/moonlight-docs/wiki/Setup-Guide#streaming-over-the-internet

## Nvidia Control Panel Update
	# Nvidia control panel 
	# Open “3D settings” branch -> Select “Manage 3D settings” -> Select “Global settings” tab
	# set “Power Management mode” -> “Prefer maximum performance”
	# set “Low Latency Mode” -> “On
