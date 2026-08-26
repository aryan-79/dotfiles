local colors = require("modules/colors")

hl.monitor({
	output = "eDP-1",
	mode = "1920x1080@144",
	position = "0x0",
	scale = 1,
})

hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = 1,
})

hl.config({
	input = {
		kb_layout = "us",
		kb_options = "caps:escape",
		follow_mouse = true,
		sensitivity = 0.5,

		touchpad = {
			natural_scroll = true,
		},
	},

	general = {
		border_size = 1,
		gaps_in = 2,
		gaps_out = 6,
		layout = "scrolling",
		allow_tearing = false,
		col = {
			active_border = {
				colors = {
					colors.color3,
					colors.color4,
				},
				angle = 90,
			},
		},
	},

	decoration = {
		rounding = 4,
		active_opacity = 0.9,
		inactive_opacity = 0.7,
		fullscreen_opacity = 0.9,

		blur = {
			enabled = true,
			size = 8,
			passes = 2,
		},
	},

	animations = {
		enabled = true,
	},

	dwindle = {
		preserve_split = true,
	},

	scrolling = {
		column_width = 0.8,
		focus_fit_method = 1,
	},

	misc = {
		force_default_wallpaper = 0,
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
		on_focus_under_fullscreen = 2,
	},

	xwayland = {
		force_zero_scaling = true,
	},
})
