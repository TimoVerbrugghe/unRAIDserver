## Install guide for NZBget on Arch
# Install nzbget, unrar, p7zip package
	pacman -Syu nzbget unrar p7zip

# Place config file in  ~/Applications/nzbget/nzbget.conf
	cp /usr/share/nzbget/nzbget.conf ~/Applications/nzbget/nzbget.conf

# Change following variables in nzbget.conf
	MainDir=/home/fileserver/Applications/nzbget
	ScriptDir=${WebDir}/scripts
	DaemonUsername=fileserver

# Fix permissions
	chown -R fileserver:fileserver ~/Applications/nzbget
	chmod -R 755 ~/Applications/nzbget

# Place systemd file in /etc/systemd/system & enable it
	systemctl enable nzbget.service
	systemctl start nzbget.service

# Go to port 6789 (default port for nzbget) & start configuration
# Default nzbget username & password
# Start the program and change settings
	Paths
		DestDir /home/fileserver/Media/Downloads/complete
		InterDir /home/fileserver/Media/Downloads/incomplete
		LogFile	${MainDir}/nzbget.log
	Security
		Username <empty>
		Password <empty>
		ControlIP 127.0.0.1
		Controlport 8080
		Securecontrol OFF
	Categories
		radarr
			DestDir /home/fileserver/Media/Downloads/complete/movies
			Unpack YES
		sonarr
			DestDir /home/fileserver/Media/Downloads/complete/tvshows
			Unpack YES
	Par Check/Repair
		Parcheck	Auto
		ParRename	Yes
		ParRepair	YES
		ParScan		Extended
		ParQuick	Yes
	Unpack
		Unpack		Yes
		UnpackPauseQueue	No
		UnpackCleanupDisk	Yes