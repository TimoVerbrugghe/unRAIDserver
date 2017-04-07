## Jackett installtion on Arch Linux
# Install the latest realease from Jackett in ~/Applications/jackett (from https://github.com/Jackett/Jackett)

# Move systemd service to /etc/systemd/system/jackett.service
	systemctl enable jackett-public.service
	systemctl start jackett-public.service

# Go to port 9117 on Jackket
# Add all public trackers (see Github for latest list) & change port to 8088, "Base Path Override" to /jackett for apache proxy forwarding