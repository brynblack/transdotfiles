local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.window_background_opacity = 1.0
config.enable_tab_bar = false
config.font_size = 12
config.font = wezterm.font_with_fallback {
  'CaskaydiaCove Nerd Font',
  'Noto Sans Mono CJK JP'
}
config.color_scheme = 'dank-theme'

return config
