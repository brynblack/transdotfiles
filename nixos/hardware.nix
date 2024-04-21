{ config, pkgs, ... }:

{
  hardware = {
    bluetooth.enable = true;

    nvidia = {
      modesetting.enable = true;
      open = true;
      nvidiaSettings = false;
      package = config.boot.kernelPackages.nvidiaPackages.production;
    };

    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        libvdpau-va-gl
      ];
    };
  };

  services.hardware.openrgb.enable = true;

  fileSystems = {
    "/mnt/stuff" = {
      device = "/dev/disk/by-id/wwn-0x50014ee263f3b567-part1";
      fsType = "ext4";
    };
    "/mnt/games" = {
      device = "/dev/disk/by-id/wwn-0x5000c500d489a950-part1";
      fsType = "ext4";
    };
  }; 
}
