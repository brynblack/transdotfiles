local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.window_background_opacity = 1.0
config.enable_tab_bar = false
config.font_size = 12
config.font = wezterm.font_with_fallback {
  'CaskaydiaCove Nerd Font',
  'Noto Sans Mono CJK JP'
}

local catppuccin_latte = wezterm.color.get_builtin_schemes()['Catppuccin Latte']
catppuccin_latte.background = '#fad9db'
config.color_schemes = {
  ['Catppuccin Latte (Sakura)'] = catppuccin_latte,
}
config.color_scheme = 'Catppuccin Latte (Sakura)'

return config
