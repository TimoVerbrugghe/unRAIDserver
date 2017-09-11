## PHP Scanner Server installation on Arch Linux
# Install needed packages
	pacman -Syu imagemagick sane usbutils tesseract zip libpaper sed grep unzip hplip

# Enable sane hpaio driver
	nano /etc/sane/dll.conf
		# Uncoomment before hpaio

# Install FPDF
	# Download tgz from http://www.fpdf.org/
	tar -zxvf fpdf181.tgz
	mkdir /usr/share/php/fpdf
	cp fpdf181/fpdf.php /usr/share/php/fpdf/fpdf.php
	cp -r fpdf181/font /usr/share/php/fpdf/font

## Install PHP-Scanner-Server	
# Clone the latest PHP-Scanner-Server to /home/fileserver/Media/Network/web
	cd /home/fileserver/Media/Network/web
	git clone https://github.com/GM-Script-Writer-62850/PHP-Scanner-Server.git
	mv PHP-Scanner-Server scanner