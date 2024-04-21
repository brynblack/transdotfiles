{ pkgs, ... }:

{
  services.xserver = {
    enable = true;
    videoDrivers = ["nvidia"];
    excludePackages = [ pkgs.xterm ];
    desktopManager.xterm.enable = false;
    displayManager.gdm.enable = true;
  };
}
