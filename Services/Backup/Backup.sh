## Configuration for Backup in Arch Server
# Move Backup folder to ~/Applications/Backup
# Move pushbullet.sh to ~/Applications/
# Make sure dailybackup.sh, clonezillabackup.sh & pushbullet.sh are executable
chmod +x clonezillabackup.sh
chmod +x dailybackup.sh
chmod +x pushbullet.sh

# Download the latest clonezilla release and place it in ~/Applications/Backup/Clonezilla/clonezilla.iso
# Move 40_custom to /etc/grub.d/40_custom

## Change /etc/default/grub
GRUB_DEFAULT=saved 
GRUB_TIMEOUT=3

## Generate grub configuration file
grub-mkconfig -o /boot/grub/grub.cfg
