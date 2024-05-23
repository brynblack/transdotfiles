{ config, pkgs, lib, ... }:

{
  hardware = {
    bluetooth.enable = true;

    nvidia = {
      modesetting.enable = true;
      open = true;
      nvidiaSettings = false;
      package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
        version = "555.42.02";
        sha256_64bit = "sha256-k7cI3ZDlKp4mT46jMkLaIrc2YUx1lh1wj/J4SVSHWyk=";
        sha256_aarch64 = "sha256-3/eI1VsBzuZ3Y6RZmt3Q5HrzI2saPTqUNs6zPh5zy6w=";
        openSha256 = "sha256-3/eI1VsBzuZ3Y6RZmt3Q5HrzI2saPTqUNs6zPh5zy6w=";
        settingsSha256 = "sha256-3/eI1VsBzuZ3Y6RZmt3Q5HrzI2saPTqUNs6zPh5zy6w="; 
        persistencedSha256 = "sha256-3/eI1VsBzuZ3Y6RZmt3Q5HrzI2saPTqUNs6zPh5zy6w=";
      };
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
