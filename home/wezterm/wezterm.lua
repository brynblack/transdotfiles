local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.window_background_opacity = 0.8
config.enable_tab_bar = false
config.font_size = 11
config.font = wezterm.font_with_fallback({
  "CaskaydiaCove Nerd Font",
  "Noto Sans Mono CJK JP",
})
-- Noctalia writes its palette to colors/Noctalia.toml, then touches wezterm.lua
-- to make wezterm reload. That touch fails here because wezterm.lua is a
-- read-only /nix/store symlink, so load the palette ourselves and put the toml
-- on wezterm's reload watch list instead.
local scheme_file = wezterm.config_dir .. "/colors/Noctalia.toml"
local ok, scheme = pcall(wezterm.color.load_scheme, scheme_file)

if ok then
  config.colors = scheme
  wezterm.add_to_config_reload_watch_list(scheme_file)
  -- Also watch the directory, in case Noctalia replaces the file rather than
  -- rewriting it in place (a rename would otherwise orphan the file watch).
  wezterm.add_to_config_reload_watch_list(wezterm.config_dir .. "/colors")
else
  config.color_scheme = "Noctalia"
end

return config
