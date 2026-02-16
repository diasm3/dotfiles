local wezterm = require("wezterm")
local config = wezterm.config_builder()
local act = wezterm.action

config.font = wezterm.font_with_fallback({
	"FiraCode Nerd Font",
	"D2Coding",
})
config.font_size = 14



return config
