## noVNC installation in Arch Linux - HTML5 VNC viewer

# Clone noVNC github repo - https://github.com/novnc/noVNC
git clone https://github.com/novnc/noVNC.git
mv noVNC /home/fileserver/Media/Network/vnc

# Launch noVNC once to download websockify
/home/fileserver/Media/Network/vnc/utils/launch.sh --vnc localhost:5900

# Move novnc.service systemd file to /etc/systemd/system
systemctl enable novnc.service
systemctl start novnc.service

# You can now go to www.timo.be/vnc and connect to VNC through the browser