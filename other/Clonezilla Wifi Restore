## Clonezilla restore over wifi

# 1. Identify name of device
ip addr # check for name of wifi device

# 2. Set up ssid & password
# Place wpa.conf in /home/user/wpa.conf
wpa_passphrase <SSIDNAME> <SSIDPASSWORD> > wpa.conf

# 3. Activate Device
ifconfig <DEVICENAME> up

# 4. Connect to Wifi
# -D option selects driver, -i option device, -c option configuration, -B background
wpa_supplicant -D wext -i wlan0 -c /home/user/wpa.conf -B

# 5. Get IP (through DHCP)
dhclient wlan0
