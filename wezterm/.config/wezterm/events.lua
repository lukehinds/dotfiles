local wezterm = require("wezterm")
local mux = wezterm.mux

wezterm.on("gui-startup", function()
  mux.spawn_window({})
end)

local active_bg = "#7a9970"
local inactive_bg = "#3b3b3b"

wezterm.on("update-status", function(window)
  local overrides = window:get_config_overrides() or {}
  overrides.colors = overrides.colors or {}
  overrides.colors.split = active_bg
  window:set_config_overrides(overrides)
end)

wezterm.on("format-tab-title", function(tab)
  local panes = tab.panes
  if #panes <= 1 then
    return {}
  end
  return {}
end)
