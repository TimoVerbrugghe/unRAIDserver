#!/bin/bash

## This script can generate a auth_openidc.so apache module, which enables two-factor authentication with Google OpenID Connect on an Arch Linux install.
# It is HIGHLY recommended that you generate this module in a VM or Container.
# You can generate a new systemd-nspawn container with
	# pacman -Syu arch-install-scripts
	# mkdir ~/MyContainer
	# pacstrap -i -c -d ~/MyContainer base base-devel --ignore linux
		# Install Anyway? -> NO
	# systemd-nspawn -b -D ~/MyContainer
	# Login with username "root" (no password)
	# Poweroff vm with command "poweroff"

#######################################
## VARIABLES - REVIEW BEFORE INSTALL ##
#######################################
CJOSE_VERSION=0.5.1
MOD_AUTH_OPENIDC_VERSION=2.3.1

############
## SCRIPT ##
############

## PART 0: Preparing for installation - downloading extra packages
pacman --noconfirm -S gcc openssl curl apache jansson pkg-config hiredis automake autoconf make check

## PART 1: Installing CJose
# Initializing variables
CJOSE_TGZ=cjose-$CJOSE_VERSION.tar.gz

# Download & Unpack CJose
echo "Downloading CJose"
cd /root/
curl -o $CJOSE_TGZ https://mod-auth-openidc.org/download/$CJOSE_TGZ

echo "Unpacking CJose"
tar zxvf $CJOSE_TGZ

# Build CJose
echo "Building CJose"
cd /root/cjose-$CJOSE_VERSION
./configure
make
make test
make install

echo "Done installing CJose - Now going to create module"

## Part 2: Creating mod_auth_openidc.so module
# Initializing variables
MOD_AUTH_OPENIDC_TGZ=mod_auth_openidc-$MOD_AUTH_OPENIDC_VERSION.tar.gz

# Download & unpack mod_auth_openidc
echo "Unpacking mod_auth_openidc"
cd /root/
curl -o $MOD_AUTH_OPENIDC_TGZ https://mod-auth-openidc.org/download/$MOD_AUTH_OPENIDC_TGZ
tar zxvf $MOD_AUTH_OPENIDC_TGZ

# Build module
echo "Building mod_auth_openidc"
cd /root/mod_auth_openidc-$MOD_AUTH_OPENIDC_VERSION
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig
./autogen.sh
./configure --with-prefix=/usr/local
make
make test

# Copying created module & other dependencies to other folder
mkdir /files
cp /root/mod_auth_openidc-$MOD_AUTH_OPENIDC_VERSION/src/.libs/mod_auth_openidc.so /files
cp /usr/local/lib/* /files

echo "######################### END OF SCRIPT ################################################"
echo "This script is now done. You will find all necessary files in /files."
echo "Please put mod_auth_openidc.so in /etc/httpd/modules & all other files in /usr/local/lib"
echo "########################################################################################"
