{
  programs.wezterm = {
    enable = true;
    extraConfig = ''
      local wezterm = require 'wezterm'
      local config = wezterm.config_builder()

      config.window_background_opacity = 0.0
      config.enable_tab_bar = false
      config.font_size = 12
      config.font = wezterm.font 'CaskaydiaCove Nerd Font'
      config.color_scheme = 'Catppuccin Mocha'

      return config
    '';
  };
}
