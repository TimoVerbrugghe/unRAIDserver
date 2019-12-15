## LAMP Server installation on Arch

# Symlink /srv/http to /home/fileserver/Media/Network
	rm -rf /srv/http/
	ln -s /home/fileserver/Media/Network /srv/http

## Apache & PHP
# Install apache package
	pacman -Syu apache php php-apache nghttp2 hiredis phpmyadmin php-gd php-intl php-mcrypt php-apcu

# Replace httpd.conf at /etc/httpd/conf/httpd.conf
# Replace httpd-vhosts.conf at /etc/httpd/conf/extra/httpd-vhosts.conf
# Replace httpd-ssl.conf at /etc/httpd/conf/extra/httpd-ssl.conf
# Place phpmyadmin.conf at /etc/httpd/conf/extra/phpmyadmin.conf

# Regenerate password
	htpasswd -c /etc/httpd/.htpasswd fileserver
		# Type password

# Installation of mod_auth_openidc module
	# Follow instructions at generate_auth_openidc.sh
	# Place auth_openidc.conf at /etc/httpd/conf/extra/

## MySQL - Mariadb
# Install mariadb package
	pacman -Syu mariadb

# Command to perform BEFORE starting mariadb.service
	mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql

# Enable & start mariadb
	systemctl enable mariadb.service
	systemctl start mariadb.service

# Recommended security measures
	mysql_secure_installation

# Connect php with mariadb
	# Place extensions.ini in /etc/php/conf.d/extensions.ini

# Start httpd
	systemctl enable httpd
	systemctl start httpd

# It could be that you need to recreate mod_auth_openidc when apache/php updates. Please follow instructions at mod_auth_openidc.sh to regenerate.