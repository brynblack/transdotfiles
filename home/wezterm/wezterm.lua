local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.window_background_opacity = 0.8
config.enable_tab_bar = false
-- Without it, Tab and <C-i> reach Neovim as the same byte, so mapping one maps
-- both, and <C-/> arrives as <C-_>.
config.enable_kitty_keyboard = true
-- Tabs are unused (no tab bar), so let these through to Neovim's tab mappings.
config.keys = {
  { key = "Tab", mods = "CTRL", action = wezterm.action.DisableDefaultAssignment },
  { key = "Tab", mods = "CTRL|SHIFT", action = wezterm.action.DisableDefaultAssignment },
}
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

-- Watch the directory either way: it catches Noctalia replacing the file
-- rather than rewriting it in place (a rename would otherwise orphan a file
-- watch), and the file's first appearance on a fresh setup.
wezterm.add_to_config_reload_watch_list(wezterm.config_dir .. "/colors")

if ok then
  config.colors = scheme
  wezterm.add_to_config_reload_watch_list(scheme_file)
else
  config.color_scheme = "Noctalia"
end

return config
