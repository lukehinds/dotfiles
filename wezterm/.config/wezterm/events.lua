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

wezterm.on("format-tab-title", function(tab, tabs)
  local tab_num = tab.tab_index + 1
  local title = tab.active_pane.title
  if title and #title > 18 then
    title = title:sub(1, 18) .. ".."
  end

  local is_active = tab.is_active
  local pill_bg = is_active and "#7a9970" or "#555555"
  local pill_fg = "#1a1a1a"
  local title_fg = is_active and "#c8c8c8" or "#808080"
  local bg = is_active and "#2a2a2a" or "#1e1e1e"

  return {
    { Background = { Color = bg } },
    { Foreground = { Color = pill_bg } },
    { Text = " " },
    { Background = { Color = pill_bg } },
    { Foreground = { Color = pill_fg } },
    { Attribute = { Intensity = "Bold" } },
    { Text = " " .. tostring(tab_num) .. " " },
    { Attribute = { Intensity = "Normal" } },
    { Background = { Color = bg } },
    { Foreground = { Color = title_fg } },
    { Text = " " .. title .. " " },
  }
end)
