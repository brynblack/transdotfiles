{ config, lib, ... }:

{
  programs.kitty = {
    enable = true;
    font = {
      name = "CaskaydiaCove Nerd Font";
      size = 11;
    };
    # Skip kitty's zsh hooks; nothing here uses them
    shellIntegration.mode = "disabled";
    settings = {
      # tmux handles tabs, splits and copy/paste
      clear_all_shortcuts = true;
      # Give each kitty window its own tmux session, destroyed when the window
      # closes. Launched here rather than from zsh so other terminals (neovide's
      # :terminal, a TTY) still get a plain shell.
      shell = "${lib.getExe config.programs.tmux.package} new-session ; set-option destroy-unattached on";
      background_opacity = "0.8";
      # wezterm's default padding: 1 cell horizontally, 0.5 cell vertically,
      # which is 9px for both at this font and size (see neovide_padding in
      # home/nixvim). kitty takes pt, and 9px at scale 1 is 6.75pt.
      window_padding_width = "6.75";
      disable_ligatures = "cursor";

      # Lowest input latency: draw as soon as input arrives instead of
      # batching and waiting for vsync
      input_delay = 0;
      repaint_delay = 2;
      sync_to_monitor = false;

      # A steady cursor doesn't trigger a repaint every blink
      cursor_blink_interval = 0;
      enable_audio_bell = false;
      # Every window runs tmux, so kitty would always ask before closing one
      confirm_os_window_close = 0;
      # kitty saves a tiled window as "maximized" and requests that for every
      # new window, which Hyprland grants, covering the existing kitty
      remember_window_size = false;
      update_check_interval = 0;

      # Written by noctalia (see home/noctalia); missing until its first run
      include = "themes/noctalia.conf";
    };
  };
}
