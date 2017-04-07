#!/bin/sh
#This script shuts down the x11vnc server started using systemd (unit file in /home/fileserver/.config/systemd/user/)
#This script sends the x11vnc stop command using the remote (-R) option

/usr/bin/x11vnc -R stop -display :0 &&
echo "Shutdown command sent. Waiting for 20 seconds for x11vnc to shutdown the server on display :0." &&

sleep 20

echo "Killing the x11vnc process" &&
pkill x11vnc &&
exit 0