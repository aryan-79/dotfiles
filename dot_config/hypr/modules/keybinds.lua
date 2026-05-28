local super = "SUPER"
local alt = "ALT"
local super_shift = "SUPER+SHIFT"
local alt_shift = "ALT+SHIFT"

local terminal = "ghostty"
local browser = "zen-browser"
local file_manager = "nautilus"
local menu = "walker"
local bluetooth_controller = "blueberry"
local audio_controller = "pavucontrol"

local function with_prefix(prefix, keys)
	return prefix .. "+" .. table.concat(keys, "+")
end

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	hl.bind(with_prefix(super, { key }), hl.dsp.focus({ workspace = i }))
	hl.bind(with_prefix(super_shift, { key }), hl.dsp.window.move({ workspace = i }))
end

hl.bind(with_prefix(super, { "T" }), hl.dsp.exec_cmd(terminal))
hl.bind(with_prefix(super, { "B" }), hl.dsp.exec_cmd(browser))
hl.bind(with_prefix(super, { "E" }), hl.dsp.exec_cmd(file_manager))
hl.bind(with_prefix(super, { "Q" }), hl.dsp.window.close())
hl.bind(with_prefix(super, { "F" }), hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
hl.bind(with_prefix(super, { "V" }), hl.dsp.exec_cmd("walker -m clipboard"))
hl.bind(with_prefix(super, { "N" }), hl.dsp.exec_cmd("swaync-client -t -sw"))
hl.bind(with_prefix(super, { "H" }), hl.dsp.focus({ direction = "left" }))
hl.bind(with_prefix(super, { "L" }), hl.dsp.focus({ direction = "right" }))
hl.bind(with_prefix(super, { "K" }), hl.dsp.focus({ direction = "up" }))
hl.bind(with_prefix(super, { "J" }), hl.dsp.focus({ direction = "down" }))
hl.bind(with_prefix(super, { "D" }), hl.dsp.workspace.toggle_special("magic"))
hl.bind(with_prefix(super, { "SPACE" }), hl.dsp.exec_cmd(menu))
hl.bind(with_prefix(super, { "PERIOD" }), hl.dsp.exec_cmd("walker -m symbols"))
hl.bind(with_prefix(super, { "PRINT" }), hl.dsp.exec_cmd("hyprshot -m output -o $HOME/Pictures/screenshots"))
hl.bind(with_prefix(super, { "TAB" }), hl.dsp.focus({ workspace = "+1" }))

hl.bind(with_prefix(super, { "CTRL", "l" }), hl.dsp.window.swap({ direction = "left" }))
hl.bind(with_prefix(super, { "CTRL", "h" }), hl.dsp.window.swap({ direction = "right" }))
hl.bind(with_prefix(super, { "CTRL", "k" }), hl.dsp.window.swap({ direction = "up" }))
hl.bind(with_prefix(super, { "CTRL", "j" }), hl.dsp.window.swap({ direction = "down" }))
hl.bind(with_prefix(super, { "CTRL", "LEFT" }), hl.dsp.window.resize({ x = -30, y = 0 }))
hl.bind(with_prefix(super, { "CTRL", "RIGHT" }), hl.dsp.window.resize({ x = 30, y = 0 }))
hl.bind(with_prefix(super, { "CTRL", "UP" }), hl.dsp.window.resize({ x = 0, y = -30 }))
hl.bind(with_prefix(super, { "CTRL", "DOWN" }), hl.dsp.window.resize({ x = 0, y = 30 }))

hl.bind(with_prefix(super_shift, { "S" }), hl.dsp.exec_cmd("hyprshot -s -m region output --clipboard-only"))
hl.bind(with_prefix(super_shift, { "C" }), hl.dsp.exec_cmd("hyprpicker -a -f hex -z | wl-copy"))
hl.bind(with_prefix(super_shift, { "L" }), hl.dsp.window.move({ direction = "left" }))
hl.bind(with_prefix(super_shift, { "H" }), hl.dsp.window.move({ direction = "right" }))
hl.bind(with_prefix(super_shift, { "K" }), hl.dsp.window.move({ direction = "up" }))
hl.bind(with_prefix(super_shift, { "J" }), hl.dsp.window.move({ direction = "down" }))
hl.bind(with_prefix(super_shift, { "D" }), hl.dsp.window.move({ workspace = "special:magic" }))
hl.bind(with_prefix(super_shift, { "PRINT" }), hl.dsp.exec_cmd("hyprshot -m region -o $HOME/Pictures/screenshots"))
hl.bind(with_prefix(super_shift, { "DELETE" }), hl.dsp.exec_cmd("poweroff"))
hl.bind(with_prefix(super_shift, { "ESCAPE" }), hl.dsp.exec_cmd("hyprlock"))

hl.bind(with_prefix(alt, { "F4" }), hl.dsp.window.close())
hl.bind(with_prefix(alt, { "TAB" }), hl.dsp.focus({ workspace = "-1" }))

hl.bind(with_prefix(alt_shift, { "B" }), hl.dsp.exec_cmd(bluetooth_controller))
hl.bind(with_prefix(alt_shift, { "V" }), hl.dsp.exec_cmd(audio_controller))
hl.bind(with_prefix(alt_shift, { "W" }), hl.dsp.exec_cmd("ghostty -e impala"))

-- Laptop multimedia keys for volume and LCD brightness
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
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
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

hl.bind(with_prefix(super, { "mouse:272" }), hl.dsp.window.drag(), { mouse = true })
hl.bind(with_prefix(super, { "mouse:273" }), hl.dsp.window.resize(), { mouse = true })
