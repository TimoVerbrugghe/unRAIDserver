## Nextcloud installation on Arch Linux
# Download & unpack nextcloud tar
	cd /home/fileserver/Media/Network/nextcloud
	wget https://download.nextcloud.com/server/releases/nextcloud-10.0.1.tar.bz2
	bzip2 -d nextcloud-10.0.1.tar.bz2
	tar -xvf nextcloud-10.0.1.tar

# Apcu & OPcache
	# Place apcu.ini & opcache.ini in /etc/php/conf.d/

## Setup nextcloud database
	mysql -u root -p

	CREATE DATABASE IF NOT EXISTS nextcloud;
	CREATE USER ‘fileserver’@’localhost’ IDENTIFIED BY '<password>';
	GRANT ALL PRIVILEGES ON nextcloud.* TO 'fileserver'@'localhost' IDENTIFIED BY '<password>';
	quit

## Go to localhost/nextcloud for setup

## After setup, add this line to /home/fileserver/Media/Network/web/nextcloud/config/config.php
	'memcache.local' => '\OC\Memcache\APCu',
