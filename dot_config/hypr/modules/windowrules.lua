hl.window_rule({
	match = {
		class = "blueberry.py",
	},
	float = true,
})

hl.window_rule({
	match = {
		class = "org.pulseaudio.pavucontrol",
	},
	float = true,
	size = { 800, 700 },
})

-- hl.window_rule({
-- 	match = {
-- 		class = "zen",
-- 		initial_title = "^File Upload.*",
-- 	},
-- 	float = true,
-- 	size = { "(monitor_w*0.5)", "(monitor_h*0.5)" },
-- })

local fullscreens = { "zen", "Brave-browser", "com.mitchellh.ghostty", "libreoffice-startcenter", "Vivaldi-stable" }

for _, class in ipairs(fullscreens) do
	hl.window_rule({
		match = {
			class = class,
			title = "negative:^Picture-in-Picture$",
		},
		fullscreen = true,
	})
end

hl.window_rule({
	match = {
		initial_title = "Picture-in-Picture",
	},
	float = true,
	move = { "monitor_w - 720", "monitor_h - 395" },
	suppress_event = "fullscreen",
	size = { 713, 393 },
})

hl.layer_rule({ match = { namespace = "waybar" }, blur = true })
