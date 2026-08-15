{ pkgs, ... }:

{
  services.xserver = {
    enable = true;
    videoDrivers = [ "amdgpu" ];
    excludePackages = [ pkgs.xterm ];
  };

  # Replaces displayManager.dms-greeter. The module enables greetd and
  # accounts-daemon itself and writes this attrset out as greeter.toml.
  programs.noctalia-greeter = {
    enable = true;
    settings = {
      # Must be the picker label from `noctalia-greeter sessions`, not the
      # .desktop basename — this matches hyprland-uwsm.desktop's Name=.
      session.default = "Hyprland (uwsm-managed)";
      user.default = "brynleyl";

      # Without this the greeter would come up in QWERTY and the password
      # would be untypable.
      keyboard = {
        layout = "us";
        variant = "colemak";
      };

      # Mirrors the monitor block in home/hyprland/hyprland.lua. Sync can
      # supply these too, but declaring them means the greeter is laid out
      # correctly before any sync has ever run.
      output = {
        # Without this the login prompt mirrors onto every connected output.
        # Pins it to the ASUS; the layout below still covers both so wallpaper
        # and positioning stay correct on the other monitor.
        name = "DP-1";
        layout = "DP-1:0,0; HDMI-A-1:1920,-350";
        transforms = "DP-1:normal; HDMI-A-1:90";
      };

      cursor = {
        theme = "capitaine-cursors";
        size = 24;
        path = "${pkgs.capitaine-cursors}/share/icons";
      };

      # Takes the palette pushed by the shell's Settings -> Security ->
      # Noctalia Greeter -> Sync Now.
      appearance.scheme = "Synced";
    };
  };
}
