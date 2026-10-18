{
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;
    extraConfig = builtins.readFile ./hyprland.lua;
  };

  # polkitd was running but nothing existed to display an authentication prompt,
  # so anything needing auth_admin — the greeter's appearance sync, for one —
  # waited forever with no visible way to approve it.
  services.hyprpolkitagent.enable = true;

  # Only the graphical session forces ksshaskpass. Set system-wide, it also
  # applied on a TTY or over SSH, where the GUI prompt can't open.
  xdg.configFile."uwsm/env".text = ''
    export SSH_ASKPASS_REQUIRE=force
  '';
}
