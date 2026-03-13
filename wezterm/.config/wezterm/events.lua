local wezterm = require("wezterm")
local mux = wezterm.mux

wezterm.on("gui-startup", function()
  mux.spawn_window({})
end)
