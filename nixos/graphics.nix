{ pkgs, ... }:

{
  services = {
    xserver = {
      enable = true;
      videoDrivers = [ "nvidia" ];
      excludePackages = [ pkgs.xterm ];
      desktopManager.xterm.enable = false;
    };
    displayManager.ly.enable = true;
  };
}
