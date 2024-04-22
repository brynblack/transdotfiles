{ config, ... }:

{ 
  boot.kernelModules = [ "v4l2loopback" "nvidia_uvm" ];
  boot.extraModulePackages = [
    config.boot.kernelPackages.v4l2loopback.out
  ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks.devices."luks-f08bd8ad-b9c8-4200-ab4e-9f8c7c7d8bf4".device = "/dev/disk/by-uuid/f08bd8ad-b9c8-4200-ab4e-9f8c7c7d8bf4";
}
