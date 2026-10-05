local super = "SUPER"
local alt = "ALT"
local super_shift = "SUPER+SHIFT"
local alt_shift = "ALT+SHIFT"

local terminal = "ghostty"
local browser = "zen-browser"
local file_manager = "nautilus"
local bluetooth_controller = "blueberry"
local audio_controller = "pavucontrol"

local function build_prefix(prefix, keys)
	return prefix .. "+" .. table.concat(keys, "+")
end

local function layout_bind(bind_table)
	return function()
		local workspace = hl.get_active_special_workspace() or hl.get_active_workspace()

		if not workspace then
			return
		end

		local layout = workspace.tiled_layout
		if bind_table[layout] then
			hl.dispatch(bind_table[layout])
		end
	end
end

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	hl.bind(build_prefix(super, { key }), hl.dsp.focus({ workspace = i }))
	hl.bind(build_prefix(super_shift, { key }), hl.dsp.window.move({ workspace = i }))
end

hl.bind(build_prefix(super, { "T" }), hl.dsp.exec_cmd(terminal))
hl.bind(build_prefix(super, { "B" }), hl.dsp.exec_cmd(browser))
hl.bind(build_prefix(super, { "E" }), hl.dsp.exec_cmd(file_manager))
hl.bind(build_prefix(super, { "Q" }), hl.dsp.window.close())
hl.bind(build_prefix(super, { "F" }), hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
hl.bind(build_prefix(super, { "Y" }), hl.dsp.window.float())
hl.bind(build_prefix(super, { "V" }), hl.dsp.exec_cmd("walker -m clipboard"))
-- hl.bind(build_prefix(super, { "N" }), hl.dsp.exec_cmd("swaync-client -t -sw"))

local direction_bind = {
	{ key = "H", direction = "l" },
	{ key = "L", direction = "r" },
	{ key = "J", direction = "d" },
	{ key = "K", direction = "u" },
}

for _, e in ipairs(direction_bind) do
	hl.bind(
		build_prefix(super, { e.key }),
		layout_bind({
			scrolling = hl.dsp.layout("focus " .. e.direction),
			dwindle = hl.dsp.focus({ direction = e.direction }),
			master = hl.dsp.focus({ direction = e.direction }),
		})
	)

	hl.bind(build_prefix(super_shift, { e.key }), hl.dsp.window.swap({ direction = e.direction }))
end

hl.bind(
	build_prefix(super, { "CTRL", "H" }),
	layout_bind({
		scrolling = hl.dsp.layout("colresize -0.25"),
		dwindle = hl.dsp.window.resize({ x = -30, y = 0 }),
		master = hl.dsp.window.resize({ x = -30, y = 0 }),
	})
)

hl.bind(
	build_prefix(super, { "CTRL", "L" }),
	layout_bind({
		scrolling = hl.dsp.layout("colresize +0.25"),
		dwindle = hl.dsp.window.resize({ x = 30, y = 0 }),
		master = hl.dsp.window.resize({ x = 30, y = 0 }),
	})
)

hl.bind(
	build_prefix(super, { "CTRL", "LEFT" }),
	layout_bind({
		scrolling = hl.dsp.layout("colresize -0.25"),
		dwindle = hl.dsp.window.resize({ x = -30, y = 0 }),
		master = hl.dsp.window.resize({ x = -30, y = 0 }),
	})
)

hl.bind(
	build_prefix(super, { "CTRL", "RIGHT" }),
	layout_bind({
		scrolling = hl.dsp.layout("colresize +0.25"),
		dwindle = hl.dsp.window.resize({ x = 30, y = 0 }),
		master = hl.dsp.window.resize({ x = 30, y = 0 }),
	})
)

hl.bind(
	build_prefix(super, { "CTRL", "DOWN" }),
	layout_bind({
		scrolling = hl.dsp.layout("colresize -0.25"),
		dwindle = hl.dsp.window.resize({ x = 0, y = 30 }),
		master = hl.dsp.window.resize({ x = 0, y = 30 }),
	})
)
hl.bind(
	build_prefix(super, { "CTRL", "UP" }),
	layout_bind({
		scrolling = hl.dsp.layout("colresize +0.25"),
		dwindle = hl.dsp.window.resize({ x = 0, y = -30 }),
		master = hl.dsp.window.resize({ x = 0, y = -30 }),
	})
)

local function equalize_cols()
	return function()
		local workspace = hl.get_active_special_workspace() or hl.get_active_workspace()
		local windows = hl.get_windows({ workspace })

		for _, w in ipairs(windows) do
			if w.fullscreen == 2 then
				hl.dispatch(hl.dsp.window.fullscreen({ window = w, mode = "fullscreen", action = "unset" }))
			end
		end

		hl.dispatch(hl.dsp.layout("colresize all 0.5"))
	end
end

hl.bind(
	build_prefix(super_shift, { "V" }),
	layout_bind({
		scrolling = hl.dispatch(equalize_cols),
	})
)

hl.bind(
	build_prefix(super_shift, { "F" }),
	layout_bind({
		scrolling = hl.dsp.layout("fit active"),
	})
)

hl.bind(build_prefix(super, { "D" }), function()
	hl.dispatch(hl.dsp.exec_cmd('notify-send -a "Hyprland" "Special workspace toggled"'))
	hl.dispatch(hl.dsp.workspace.toggle_special("magic"))
end)
hl.bind(build_prefix(super, { "SPACE" }), hl.dsp.exec_cmd("walker"))
hl.bind(build_prefix(super, { "PERIOD" }), hl.dsp.exec_cmd("walker -m symbols"))
hl.bind(build_prefix(super, { "PRINT" }), hl.dsp.exec_cmd("hyprshot -m output -o $HOME/Pictures/screenshots"))
hl.bind(build_prefix(super, { "TAB" }), hl.dsp.focus({ workspace = "+1" }))

hl.bind(build_prefix(super_shift, { "S" }), hl.dsp.exec_cmd("hyprshot -s -m region output --clipboard-only"))
hl.bind(build_prefix(super_shift, { "C" }), hl.dsp.exec_cmd("hyprpicker -a -f hex -z | wl-copy"))

hl.bind(build_prefix(super_shift, { "D" }), function()
	hl.dispatch(hl.dsp.exec_cmd('notify-send -a "Hyprland" "Moved to special workspace"'))
	hl.dispatch(hl.dsp.window.move({ workspace = "special:magic" }))
end)
hl.bind(build_prefix(super_shift, { "PRINT" }), hl.dsp.exec_cmd("hyprshot -m region -o $HOME/Pictures/screenshots"))
hl.bind(build_prefix(super_shift, { "DELETE" }), hl.dsp.exec_cmd("poweroff"))
hl.bind(build_prefix(super_shift, { "ESCAPE" }), hl.dsp.exec_cmd("hyprlock"))

hl.bind(build_prefix(alt, { "F4" }), hl.dsp.window.close())
hl.bind(build_prefix(alt, { "TAB" }), hl.dsp.focus({ workspace = "-1" }))

hl.bind(build_prefix(alt_shift, { "B" }), hl.dsp.exec_cmd(bluetooth_controller))
hl.bind(build_prefix(alt_shift, { "V" }), hl.dsp.exec_cmd(audio_controller))
hl.bind(build_prefix(alt_shift, { "W" }), hl.dsp.exec_cmd("ghostty -e impala"))

-- toggle active window opacity
hl.bind(build_prefix(super, { "F1" }), function()
	local active_opacity = hl.get_config("decoration.active_opacity")
	-- local fullscreen_opacity = hl.get_config("decoration.fullscreen_opacity")

	if active_opacity >= 0.9 then
		hl.dispatch(hl.dsp.exec_cmd('notify-send -a "Hyprland" "Enabled active window opacity"'))
		hl.config({
			decoration = {
				active_opacity = 0.9,
				fullscreen_opacity = 0.9,
			},
		})
		return
	end
	hl.dispatch(hl.dsp.exec_cmd('notify-send -a "Hyprland" "Disabled active window opacity"'))

	hl.config({
		decoration = {
			active_opacity = 1,
			fullscreen_opacity = 1,
		},
	})
end)

-- Laptop multimedia keys for volume and LCD brightness
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 10%+"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 10%-"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 10%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 10%-"), { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

hl.bind(build_prefix(super, { "mouse:272" }), hl.dsp.window.drag(), { mouse = true })
hl.bind(build_prefix(super, { "mouse:273" }), hl.dsp.window.resize(), { mouse = true })

-- qs ipc calls
hl.bind(build_prefix(super_shift, { "P" }), hl.dsp.exec_cmd("qs ipc call powermenu toggle"))
