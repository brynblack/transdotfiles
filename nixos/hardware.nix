{ config, pkgs, ... }:

{
  services.blueman.enable = true;

  hardware = {
    bluetooth.enable = true;

    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      open = true;
      nvidiaSettings = false;
      package = config.boot.kernelPackages.nvidiaPackages.beta;
    };

    graphics = {
      enable = true;
      extraPackages = with pkgs; [ libvdpau-va-gl ];
    };
  };

  services = {
    hardware.openrgb = {
      enable = true;
      package = pkgs.openrgb-with-all-plugins;
    };
    udev.extraRules = ''
      SUBSYSTEM=="usb", ATTR{idVendor}=="2833", ATTR{idProduct}=="0186", MODE="0666"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1d50", ATTRS{idProduct}=="60fc", MODE:="0666"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1d50", ATTRS{idProduct}=="60fc", TAG+="uaccess"
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1d50", ATTRS{idProduct}=="60fc", MODE:="0666", TAG+="uaccess"
    '';
  };

  fileSystems = {
    "/mnt/games" = {
      device = "/dev/mapper/games";
      fsType = "ext4";
    };
  };
}
