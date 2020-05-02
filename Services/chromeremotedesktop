## Installation of Chrome Remote Desktop on Arch Linux

yay -Syu chrome-remote-desktop

## Running the CRD setup
crd --setup
	## Uncomment the exec /usr/bin/openbox-session line in the config file that will come up as part of the wizard
	## You can leave the 1366x768 resolution

## Enabling access
# Go to http://remotedesktop.google.com/headless
# Click "next" and "authorize" through each instruction
# Copy/paste and run the provided "Debian" command on the server (or through SSH)
	
	# Should look something like
	DISPLAY= /opt/google/chrome-remote-desktop/start-host --code="<UNIQUE_CODE>" --redirect-url="<https://remotedesktop.google.com/_/oauthredirect>" --name=


# Set up a name and PIN
# Wait for successful output containing "Host ready to receive connections."

## Starting CRD
crd --start

## Enabling on boot
systemctl --user enable chrome-remote-desktop
systemctl --user start chrome-remote-desktop


