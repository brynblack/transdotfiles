{ pkgs, ... }:

{
  services.xserver = {
    enable = true;
    videoDrivers = [ "amdgpu" ];
    excludePackages = [ pkgs.xterm ];
  };

  programs.noctalia-greeter = {
    enable = true;
    settings = {
      session.default = "Hyprland (uwsm-managed)";
      user.default = "brynleyl";
      keyboard = {
        layout = "us";
        variant = "colemak";
      };
      output = {
        name = "DP-1";
        layout = "DP-1:0,0; HDMI-A-1:1920,-350";
        transforms = "DP-1:normal; HDMI-A-1:90";
      };
      cursor = {
        theme = "capitaine-cursors";
        size = 24;
        path = "${pkgs.capitaine-cursors}/share/icons";
      };
      appearance.scheme = "Synced";
    };
  };
}
