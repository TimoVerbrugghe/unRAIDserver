## Install VNC in Arch Linux
# This requires a physical monitor (or a HDMI monitor emulator - Fit-headless display)

# Install x11vnc
pacman -Syu x11vnc

# Create password file
mkdir ~/.x11vnc
x11vnc -storepasswd <password> ~/.x11vnc/passwd

# Move x11vnc.service to ~/.config/systemd/user/

# Move stopx11vnc.sh to ~/Applications/

# Add this line to ~/.config/openbox/autostart
systemctl --user start x11vnc.service