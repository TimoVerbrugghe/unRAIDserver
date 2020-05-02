## Arch - Window Manager & Openbox installation
	# Install openbox & Xinit (to start openbox)
	pacman -Syu openbox xorg-server xorg-xinit obconf lxappearance-obconf lxinput lxterminal pcmanfm tint2 chromium

		# for AMD graphics cards, install following packages as well, see https://wiki.archlinux.org/index.php/Hardware_video_acceleration#ATI/AMD
		pacman -Syu xf86-video-ati mesa mesa-libgl libva-mesa-driver

		# for nvidia graphics cards, install following packages as well
		pacman -Syu mesa xf86-video-nouveau

	cp /etc/X11/xinit/xinitrc ~/.xinitrc
	nano ~/.xinitrc
		exec openbox-session
		# commnent all lines starting from twm &

	nano ~/.bash_profile
		[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx
	cp -R /etc/xdg/openbox ~/.config/

## Change openbox menu

## Change openstart file
	nano ~/.config/openbox/autostart
		pcmanfm --desktop &
		tint2 &
		setxkbmap be &

## Change tint2 settings
	# Panel -> Horizontal Padding -> 10
	# Taskbar -> Show Desktop Name -> Off
	# Laucnher -> Set icon order

## Change Pcmanfm Wallpaper
	# Use wallpaper.png in ArchServer Instlalation folder

## Change Xterm settings
	nano ~/.Xdefaults
		XTerm*foreground: green
		XTerm*background: black