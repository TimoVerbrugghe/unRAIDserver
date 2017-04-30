## Install Automatic Ripping Machine on ArchServer
# This will automatically detect when a disk is inserted, identify the disk and based on whether it is a video, audio or data CD/DVD, rip the video/audio or clone the disk to an iso.

# The scripts in the ARM folder are based on the ARM scripts found on https://github.com/ahnooie/automatic-ripping-machine
# The scripts are heavily modified to integrate pushbullet notifications, make them easier to read and stripped of features that weren't needed (such as handbrake encoding)

# Installing dependencies
	pacaur -Syu makemkv-cli at abcde lame mp3gain glyr python-pip python-pycurl python-requests python-urllib3 python-xmltodict

# Enable & start atd service
	systemctl enable atd
	systemctl start atd

# Place files at correct locations
	# Move 51-automedia.rules to /etc/udev/rules.d/
	# Move requirements.txt, abcde.conf, arm_wrapper.sh, audiorip.sh, datarip.sh, getmovietitle.py, identify.sh & videorip.sh to /home/fileserver/Applications/ARM/

# Create log & output folder
	mkdir /home/fileserver/Applications/ARM/logs
	mkdir /home/fileserver/Media/DriveRip/

# Install python dependencies
	pip3 install -r requirements.txt
