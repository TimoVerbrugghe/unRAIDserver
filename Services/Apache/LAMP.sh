## LAMP Server installation on Arch

# Symlink /srv/http to /home/fileserver/Media/Network
	rm -rf /srv/http/
	ln -s /home/fileserver/Media/Network /srv/http

## Apache & PHP
# Install apache package
	pacman -Syu apache php php-apache nghttp2 hiredis php-gd php-intl php-apcu

# Replace httpd.conf at /etc/httpd/conf/httpd.conf
# Replace httpd-vhosts.conf at /etc/httpd/conf/extra/httpd-vhosts.conf
# Replace httpd-ssl.conf at /etc/httpd/conf/extra/httpd-ssl.conf

# Regenerate password
	htpasswd -c /etc/httpd/.htpasswd fileserver
		# Type password

# Installation of mod_auth_openidc module
	# Follow instructions at generate_auth_openidc.sh
	# Place auth_openidc.conf at /etc/httpd/conf/extra/

# Adding in PHP extensions
	# Place extensions.ini, acpu.ini & opcache.ini in /etc/php/conf.d/

# Start httpd
	systemctl enable httpd
	systemctl start httpd

# It could be that you need to recreate mod_auth_openidc when apache/php updates. Please follow instructions at mod_auth_openidc.sh to regenerate.

## Muximux install
	# Place Archserver.css in /home/fileserver/Media/Network/muximux/css/theme