## Installation guide for Bazarr on Arch
# Install python2 & python2-pip
	yay -Syu python2 python2-pip

# Create folders & Git clone the bazarr github project
	mkdir ~/Applications/bazarr
	cd ~/Applications/bazarr

	# dot after clone command makes sure that git is cloned in current directory and that git clone does not create a new one
	git clone https://github.com/morpheus65535/bazarr.git .

# Install python requirements
	python2 -m pip install -r requirements.txt

# Move bazarr systemd file to /etc/systemd/system/
# Enable & start systemd service
	systemctl enable bazarr.service
	systemctl start bazarr.service

# Go to default port (6767) & start configuration