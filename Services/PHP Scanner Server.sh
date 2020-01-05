## PHP Scanner Server installation on Arch Linux
# Install needed packages
	pacman -Syu imagemagick sane usbutils tesseract zip libpaper sed grep unzip hplip

# Install FPDF
	# Download tgz from http://www.fpdf.org/
	mkdir /usr/share/php/fpdf
	cd /usr/share/php/fpdf
	unzip fpdf*.zip

## Install PHP-Scanner-Server	
# Clone the latest PHP-Scanner-Server to /home/fileserver/Media/Network/web
	cd /home/fileserver/Media/Network
	git clone https://github.com/GM-Script-Writer-62850/PHP-Scanner-Server.git
	mv PHP-Scanner-Server scanner