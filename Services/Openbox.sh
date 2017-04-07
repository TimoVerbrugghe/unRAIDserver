## Arch - Window Manager & Openbox installation
	# Install openbox & Xinit (to start openbox)
	pacman -Syu openbox xorg-server xorg-xinit xf86-video-intel mesa-libgl libva-intel-driver obconf lxappearance-obconf lxinput lxterminal pcmanfm tint2 numix-themes chromium
	cp /etc/X11/xinit/xinitrc ~/.xinitrc
	nano ~/.xinitrc
		exec openbox-session
		# commnent all lines starting from twm &

	nano ~/.bash_profile
		[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx
	cp -R /etc/xdg/openbox ~/.config/

## Change openbox menu
	# replace ~/.config/openbox/menu.xml with menu.xml in ArchServer Installation

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