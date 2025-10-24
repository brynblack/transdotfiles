{ config, pkgs, ... }:

{
  services.blueman.enable = true;

  hardware = {
    bluetooth.enable = true;
    uinput.enable = true;

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
    udev = {
      packages = [ pkgs.via ];
      extraRules = ''
        SUBSYSTEM=="usb", ATTR{idVendor}=="2833", ATTR{idProduct}=="0186", MODE="0666"
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="1d50", ATTRS{idProduct}=="60fc", MODE:="0666"
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="1d50", ATTRS{idProduct}=="60fc", TAG+="uaccess"
        KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1d50", ATTRS{idProduct}=="60fc", MODE:="0666", TAG+="uaccess"
      '';
    };
  };

  fileSystems = {
    "/srv/games" = {
      device = "/dev/mapper/games";
      fsType = "ext4";
    };
    "/mnt/vault" = {
      device = "//192.168.20.4/vault";
      fsType = "cifs";
      options = let
        automount_opts = "x-systemd.automount,noauto,"
          + "x-systemd.idle-timeout=60," + "x-systemd.device-timeout=5s,"
          + "x-systemd.mount-timeout=5s";
      in [
        "${automount_opts},credentials=/etc/nixos/smb-secrets,uid=${
          toString config.users.users.brynleyl.uid
        },gid=${toString config.users.groups.users.gid}"
        "uid=1000"
        "gid=100"
        ",vers=3.1.1,seal"
        ",_netdev"
      ];
    };
  };
}
