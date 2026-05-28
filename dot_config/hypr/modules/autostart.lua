hl.on("hyprland.start", function()
	hl.exec_cmd("swaync & waybar & hyprpaper & hypridle")
	hl.exec_cmd("systemctl --user start hyprpolkitagent")
	hl.exec_cmd("/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh")
	-- hl.exec_cmd("xwaylandvideobridge")

	-- elephant and walker
	hl.exec_cmd("elephant service enable")
	hl.exec_cmd("systemctl --user start elephant")
	hl.exec_cmd("systemctl --user start service")

	-- GTK themes
	hl.exec_cmd("gsettings set org.gnome.desktop.interface gtk-theme Tokyonight-Dark") -- for GTK3 apps
	hl.exec_cmd("gsettings set org.gnome.desktop.interface color-scheme prefer-dark") -- for GTK4 apps
	hl.exec_cmd("gsettings set org.gnome.nautilus.preferences click-policy single")

	hl.exec_cmd("wl-paste --type text --watch cliphist store") -- Stores only text data
	hl.exec_cmd("wl-paste --type image --watch cliphist store") -- Stores only image data
end)
