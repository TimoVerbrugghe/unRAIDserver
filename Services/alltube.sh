## Installation of the alltube service & webpage
# Install npm, composer, youtube-dl, ffmpeg & rtmpdump
	pacaur -Syu npm composer youtube-dl ffmpeg rtmpdump

# Clone the develop branch of the alltube github project
	git clone -b develop https://github.com/Rudloff/alltube

# Npm & Composer installation
	cd ~/Media/Network/alltube/
	npm install & composer install

# Chmod 777 templates_c
	chmod -R 777 ~/Media/Network/alltube/templates_c/

# Place config.yml file in root folder of alltube (see ArchServerGit config folder)