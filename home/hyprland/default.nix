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
}
