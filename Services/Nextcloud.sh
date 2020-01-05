## Nextcloud installation on Arch Linux
# Download & unpack nextcloud tar
	cd /home/fileserver/Media/Network/nextcloud
	wget <get latest url on the nextcloud website>
	unzip nextcloud-*.zip

# Apcu & OPcache
	# Place apcu.ini & opcache.ini in /etc/php/conf.d/

## Install MySQL
# Install mariadb package
	pacman -Syu mariadb

# Command to perform BEFORE starting mariadb.service
	mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql

# Enable & start mariadb
	systemctl enable mariadb.service
	systemctl start mariadb.service

# Recommended security measures
	mysql_secure_installation

## Setup nextcloud database
	mysql -u root -p

	CREATE DATABASE IF NOT EXISTS nextcloud;
	CREATE USER ‘fileserver’@’localhost’ IDENTIFIED BY '<password>';
	GRANT ALL PRIVILEGES ON nextcloud.* TO 'fileserver'@'localhost' IDENTIFIED BY '<password>';
	quit

## Go to localhost/nextcloud for setup
	## If you get php version error, then modify /home/fileserver/Media/Network/nextcloud/lib/versioncheck.php

## After setup, add this line to /home/fileserver/Media/Network/web/nextcloud/config/config.php
	'memcache.local' => '\OC\Memcache\APCu',
