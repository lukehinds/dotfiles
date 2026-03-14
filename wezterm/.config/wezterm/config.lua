local wezterm = require("wezterm")
local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.default_cursor_style = "SteadyBar"
config.automatically_reload_config = true
config.window_close_confirmation = "NeverPrompt"
config.adjust_window_size_when_changing_font_size = false
config.window_decorations = "RESIZE"
config.check_for_updates = false
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = false
config.font_size = 16
config.font = wezterm.font("JetBrainsMono Nerd Font")
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.tab_max_width = 32
config.window_padding = {
	left = 10,
	right = 10,
	top = 8,
	bottom = 0,
}
config.window_background_opacity = 0.94
config.macos_window_background_blur = 20
config.inactive_pane_hsb = {
	saturation = 0.5,
	brightness = 0.4,
}
config.pane_focus_follows_mouse = true
local act = wezterm.action
config.keys = {
	{ key = "Enter", mods = "CTRL", action = act({ SendString = "\x1b[13;5u" }) },
	{ key = "Enter", mods = "SHIFT", action = act({ SendString = "\x1b[13;2u" }) },
	{ key = "d", mods = "CMD", action = act({ SplitHorizontal = { domain = "CurrentPaneDomain" } }) },
	{ key = "d", mods = "CMD|SHIFT", action = act({ SplitVertical = { domain = "CurrentPaneDomain" } }) },
	{ key = "LeftArrow", mods = "CMD|SHIFT", action = act({ ActivatePaneDirection = "Left" }) },
	{ key = "RightArrow", mods = "CMD|SHIFT", action = act({ ActivatePaneDirection = "Right" }) },
	{ key = "UpArrow", mods = "CMD|SHIFT", action = act({ ActivatePaneDirection = "Up" }) },
	{ key = "DownArrow", mods = "CMD|SHIFT", action = act({ ActivatePaneDirection = "Down" }) },
	{ key = "w", mods = "CMD", action = act({ CloseCurrentPane = { confirm = false } }) },
	{ key = "z", mods = "CMD|SHIFT", action = act.TogglePaneZoomState },
	-- Option+Arrow: move by word
	{ key = "LeftArrow", mods = "OPT", action = act({ SendString = "\x1bb" }) },
	{ key = "RightArrow", mods = "OPT", action = act({ SendString = "\x1bf" }) },
	-- Cmd+Arrow: move to beginning/end of line
	{ key = "LeftArrow", mods = "CMD", action = act({ SendString = "\x01" }) },
	{ key = "RightArrow", mods = "CMD", action = act({ SendString = "\x05" }) },
}
config.hyperlink_rules = {
	{
		regex = "\\((\\w+://\\S+)\\)",
		format = "$1",
		highlight = 1,
	},
	{
		regex = "\\[(\\w+://\\S+)\\]",
		format = "$1",
		highlight = 1,
	},
	{
		regex = "\\{(\\w+://\\S+)\\}",
		format = "$1",
		highlight = 1,
	},
	{
		regex = "<(\\w+://\\S+)>",
		format = "$1",
		highlight = 1,
	},
	{
		regex = "[^(]\\b(\\w+://\\S+[)/a-zA-Z0-9-]+)",
		format = "$1",
		highlight = 1,
	},
}
return config
